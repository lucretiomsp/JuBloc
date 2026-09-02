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

{ #category : 'testing' }
JuVerticalOrientation >> centreLineOf: aJuRectangle [
	^ aJuRectangle left + (aJuRectangle width * 0.5)
]

{ #category : 'testing' }
JuVerticalOrientation >> crossExtentOf: aJuRectangle [
	^ aJuRectangle width

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

{ #category : 'testing' }
JuVerticalOrientation >> trackEndIn: aJuRectangle [
	^ (self centreLineOf: aJuRectangle) @ aJuRectangle top
]

{ #category : 'testing' }
JuVerticalOrientation >> trackStartIn: aJuRectangle [
	^ (self centreLineOf: aJuRectangle) @ aJuRectangle bottom
]
