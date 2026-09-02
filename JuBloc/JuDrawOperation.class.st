Class {
	#name : 'JuDrawOperation',
	#superclass : 'Object',
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'visiting' }
JuDrawOperation >> acceptVisitor: aVisitor [
	^ self subclassResponsibility
]
