Object subclass: MappingSchema [
    | mappedAttributes class |

    MappingSchema class >> for: aClass [
	<category: 'instance creation'>
	^self basicNew
	    initializeWithClass: aClass;
	    yourself
    ]

    initializeWithClass: aClass [
	<category: 'initialize-release'>
	class := aClass.
	self hasOne: 'integer' accessor: #id.
    ]

    mappedAttributes [
	<category: 'accessing'>
	^mappedAttributes ifNil: [
	    mappedAttributes := OrderedCollection new]
    ]

    at: aSymbol [
	<category: 'accessing'>
	^self mappedAttributes 
	    detect: [:each | each key = aSymbol]
	    ifNone: [nil]
    ]

    valuesFrom: anObject [
	<category: 'accessing'>
	^self mappedAttributes collect: [:each |
	    each readFrom: anObject]
    ]

    keys [
	<category: 'accessing'>
	^self mappedAttributes collect: [:each | each key]
    ]

    hasOne: aSQLTypeString accessor: aSymbol [
	<category: 'mapping'>
	self mappedAttributes add: ((SQLMappedAttribute key: aSymbol)
	    sqlType: aSQLTypeString)
    ]

    hasMany: aClass accessor: aSymbol [
	<category: 'mapping'>
	self mappedAttributes add: ((ToManyMappedAttribute key: aSymbol)
	    otherClass: aClass)
    ]

    belongsTo: aClass accessor: aSymbol [
	<category: 'mapping'>
	self mappedAttributes add: ((ToOneMappedAttribute key: aSymbol)
	    otherClass: aClass)
    ]
]
