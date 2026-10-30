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
JuCairoPathBuilder >> visitPathAddRoundedRectangle: anElement [
	"Path::addRoundedRectangle as JUCE traces it: cubic corners with handles at 0.45 of
	 the corner size from the corner, then closeSubPath."
	| bounds x y x2 y2 csx csy cs45x cs45y |
	bounds := anElement bounds.
	x := bounds left.
	y := bounds top.
	x2 := bounds right.
	y2 := bounds bottom.
	csx := anElement cornerSize min: bounds width * 0.5.
	csy := anElement cornerSize min: bounds height * 0.5.
	cs45x := csx * 0.45.
	cs45y := csy * 0.45.
	cairoContext
		moveTo: x @ (y + csy);
		curveVia: x @ (y + cs45y) via: (x + cs45x) @ y to: (x + csx) @ y;
		lineTo: (x2 - csx) @ y;
		curveVia: (x2 - cs45x) @ y via: x2 @ (y + cs45y) to: x2 @ (y + csy);
		lineTo: x2 @ (y2 - csy);
		curveVia: x2 @ (y2 - cs45y) via: (x2 - cs45x) @ y2 to: (x2 - csx) @ y2;
		lineTo: (x + csx) @ y2;
		curveVia: (x + cs45x) @ y2 via: x @ (y2 - cs45y) to: x @ (y2 - csy);
		closePath
]

{ #category : 'visiting' }
JuCairoPathBuilder >> visitPathLineTo: anElement [
	cairoContext lineTo: anElement point
]

{ #category : 'visiting' }
JuCairoPathBuilder >> visitPathStartNewSubPath: anElement [
	cairoContext moveTo: anElement point
]
