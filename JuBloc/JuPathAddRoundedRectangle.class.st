Class {
	#name : 'JuPathAddRoundedRectangle',
	#superclass : 'JuPathElement',
	#instVars : [
		'bounds',
		'cornerSize'
	],
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'as yet unclassified' }
JuPathAddRoundedRectangle class >> bounds: aJuRectangle cornerSize: aNumber [
	^ self new
		initializeBounds: aJuRectangle cornerSize: aNumber;
		yourself

]

{ #category : 'accessing' }
JuPathAddRoundedRectangle >> acceptVisitor: aVisitor [
	^ aVisitor visitPathAddRoundedRectangle: self
]

{ #category : 'accessing' }
JuPathAddRoundedRectangle >> arguments [
	"Path::addRoundedRectangle (rectangle, cornerSize). JuRectangle has no =, so its two Points."
	^ { bounds origin. bounds extent. cornerSize }
]

{ #category : 'accessing' }
JuPathAddRoundedRectangle >> bounds [ 
^ bounds 
]

{ #category : 'accessing' }
JuPathAddRoundedRectangle >> cornerSize [ 
^ cornerSize 
]

{ #category : 'initialization' }
JuPathAddRoundedRectangle >> initializeBounds: aJuRectangle cornerSize: aNumber [
	bounds := aJuRectangle.
	cornerSize := aNumber
]
