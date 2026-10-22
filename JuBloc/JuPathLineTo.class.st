Class {
	#name : 'JuPathLineTo',
	#superclass : 'JuPathElement',
	#instVars : [
		'point'
	],
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'accessing' }
JuPathLineTo class >> point: aPoint [
	^ self new
		initializePoint: aPoint;
		yourselfs
]

{ #category : 'accessing' }
JuPathLineTo >> acceptVisitor: aVisitor [
	^ aVisitor visitPathLineTo: self
]

{ #category : 'accessing' }
JuPathLineTo >> arguments [ 
^ { point }
]

{ #category : 'initialization' }
JuPathLineTo >> initializePoint: aPoint [
	point := aPoint
]

{ #category : 'accessing' }
JuPathLineTo >> point [ 
^ point
]
