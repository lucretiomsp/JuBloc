Class {
	#name : 'JuCairoPathBuilder',
	#superclass : 'Object',
	#instVars : [
		'cairoContext'
	],
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'instance creation' }
JuCairoPathBuilder class >> on: anAeCairoContext [
	^ self new
		initializeCairoContext: anAeCairoContext;
		yourself
]

{ #category : 'initialization' }
JuCairoPathBuilder >> initializeCairoContext: anAeCairoContext [
	cairoContext := anAeCairoContext
]

{ #category : 'visiting' }
JuCairoPathBuilder >> visitPath: aPath [
	"addCentredArc lands here with the rotary, and the minus pi/2 with it: the one place angles change convention."
	aPath elements do: [ :each | each acceptVisitor: self ]
]

{ #category : 'visiting' }
JuCairoPathBuilder >> visitPathAddCentredArc: anElement [
	"Path::addCentredArc. JUCE measures angles clockwise from 12 o'clock, Cairo from 3 o'clock:
	 the minus pi/2 happens here and nowhere else. Unrotated circles only, which is all V4 strokes."
	| radius from to |
	self
		assert: (anElement radii x = anElement radii y and: [ anElement rotation = 0 ])
		description: 'Only unrotated circular arcs are rendered so far'.
	radius := anElement radii x.
	from := anElement fromAngle - Float halfPi.
	to := anElement toAngle - Float halfPi.
	anElement startAsNewSubPath ifTrue: [
		cairoContext moveTo: anElement center + ((from cos @ from sin) * radius) ].
	anElement fromAngle <= anElement toAngle
		ifTrue: [ cairoContext arcCenter: anElement center radius: radius startAngle: from endAngle: to ]
		ifFalse: [ cairoContext arcNegativeCenter: anElement center radius: radius startAngle: from endAngle: to ]
]

{ #category : 'visiting' }
JuCairoPathBuilder >> visitPathLineTo: anElement [
	cairoContext lineTo: anElement point
]

{ #category : 'visiting' }
JuCairoPathBuilder >> visitPathStartNewSubPath: anElement [
	cairoContext moveTo: anElement point
]
