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
	    <category: 'querying'>
	    ^aRelation asSingleMappedCollection asArray
	]

	all [
	    <category: 'querying'>
	    ^self load: self relation
	]

	atId: anInteger [
	    <category: 'querying'>
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

    relation [
	<category: 'accessing'>
	^self class relation
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
	self onBeforeSave.
	self isNew
	    ifTrue: [self insert]
	    ifFalse: [self update].
	self onAfterSave
    ]

    delete [
	<category: 'actions'>
	self onBeforeDelete.
	self isNew isFalse: [
	    self relation delete: self].
	self onAfterDelete
    ]

    onBeforeSave [
	<category: 'events'>
    ]

    onAfterSave [
	<category: 'events'>
    ]

    onBeforeDelete [
	<category: 'events'>
    ]

    onAfterDelete [
	<category: 'events'>
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
