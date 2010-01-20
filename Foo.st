MappedObject subclass: Foo [
    | title |

    Foo class >> mappingSchema [
	^super mappingSchema
	    hasOne: 'text' accessor: #title;
	    yourself
    ]

    title [^title ifNil: ['']]
    title: aString [title := aString]
]
