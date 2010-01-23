Eval [
    PackageLoader fileInPackage: 'DBD-SQLite'.
    FileStream fileIn: 'Session.st'.
    FileStream fileIn: 'MappedAttributes.st'.
    FileStream fileIn: 'MappingSchema.st'.
    FileStream fileIn: 'MapperRelation.st'.
    FileStream fileIn: 'MappedObject.st'.
    FileStream fileIn: 'Tests.st'.

    Session current connection: (DBI.Connection connect: 'dbi:SQLite:dbname=test.dat' user: nil password: nil).
]

ROE.RASQLRelation extend [
    for: aRelation do: aBlock [
	<category: 'private'>
	(self query: (self sqlPrinterClass print: aRelation for: self)) 
	    do: [:ea | 
		aBlock value: (RASimpleTuple relation: aRelation values: ea asArray)]
    ]
]
