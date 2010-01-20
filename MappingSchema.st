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

    keys [
	<category: 'accessing'>
	^self mappedAttributes collect: [:each | each key]
    ]

    hasOne: aSQLTypeString accessor: aSymbol [
	<category: 'mapping'>
	self mappedAttributes add: ((SQLMappedAttribute key: aSymbol)
	    type: aSQLTypeString)
    ]

    hasMany: aClass accessor: aSymbol [
	<category: 'mapping'>
	self mappedAttributes add: ((ToManyMappedAttribute key: aSymbol)
	    class: aClass)
    ]

    belongsTo: aClass accessor: aSymbol [
	<category: 'mapping'>
	self mappedAttributes add: ((ToOneMappedAttribute key: aSymbol)
	    class: aClass)
    ]
]
