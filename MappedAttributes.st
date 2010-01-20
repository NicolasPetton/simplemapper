Object subclass: MappedAttribute [
    | key |

    MappedAttribute class >> key: aString [
	<category: 'instance creation'>
	^self new
	    initializeWithKey: aString
    ]

    initializeWithKey: aString [
	<category: 'instance creation'>
	key := aString
    ]

    name [
	<category: 'accessing'>
	^self key asString
    ]

    key [
	<category: 'accessing'>
	^key
    ]

    sqlType [
	<category: 'accessing'>
	^nil
    ]

    write: aValue to: anObject [
	<category: 'mapping'>
	self subclassResponsibility
    ]

    readFrom: anObject [
	<category: 'mapping'>
	self subclassResponsibility
    ]
]

MappedAttribute subclass: SQLMappedAttribute [
    | sqlType |

    sqlType: aString [
	<category: 'accessing'>
	sqlType := aString
    ]

    sqlType [
	<category: 'accessing'>
	^sqlType
    ]

    write: aValue to: anObject [
	<category: 'mapping'>
	anObject write: aValue to: self key
    ]

    readFrom: anObject [
	<category: 'mapping'>
	^anObject read: self key
    ]
]

MappedAttribute subclass: RelationMappedAttribute [
    | objectClass |

    objectClass [
	<category: 'accessing'>
	^objectClass
    ]

    objectClass: aClass [
	<category: 'accessing'>
	objectClass := aClass
    ]
]

RelationMappedAttribute subclass: ToOneMappedAttribute [
    
    name [
	<category: 'accessing'>
	^self class tableName, 'ID'
    ]

    sqlType [
	<category: 'accessing'>
	^'integer'
    ]

    write: aValue to: anObject [
	<category: 'mapping'>
	anObject 
	    write: (objectClass atId: aValue)
	    to: self key
    ]

    readFrom: anObject [
	<category: 'mapping'>
	^(anObject read: self key) id
    ]
]

RelationMappedAttribute subclass: ToManyMappedAttribute [
    
    
]
