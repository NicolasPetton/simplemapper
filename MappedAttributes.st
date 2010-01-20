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

    key [
	<category: 'accessing'>
	^key
    ]

    value [
	<category: 'accessing'>
	self subclassResponsibility
    ]
]

MappedAttribute subclass: SQLMappedAttribute [
    | type |

    type [
	<category: 'accessing'>
	^type
    ]

    type: aString [
	<category: 'accessing'>
	type := aString
    ]

    value [
	<category: 'accessing'>
	^self type
    ]
]

MappedAttribute subclass: RelationMappedAttribute [
    | class |

    class [
	<category: 'accessing'>
	^class
    ]

    class: aClass [
	<category: 'accessing'>
	class := aClass
    ]
]

RelationMappedAttribute subclass: ToOneMappedAttribute []

RelationMappedAttribute subclass: ToManyMappedAttribute []
