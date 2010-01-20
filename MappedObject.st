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
	self isNew isFalse: [
	    self relation delete: self]
    ]

    insert [
	<category: 'private'>
	self relation insert: self
    ]

    update [
	<category: 'private'>
	self relation update: self
    ]
    
    setId: anInteger [
	<category: 'private'>
	id := anInteger
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
