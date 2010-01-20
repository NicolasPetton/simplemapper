ROE.RASQLRelation subclass: SimpleMapperRelation [
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
	^connection tableAt: self name
    ]

    size [
	<category: 'accessing'>
	^self table size
    ]

    objectForValues: aDictionary [
	<category: 'private'>
	| object |
	object := self objectClass new.
	aDictionary associationsDo: [:each |
	    object write: each value to: each key name asSymbol].
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
	    self commit: (self 
		sqlInsert: anObject mappedKeys 
		values: anObject mappedValues)]
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
		    (anObject read: attribute name asSymbol) forAttribute: attribute]) nodes
    ]

    delete: anObject [
	<category: 'actions'>
	    self mutex critical: [
		self commit: (self 
		    sqlDeleteWhere: ' id = ', self id printString)]
    ]

    commit: aString [
	<category: 'actions'>
	connection do: 'BEGIN TRANSACTION'.
	connection do: aString.
	connection do: 'COMMIT'
    ]

    basicExec: aString [
	<category: 'private'>
	^self table basicExec: aString
    ] 

    basicQuery: aString [
	<category: 'private'>
	^self table basicQuery: aString
    ]

    sqlCreate [
	"Should be a subclass responsibility"
	<category: 'private'>
	| stream |
	stream := WriteStream on: ''.
	stream 
	    nextPutAll: 'CREATE TABLE ';
	    nextPutAll: self name;
	    nextPutAll: ' ('.
	self objectClass mappingSchema mappedAttributes do: [:each |
		stream 
		    nextPutAll: each key asString;
		    nextPutAll: ' ', each value]
	    separatedBy: [stream nextPutAll: ', '].
	stream nextPut: $).
	^stream contents
    ]

    sqlDrop [
	<category: 'private'>
	^'DROP TABLE ', self name
    ]

    sqlMigrate [
	<category: 'private'>
	"should be a subclass responsibility"
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
