Object subclass: Cache [
    | policy objectClass objectDictionary |

    Cache class >> for: aClass [
	^self new
	    initializeWithClass: aClass;
	    yourself
    ]

    initializeWithClass: aClass [
	objectClass := aClass.
	objectDictionary := Dictionary new
    ]

    policy [
	<category: 'accessing'>
	^policy
    ]

    policy: aPolicy [
	<category: 'accessing'>
	policy := aPolicy
    ]

    objectClass [
	<category: 'accessing'>
	^objectClass
    ]
]
