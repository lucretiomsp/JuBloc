Class {
	#name : 'JuPathStartNewSubPath',
	#superclass : 'JuPathElement',
	#instVars : [
		'point'
	],
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'accessing' }
JuPathStartNewSubPath class >> point: aPoint [
	^ self new
		initializePoint: aPoint;
		yourself
]

{ #category : 'accessing' }
JuPathStartNewSubPath >> acceptVisitor: aVisitor [
	^ aVisitor visitPathStartNewSubPath: self
]

{ #category : 'accessing' }
JuPathStartNewSubPath >> arguments [

	^ { point }
]

{ #category : 'initialization' }
JuPathStartNewSubPath >> initializePoint: aPoint [
	point := aPoint
]

{ #category : 'accessing' }
JuPathStartNewSubPath >> point [ 
^ point 
]
