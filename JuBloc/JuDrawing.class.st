"
I am an ordered sequence of drawing operations, and I am one myself, so drawings nest and a visitor needs no special case. That is the Composite half of the graphics model. I drop nils on construction so a caller can build me with conditional slots inline.
"
Class {
	#name : 'JuDrawing',
	#superclass : 'JuDrawOperation',
	#instVars : [
		'operations'
	],
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'instance creation' }
JuDrawing class >> withAll: aCollection [
	^ self new
		initializeOperations: (aCollection reject: [ :each | each isNil ]);
		yourself
]

{ #category : 'initialization' }
JuDrawing >> initializeOperations: aCollection [
	operations := aCollection asArray
]

{ #category : 'accessing' }
JuDrawing >> operations [ 
^ operations 
]
