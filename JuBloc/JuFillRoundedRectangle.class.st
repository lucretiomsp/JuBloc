Class {
	#name : 'JuFillRoundedRectangle',
	#superclass : 'JuDrawOperation',
	#instVars : [
		'bounds',
		'cornerSize',
		'colour'
	],
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'as yet unclassified' }
JuFillRoundedRectangle class >> bounds: aJuRectangle cornerSize: aNumber colour: aColour [
	"JUCE: Graphics::fillRoundedRectangle (Rectangle<float>, cornerSize)."
	^ self new
		initializeBounds: aJuRectangle cornerSize: aNumber colour: aColour;
		yourself
]

{ #category : 'visiting' }
JuFillRoundedRectangle >> acceptVisitor: aVisitor [
	^ aVisitor visitFillRoundedRectangle: self
]

{ #category : 'accessing' }
JuFillRoundedRectangle >> bounds [
	^ bounds
]

{ #category : 'accessing' }
JuFillRoundedRectangle >> colour [
	^ colour 
]

{ #category : 'accessing' }
JuFillRoundedRectangle >> cornerSize [
	^ cornerSize 
]

{ #category : 'initialization' }
JuFillRoundedRectangle >> initializeBounds: aJuRectangle cornerSize: aNumber colour: aColour [
	bounds := aJuRectangle.
	cornerSize := aNumber.
	colour := aColour
]
