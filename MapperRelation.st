ROE.RASQLRelation subclass: MapperRelation [
    | objectClass mutex |

    objectClass [
	<category: 'accessing'>
	^objectClass
    ]

    objectClass: aClass [
	<category: 'accessing'>
	objectClass := aClass
    ]

    table [
	<category: 'accessing'>
	^connection 
	    tableAt: self name 
	    ifAbsent: [
		self create. 
		connection tableAt: self name]
    ]

    size [
	<category: 'accessing'>
	^self table size
    ]

    objectForValues: aDictionary [
	<category: 'private'>
	| object |
	object := self objectClass new.
	object mappingSchema mappedAttributes do: [:each || value |
	    value := (aDictionary associations 
		detect: [:assoc | assoc key name = each name]
		ifNone: [nil]) ifNotNil: [:assoc | assoc value].
	    each write: value to: object].
	^object
    ]

    create [
	<category: 'actions'>
	self mutex critical: [
	    self commit: self sqlCreate.
	    self discoverAttributes]
    ]

    drop [
	<category: 'actions'>
	self mutex critical: [
	    self commit: self sqlDrop.
	    attributes := nil]
    ]

    insert: anObject [
	<category: 'actions'>
	self mutex critical: [
	    anObject setId: self size + 1.
	    self addValues: ((anObject mappingSchema mappedAttributes
		select: [:each | each sqlType notNil])
		collect: [:each | each readFrom: anObject])]
    ]

    update: anObject [
	<category: 'actions'>
	self mutex critical: [
	    self commit: (self 
		sqlUpdate: (self updateMappedValuesOf: anObject)
		where: 'id = ', anObject id printString)]
    ]
 
    updateMappedValuesOf: anObject [
	<category: 'private'>
	^(self attributes
	    inject: (ROE.RAUpdateTuple relation: self)
	    into: [:nodes :attribute | 
		nodes takeValue: 
		    ((anObject mappingSchema at: attribute name)
			readFrom: anObject) forAttribute: attribute]) nodes
    ]

    delete: anObject [
	<category: 'actions'>
	    self mutex critical: [
		self deleteFor: [:each | each id = anObject id]]
    ]

    basicExec: aString [
	<category: 'private'>
	^self table basicExec: aString
    ] 

    basicQuery: aString [
	<category: 'private'>
	^self table basicQuery: aString
    ]

    commit: aString [
	<category: 'private'>
	self subclassResponsibility
    ]

    sqlCreate [
	<category: 'private'>
	self subclassResponsibility
    ]

    sqlDrop [
	<category: 'private'>
	self subclassResponsibility
    ]

    discoverAttributes [
	<category: 'private'>
	^self table discoverAttributes collect: [:each | 
	    ROE.RASimpleAttribute named: each name relation: self]
    ]

    mutex [
	<category: 'private'>
	^mutex ifNil: [mutex := Semaphore forMutualExclusion]
    ]
]

MapperRelation subclass: SQLiteMapperRelation [
 
    commit: aString [
	<category: 'actions'>
	connection 
	    do: 'BEGIN TRANSACTION';
	    do: aString;
	    do: 'COMMIT'
    ]
   
    sqlCreate [
	<category: 'private'>
	| stream |
	stream := WriteStream on: ''.
	stream 
	    nextPutAll: 'CREATE TABLE ';
	    nextPutAll: self name;
	    nextPutAll: ' ('.
	(self objectClass mappingSchema mappedAttributes 
	    select: [:each | each sqlType notNil])
		do: [:each | stream 
		    nextPutAll: each name ;
		    nextPutAll: ' ', each sqlType]
	    separatedBy: [stream nextPutAll: ', '].
	stream nextPut: $).
	^stream contents
    ]

    sqlDrop [
	<category: 'private'>
	^'DROP TABLE ', self name
    ]
]


DBI.Connection extend [
    
    mapperRelationClass [
	self subclassResponsibility
    ]
]

DBI.SQLite.SQLiteConnection extend [
    
    mapperRelationClass [
	^SQLiteMapperRelation
    ]
]
