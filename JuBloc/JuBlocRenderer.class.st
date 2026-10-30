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
JuBlocRenderer class >> endStyles [
	"PathStrokeType::EndCapStyle to Alexandrie."
	^ Dictionary newFrom: {
		#butt -> [ :aCanvas | aCanvas setCapButt ].
		#square -> [ :aCanvas | aCanvas setCapSquare ].
		#rounded -> [ :aCanvas | aCanvas setCapRound ] }
]

{ #category : 'style' }
JuBlocRenderer class >> jointSelectors [
	"PathStrokeType::JointStyle to Alexandrie. Both sit on Cairo: 1:1, nothing lost."
	^ Dictionary newFrom: {
		#mitered -> #setJoinMiter.
		#curved -> #setJoinRound.
		#beveled -> #setJoinBevel }
]

{ #category : 'style' }
JuBlocRenderer class >> jointStyles [
	"PathStrokeType::JointStyle to Alexandrie, which has only setJoinMiter: limit.
	 JUCE's default miter limit, 4, is the same ratio Cairo uses."
	^ Dictionary newFrom: {
		#mitered -> [ :aCanvas | aCanvas setJoinMiter: 4.0 ].
		#curved -> [ :aCanvas | aCanvas setJoinRound ].
		#beveled -> [ :aCanvas | aCanvas setJoinBevel ] }
]

{ #category : 'instance creation' }
JuBlocRenderer class >> on: anAeCanvas [
	^ self new
		initializeCanvas: anAeCanvas;
		yourself
]

{ #category : 'as yet unclassified' }
JuBlocRenderer >> applyStyleOf: aStrokeType [
	(self class jointStyles at: aStrokeType jointStyle) value: canvas.
	(self class endStyles at: aStrokeType endStyle) value: canvas
]

{ #category : 'as yet unclassified' }
JuBlocRenderer >> fillPath: aJuPath colour: aColour [
	"Graphics::fillPath."
	canvas pathFactory: [ :aCairoContext |
		aJuPath acceptVisitor: (JuCairoPathBuilder on: aCairoContext) ].
	canvas setBackgroundWith: [ canvas setSourceColor: aColour ].
	canvas setBorderOff.
	canvas drawFigure
]

{ #category : 'initialization' }
JuBlocRenderer >> initializeCanvas: anAeCanvas [
	canvas := anAeCanvas
]

{ #category : 'as yet unclassified' }
JuBlocRenderer >> roundedRectanglePathOf: anOperation [
	^ JuPath new
		addRoundedRectangle: anOperation bounds cornerSize: anOperation cornerSize;
		yourself

]

{ #category : 'visiting' }
JuBlocRenderer >> visitDrawRect: anOperation [
	"Graphics::drawRect: the line lies inside the bounds, filled as four rectangles exactly as JUCE does."
	| left top width height line |
	left := anOperation bounds left.
	top := anOperation bounds top.
	width := anOperation bounds width.
	height := anOperation bounds height.
	line := anOperation lineThickness.
	canvas pathFactory: [ :aCairoContext |
		aCairoContext
			rectangleX: left y: top width: width height: line;
			rectangleX: left y: top + height - line width: width height: line;
			rectangleX: left y: top + line width: line height: height - (line * 2);
			rectangleX: left + width - line y: top + line width: line height: height - (line * 2) ].
	canvas setBackgroundWith: [ canvas setSourceColor: anOperation colour ].
	canvas setBorderOff.
	canvas drawFigure
]

{ #category : 'as yet unclassified' }
JuBlocRenderer >> visitDrawRoundedRectangle: anOperation [
	"Graphics::drawRoundedRectangle: the same path, stroked with PathStrokeType (lineThickness)."
	self visitStrokePath: (JuStrokePath
		path: (self roundedRectanglePathOf: anOperation)
		strokeType: (JuPathStrokeType strokeThickness: anOperation lineThickness)
		colour: anOperation colour)
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
JuBlocRenderer >> visitFillRect: anOperation [
	"Graphics::fillRect."
	| bounds |
	bounds := anOperation bounds.
	canvas pathFactory: [ :aCairoContext |
		aCairoContext rectangleX: bounds left y: bounds top width: bounds width height: bounds height ].
	canvas setBackgroundWith: [ canvas setSourceColor: anOperation colour ].
	canvas setBorderOff.
	canvas drawFigure
]

{ #category : 'as yet unclassified' }
JuBlocRenderer >> visitFillRoundedRectangle: anOperation [
	"Graphics::fillRoundedRectangle. JUCE's default context fills Path::addRoundedRectangle."
	self
		fillPath: (self roundedRectanglePathOf: anOperation)
		colour: anOperation colour
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
