Class {
	#name : 'JuPathElement',
	#superclass : 'Object',
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'testing' }
JuPathElement class >> isAbstract [
	^ self == JuPathElement
]

{ #category : 'accessing' }
JuPathElement >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	^ self class = anObject class and: [ self arguments = anObject arguments ]

]

{ #category : 'accessing' }
JuPathElement >> acceptVisitor: aVisitor [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
JuPathElement >> arguments [
	"The arguments of the juce::Path call I stand for, in C++ order."
	^ self subclassResponsibility
]

{ #category : 'accessing' }
JuPathElement >> hash [
	^ self class hash bitXor: self arguments hash
]

{ #category : 'printing' }
JuPathElement >> printOn: aStream [
	"Shows my arguments, so a failing comparison says what differs."
	aStream
		nextPutAll: self class name;
		space;
		print: self arguments
]
