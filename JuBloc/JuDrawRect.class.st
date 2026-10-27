Class {
	#name : 'JuDrawRect',
	#superclass : 'JuDrawOperation',
	#instVars : [
		'bounds',
		'lineThickness',
		'colour'
	],
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'as yet unclassified' }
JuDrawRect class >> bounds: aJuRectangle lineThickness: aNumber colour: aColour [
	^ self new
		initializeBounds: aJuRectangle lineThickness: aNumber colour: aColour;
		yourself
]

{ #category : 'visiting' }
JuDrawRect >> acceptVisitor: aVisitor [
	^ aVisitor visitDrawRect: self
]

{ #category : 'accessing' }
JuDrawRect >> bounds [ 
^ bounds
]

{ #category : 'accessing' }
JuDrawRect >> colour [ 
^ colour
]

{ #category : 'initialization' }
JuDrawRect >> initializeBounds: aJuRectangle lineThickness: aNumber colour: aColour [
	bounds := aJuRectangle.
	lineThickness := aNumber.
	colour := aColour
]

{ #category : 'accessing' }
JuDrawRect >> lineThickness [ 
^ lineThickness 
]
