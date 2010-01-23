MappedObject subclass: PersonMock [
    | name birthday |

    PersonMock class >> mappingSchema [
	^super mappingSchema
	    hasOne: 'text' accessor: #name;
	    hasOne: 'date' accessor: #birthday
    ]

    name [^name]
    name: aString [name := aString]

    birthday [^birthday]
    birthday: aDate [birthday := aDate]
]

PersonMock subclass: ChildMock [
    | mother |

    ChildMock class >> mappingSchema [
	^super mappingSchema
	    belongsTo: MotherMock accessor: #mother
    ]

    mother [^mother]
    mother: aMotherMock [mother := aMotherMock]
]

PersonMock subclass: MotherMock [
    |  children |

    MotherMock class >> mappingSchema [
	^super mappingSchema
	    hasMany: ChildMock accessor: #children
    ]

    children [^children ifNil: [children := #()]]
    children: aCollection [children := aCollection]
]
