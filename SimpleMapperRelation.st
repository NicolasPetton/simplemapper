ROE.RASQLRelation subclass: SimpleMapperRelation [
    | objectClass |

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
	    object write: each value to: each name asSymbol].
	^object
    ]

    create [
	<category: 'actions'>
	self commit: self sqlCreate.
	self discoverAttributes
    ]

    drop [
	<category: 'actions'>
	self commit: self sqlDrop.
	attributes := nil
    ]

    commit: aString [
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
]
