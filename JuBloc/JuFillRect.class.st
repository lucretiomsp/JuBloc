Class {
	#name : 'JuFillRect',
	#superclass : 'JuDrawOperation',
	#instVars : [
		'bounds',
		'colour'
	],
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'as yet unclassified' }
JuFillRect class >> bounds: aJuRectangle colour: aColour [
	^ self new
		initializeBounds: aJuRectangle colour: aColour;
		yourself
]

{ #category : 'as yet unclassified' }
JuFillRect >> acceptVisitor: aVisitor [
	^ aVisitor visitFillRect: self
]

{ #category : 'as yet unclassified' }
JuFillRect >> bound [ 
^ bounds
]

{ #category : 'accessing' }
JuFillRect >> bounds [
	^ bounds
]

{ #category : 'as yet unclassified' }
JuFillRect >> colour [ 
^ colour 
]

{ #category : 'initialization' }
JuFillRect >> initializeBounds: aJuRectangle colour: aColour [
	bounds := aJuRectangle.
	colour := aColour
]
