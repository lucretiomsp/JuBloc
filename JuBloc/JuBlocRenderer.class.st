"
I am a Visitor that realizes a JuDrawing on screen by adding a child BlElement per operation. Children are my private business: the drawing logic stays in one look-and-feel method, so this is not the exploded child tree that ICKnob had. I am the throwaway backend. A visitor painting straight onto the Alexandrie canvas replaces me without anything above me moving, and I only handle axis-aligned strokes, which covers linear sliders but not rotary.
"
Class {
	#name : 'JuBlocRenderer',
	#superclass : 'Object',
	#instVars : [
		'canvas'
	],
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'style' }
JuBlocRenderer class >> endSelectors [
	^ Dictionary newFrom: {
		#butt -> #setCapButt.
		#square -> #setCapSquare.
		#rounded -> #setCapRound }
]

{ #category : 'style' }
JuBlocRenderer class >> jointSelectors [
	"PathStrokeType::JointStyle to Alexandrie. Both sit on Cairo: 1:1, nothing lost."
	^ Dictionary newFrom: {
		#mitered -> #setJoinMiter.
		#curved -> #setJoinRound.
		#beveled -> #setJoinBevel }
]

{ #category : 'instance creation' }
JuBlocRenderer class >> on: anAeCanvas [
	^ self new
		initializeCanvas: anAeCanvas;
		yourself
]

{ #category : 'as yet unclassified' }
JuBlocRenderer >> applyStyleOf: aStrokeType [
	canvas
		perform: (self class jointSelectors at: aStrokeType jointStyle);
		perform: (self class endSelectors at: aStrokeType endStyle)
]

{ #category : 'initialization' }
JuBlocRenderer >> initializeCanvas: anAeCanvas [
	canvas := anAeCanvas
]

{ #category : 'visiting' }
JuBlocRenderer >> visitDrawing: aDrawing [
	aDrawing operations do: [ :each | each acceptVisitor: self ]

]

{ #category : 'visiting' }
JuBlocRenderer >> visitFillEllipse: anOperation [
	"Graphics::fillEllipse. Circles only, which is all V4 fills."
	| bounds |
	bounds := anOperation bounds.
	self assert: bounds width = bounds height description: 'Only circles are rendered so far'.
	canvas pathFactory: [ :aCairoContext |
		aCairoContext
			arcCenter: bounds center
			radius: bounds width / 2
			startAngle: 0
			endAngle: Float twoPi ].
	canvas setBackgroundWith: [ canvas setSourceColor: anOperation colour ].
	canvas setBorderOff.
	canvas drawFigure
]

{ #category : 'visiting' }
JuBlocRenderer >> visitStrokePath: anOperation [
	"Graphics::strokePath. In JUCE the stroke type is an argument, never Graphics state,
	 so caps and joins are restored afterwards."
	canvas restoreContextAfter: [
		canvas pathFactory: [ :aCairoContext |
			anOperation path acceptVisitor: (JuCairoPathBuilder on: aCairoContext) ].
		canvas setBackgroundOff.
		canvas setBorderBlock: [
			canvas
				setSourceColor: anOperation colour;
				setBorderWidth: anOperation strokeType strokeThickness.
			self applyStyleOf: anOperation strokeType ].
		canvas setOutskirtsCentered.
		canvas drawFigure ]
]
