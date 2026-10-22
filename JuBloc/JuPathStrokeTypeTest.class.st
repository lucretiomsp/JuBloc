Class {
	#name : 'JuPathStrokeTypeTest',
	#superclass : 'TestCase',
	#category : 'JuBloc-Tests',
	#package : 'JuBloc',
	#tag : 'Tests'
}

{ #category : 'tests' }
JuPathStrokeTypeTest >> testEqualityIsByValue [
	| a b |
	a := JuPathStrokeType strokeThickness: 6 jointStyle: #curved endStyle: #rounded.
	b := JuPathStrokeType strokeThickness: 6 jointStyle: #curved endStyle: #rounded.
		self
		assert: a equals: b;
		assert: a hash equals: b hash;
		deny: a equals: (JuPathStrokeType strokeThickness: 6)
]

{ #category : 'tests' }
JuPathStrokeTypeTest >> testRejectsBlocSpellings [
	self
		should: [ JuPathStrokeType strokeThickness: 6 jointStyle: #round endStyle: #rounded ] raise: Error;
		should: [ JuPathStrokeType strokeThickness: 6 jointStyle: #curved endStyle: #round ] raise: Error
]

{ #category : 'tests' }
JuPathStrokeTypeTest >> testThicknessAloneMirrorsJuceDefaults [
	| type |
	type := JuPathStrokeType strokeThickness: 1.
	self
		assert: type jointStyle equals: #mitered;
		assert: type endStyle equals: #butt

]
