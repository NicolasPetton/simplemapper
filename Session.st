Object subclass: Session [
    | connection mutex relations |

    Current := nil.

    Session class >> new [
	<category: 'instance creation'>
	self shouldNotImplement
    ]

    Session class >> current [
	<category: 'instance creation'>
	^Current ifNil: [
	    Current := self basicNew initialize]
    ]

    initialize [
	<category: 'initialize-release'>
	mutex := Semaphore forMutualExclusion.
	relations := Dictionary new
    ]

    connection [
	<category: 'accessing'>
	^connection
    ]

    connection: aConnection [
	<category: 'accessing'>
	connection := aConnection
    ]

    relationNamed: aString [
	<category: 'accessing'>
	^mutex critical: [
	    relations at: aString ifAbsentPut: [
		self connection mapperRelationClass
		    name: aString 
		    connection: self connection]]
    ]

    close [
	<category: 'actions'>
	self connection close.
	connection := relations := nil
    ]
]
