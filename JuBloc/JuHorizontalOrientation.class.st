"
I am the orientation of a slider that runs left to right. My track spans the full width at half height, and value grows with x.
"
Class {
	#name : 'JuHorizontalOrientation',
	#superclass : 'JuSliderOrientation',
	#category : 'JuBloc-Model',
	#package : 'JuBloc',
	#tag : 'Model'
}

{ #category : 'private' }
JuHorizontalOrientation >> centreLineOf: aJuRectangle [
	^ aJuRectangle top + (aJuRectangle height * 0.5)
]

{ #category : 'geometry' }
JuHorizontalOrientation >> crossExtentOf: aJuRectangle [
	^ aJuRectangle height

]

{ #category : 'geometry' }
JuHorizontalOrientation >> fractionFor: aPoint in: aJuRectangle [
	^ (((aPoint x - aJuRectangle left) / aJuRectangle width) max: 0.0) min: 1.0
]

{ #category : 'testing' }
JuHorizontalOrientation >> isHorizontal [

	^ true
]

{ #category : 'geometry' }
JuHorizontalOrientation >> pointAt: aPosition in: aJuRectangle [
	^ aPosition @ (self centreLineOf: aJuRectangle)
]

{ #category : 'geometry' }
JuHorizontalOrientation >> positionFor: aFraction in: aJuRectangle [
	^ aJuRectangle left + (aFraction * aJuRectangle width)

]

{ #category : 'geometry' }
JuHorizontalOrientation >> trackEndIn: aJuRectangle [
	^ aJuRectangle right @ (self centreLineOf: aJuRectangle)
]

{ #category : 'geometry' }
JuHorizontalOrientation >> trackStartIn: aJuRectangle [
	^ aJuRectangle left @ (self centreLineOf: aJuRectangle)

]
