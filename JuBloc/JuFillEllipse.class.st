"
I am a filled ellipse inscribed in a JuRectangle. Slider thumbs are the usual case, where my bounds are square.
"
Class {
	#name : 'JuFillEllipse',
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
JuFillEllipse class >> bounds: aJuRectangle colour: aColour [
	^ self new initializeBounds: aJuRectangle colour: aColour; yourself
]

{ #category : 'accessing' }
JuFillEllipse >> acceptVisitor: aVisitor [
	^ aVisitor visitFillEllipse: self
]

{ #category : 'accessing' }
JuFillEllipse >> bounds [ 
^ bounds
]

{ #category : 'accessing' }
JuFillEllipse >> colour [ 
^ colour 
]

{ #category : 'initialization' }
JuFillEllipse >> initializeBounds: aJuRectangle colour: aColour [
	bounds := aJuRectangle. colour := aColour
]
