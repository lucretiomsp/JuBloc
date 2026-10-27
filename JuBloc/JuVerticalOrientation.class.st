"
JuVerticalOrientation comment: 'I am the orientation of a slider that runs bottom to top. My track spans the full height at half width, and value grows as y decreases. Note trackStartIn: answers my bottom: JUCE builds the background path bottom to top and the stroke order must match.'
"
Class {
	#name : 'JuVerticalOrientation',
	#superclass : 'JuSliderOrientation',
	#category : 'JuBloc-Model',
	#package : 'JuBloc',
	#tag : 'Model'
}

{ #category : 'geometry' }
JuVerticalOrientation >> alongAxis: aNumber [
	^ 0 @ aNumber
]

{ #category : 'testing' }
JuVerticalOrientation >> centreLineOf: aJuRectangle [
	^ aJuRectangle left + (aJuRectangle width * 0.5)
]

{ #category : 'testing' }
JuVerticalOrientation >> crossExtentOf: aJuRectangle [
	^ aJuRectangle width

]

{ #category : 'defaults' }
JuVerticalOrientation >> defaultExtent [
	^ 24 @ 200
]

{ #category : 'testing' }
JuVerticalOrientation >> fractionFor: aPoint in: aJuRectangle [
	^ (((aJuRectangle bottom - aPoint y) / aJuRectangle height) max: 0.0) min: 1.0
]

{ #category : 'testing' }
JuVerticalOrientation >> isHorizontal [
 
^ false
]

{ #category : 'testing' }
JuVerticalOrientation >> pointAt: aPosition in: aJuRectangle [
	^ (self centreLineOf: aJuRectangle) @ aPosition
]

{ #category : 'converting' }
JuVerticalOrientation >> positionFor: aFraction in: aJuRectangle [
	"Value space to pixel space: 0 at the bottom, 1 at the top."
	^ aJuRectangle bottom - (aFraction * aJuRectangle height)
]

{ #category : 'testing' }
JuVerticalOrientation >> trackEndIn: aJuRectangle [
	^ (self centreLineOf: aJuRectangle) @ aJuRectangle top
]

{ #category : 'testing' }
JuVerticalOrientation >> trackStartIn: aJuRectangle [
	^ (self centreLineOf: aJuRectangle) @ aJuRectangle bottom
]
