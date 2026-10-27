Class {
	#name : 'JuPathAddCentredArc',
	#superclass : 'JuPathElement',
	#instVars : [
		'center',
		'radii',
		'rotation',
		'fromAngle',
		'toAngle',
		'startAsNewSubPath'
	],
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'as yet unclassified' }
JuPathAddCentredArc class >> center: aCenter radii: aRadiiPoint rotation: aRotation from: fromAngle to: toAngle startAsNewSubPath: aBoolean [
	^ self new
		initializeCenter: aCenter radii: aRadiiPoint rotation: aRotation from: fromAngle to: toAngle startAsNewSubPath: aBoolean;
		yourself
]

{ #category : 'accessing' }
JuPathAddCentredArc >> acceptVisitor: aVisitor [
	^ aVisitor visitPathAddCentredArc: self
]

{ #category : 'accessing' }
JuPathAddCentredArc >> arguments [
	"Path::addCentredArc (centreX, centreY, radiusX, radiusY, rotation, from, to, startAsNewSubPath), pairs as Points."
	^ { center . radii . rotation . fromAngle . toAngle . startAsNewSubPath }
]

{ #category : 'accessing' }
JuPathAddCentredArc >> center [ 
^ center
]

{ #category : 'accessing' }
JuPathAddCentredArc >> fromAngle [
	^ fromAngle
]

{ #category : 'initialization' }
JuPathAddCentredArc >> initializeCenter: aCenter radii: aRadiiPoint rotation: aRotation from: aFromAngle to: aToAngle startAsNewSubPath: aBoolean [
	center := aCenter.
	radii := aRadiiPoint.
	rotation := aRotation.
	fromAngle := aFromAngle.
	toAngle := aToAngle.
	startAsNewSubPath := aBoolean
]

{ #category : 'accessing' }
JuPathAddCentredArc >> radii [ 
^ radii
]

{ #category : 'accessing' }
JuPathAddCentredArc >> rotation [ 
^ rotation
]

{ #category : 'accessing' }
JuPathAddCentredArc >> startAsNewSubPath [
	^ startAsNewSubPath
]

{ #category : 'accessing' }
JuPathAddCentredArc >> toAngle [ 

^ toAngle 
]
