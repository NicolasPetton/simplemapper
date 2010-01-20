Object subclass: MappedObject [
    | id |

    MappedObject class [

	tableName [
	    <category: 'accessing'>
	    ^self name asLowercase
	]

	mappingSchema [
	    <category: 'accessing'>
	    ^MappingSchema for: self
	]

	relation [
	    <category: 'accessing'>
	    ^(self session relationNamed: self tableName)
		objectClass: self
	]

	session [
	    <category: 'accessing'>
	    ^Session current
	]

	create [
	    <category: 'actions'>
	    self relation create
	]

	migrate [
	    <category: 'actions'>
	    self notYetImplemented
	]

	drop [
	    <category: 'actions'>
	    self relation drop
	]

	load: aRelation [
	    <category: 'actions'>
	    ^aRelation asSingleMappedCollection asArray
	]

	loadAll [
	    <category: 'actions'>
	    ^self load: self relation
	]

	loadId: anInteger [
	    <category: 'actions'>
	    | array |
	    array := self load: (self relation select: [:each |
		each id = anInteger]).
	    ^array isEmpty
		ifTrue: [nil]
		ifFalse: [array first]
	]
    ]

    mappingSchema [
	<category: 'accessing'>
	^self class mappingSchema
    ]
   
    mappedKeys [
	<category: 'accessing'>
	^self mappingSchema keys
    ]

    mappedValues [
	<category: 'accessing'>
	^self mappedKeys collect: [:each |
	    self read: each]
    ]

    id [
	<category: 'accessing'>
	^id
    ]

    id: anInteger [
	<category: 'accessing'>
	id := anInteger
    ]

    relation [
	<category: 'accessing'>
	^self class relation
    ]

    isNew [
	<category: 'testing'>
	^self id isNil
    ]

    save [
	<category: 'actions'>
	self isNew
	    ifTrue: [self insert]
	    ifFalse: [self update]
    ]

    delete [
	<category: 'actions'>
	self hasId ifTrue: [
	    self relation commit: 
		(self relation sqlDeleteWhere: ' id = ', self id printString)]
    ]

    insert [
	"Should use a mutex for that. What about delegating it to the relation?"
	<category: 'private'>
	id := self relation size + 1.
	self relation commit: (self relation 
	    sqlInsert: self mappedKeys values: self mappedValues).
    ]

    update [
	<category: 'private'>
	self relation basicExec: (self relation
	    sqlUpdate: self updateMappedValues where: 'id=', id asString)
    ]
    
    updateMappedValues [
	<category: 'private'>
	^((self relation attributes)
	    inject: (ROE.RAUpdateTuple relation: self relation)
	    into: [:nodes :attribute | 
		nodes takeValue: 
		    (self read: attribute name asSymbol) forAttribute: attribute]) nodes
    ]

    read: aSymbol [
	<category: 'private'>
	^self perform: aSymbol
    ]

    write: anObject to: aSymbol [
	<category: 'private'>
	self perform: (aSymbol, ':') asSymbol with: anObject
    ] 
]
