Class {
	#name : 'JuStrokePath',
	#superclass : 'JuDrawOperation',
	#instVars : [
		'path',
		'strokeType',
		'colour'
	],
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'as yet unclassified' }
JuStrokePath class >> path: aJuPath strokeType: aJuPathStrokeType colour: aColour [
	^ self new
		initializePath: aJuPath strokeType: aJuPathStrokeType colour: aColour;
		yourself
]

{ #category : 'visiting' }
JuStrokePath >> acceptVisitor: aVisitor [
	^ aVisitor visitStrokePath: self
]

{ #category : 'accessing' }
JuStrokePath >> colour [ 
^ colour 
]

{ #category : 'initialization' }
JuStrokePath >> initializePath: aJuPath strokeType: aJuPathStrokeType colour: aColour [
	"A copy: JuPath is mutable like juce::Path, and a caller reusing it must not rewrite me."
	path := aJuPath copy.
	strokeType := aJuPathStrokeType.
	colour := aColour
]

{ #category : 'accessing' }
JuStrokePath >> path [ 
^ path 
]

{ #category : 'accessing' }
JuStrokePath >> strokeType [ 
^ strokeType
]
