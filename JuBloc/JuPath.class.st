Class {
	#name : 'JuPath',
	#superclass : 'Object',
	#instVars : [
		'elements'
	],
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'comparing' }
JuPath >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	^ self class = anObject class and: [ self elements = anObject elements ]

]

{ #category : 'accessing' }
JuPath >> acceptVisitor: aVisitor [
	^ aVisitor visitPath: self
]

{ #category : 'adding' }
JuPath >> addCentredArc: aCenter radii: aRadiiPoint rotation: aRotation from: fromAngle to: toAngle startAsNewSubPath: aBoolean [
	"JUCE: Path::addCentredArc. Angles in radians, clockwise from 12 o'clock."
	elements add: (JuPathAddCentredArc
		center: aCenter
		radii: aRadiiPoint
		rotation: aRotation
		from: fromAngle
		to: toAngle
		startAsNewSubPath: aBoolean)
]

{ #category : 'adding' }
JuPath >> addRoundedRectangle: aJuRectangle cornerSize: aCornerSize [
	"JUCE: Path::addRoundedRectangle (rectangle, cornerSize), all four corners curved."
	elements add: (JuPathAddRoundedRectangle bounds: aJuRectangle cornerSize: aCornerSize)

]

{ #category : 'accessing' }
JuPath >> elements [
	"A snapshot: my own collection never leaves me."
	^ elements asArray
]

{ #category : 'comparing' }
JuPath >> hash [
	^ self elements hash
]

{ #category : 'initialization' }
JuPath >> initialize [
	super initialize.
	elements := OrderedCollection new
]

{ #category : 'path commands' }
JuPath >> lineTo: aPoint [
	"Like juce::Path, a line on an empty path starts at 0 @ 0. Explicit, because Cairo would start at aPoint."
	elements ifEmpty: [ self startNewSubPath: 0 @ 0 ].
	elements add: (JuPathLineTo point: aPoint)
]

{ #category : 'accessing' }
JuPath >> postCopy [
	super postCopy.
	elements := elements copy
]

{ #category : 'path commands' }
JuPath >> startNewSubPath: aPoint [
	elements add: (JuPathStartNewSubPath point: aPoint)

]
