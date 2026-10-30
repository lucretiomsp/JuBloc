Class {
	#name : 'JuDrawRoundedRectangle',
	#superclass : 'JuDrawOperation',
	#instVars : [
		'bounds',
		'cornerSize',
		'lineThickness',
		'colour'
	],
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'as yet unclassified' }
JuDrawRoundedRectangle class >> bounds: aJuRectangle cornerSize: aNumber lineThickness: aThickness colour: aColour [
	"JUCE: Graphics::drawRoundedRectangle (Rectangle<float>, cornerSize, lineThickness)."
	^ self new
		initializeBounds: aJuRectangle cornerSize: aNumber lineThickness: aThickness colour: aColour;
		yourself
]

{ #category : 'visiting' }
JuDrawRoundedRectangle >> acceptVisitor: aVisitor [
	^ aVisitor visitDrawRoundedRectangle: self
]

{ #category : 'accessing' }
JuDrawRoundedRectangle >> bounds [
	^ bounds
]

{ #category : 'accessing' }
JuDrawRoundedRectangle >> colour [
	^ colour 
]

{ #category : 'accessing' }
JuDrawRoundedRectangle >> cornerSize [
	^ cornerSize
]

{ #category : 'initialization' }
JuDrawRoundedRectangle >> initializeBounds: aJuRectangle cornerSize: aNumber lineThickness: aThickness colour: aColour [
	bounds := aJuRectangle.
	cornerSize := aNumber.
	lineThickness := aThickness.
	colour := aColour
]

{ #category : 'accessing' }
JuDrawRoundedRectangle >> lineThickness [
	^ lineThickness 
]
