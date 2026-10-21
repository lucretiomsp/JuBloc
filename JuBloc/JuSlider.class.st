"
I am a slider, mirroring JUCE''s Slider. I own a value in a range, a JuSliderStyle, and a JuLookAndFeel; I do not decide how I look. On any change I rebuild: I ask my look-and-feel for a JuDrawing and hand it to a JuBlocRenderer.

I am the boundary class. I am the only one that converts Bloc geometry into a JuRectangle, in drawingBounds, and therefore the only place rounding happens. Everything below me takes values, never elements.

My text box is a child BlTextElement. In JUCE it is a Label built by createSliderTextBox, which is outside the drawing recorder, so it has no emission path in v1.
"
Class {
	#name : 'JuSlider',
	#superclass : 'JuComponent',
	#instVars : [
		'style',
		'range',
		'value',
		'onValueChange'
	],
	#category : 'JuBloc-Slider',
	#package : 'JuBloc',
	#tag : 'Slider'
}

{ #category : 'examples' }
JuSlider class >> linearHorizontal [
	"JUCE: Slider (Slider::LinearHorizontal, Slider::NoTextBox)."
	^ self new
		style: JuSliderStyle linearHorizontal;
		yourself
]

{ #category : 'examples' }
JuSlider class >> linearVertical [
	^ self new style: JuSliderStyle linearVertical; yourself
]

{ #category : 'defaults' }
JuSlider >> defaultExtent [
	"A juce::Slider starts at 0 x 0 and its parent sizes it. Preview only: the export writes measured bounds."
	^ 200 @ 24
]

{ #category : 'event handling' }
JuSlider >> dragTo: aPoint [
	"JUCE: Pimpl::handleAbsoluteDrag, linear slider snapping to the mouse (its default)."
	self value: (self proportionOfLengthToValue:
		(self orientation fractionFor: aPoint in: self sliderBounds))
]

{ #category : 'drawing' }
JuSlider >> drawing [

	| dBounds |
	dBounds := self drawingBounds.
	^ lookAndFeel
		  drawLinearSliderIn: dBounds
		  sliderPos: self sliderPos
		  minSliderPos: (style orientation positionFor: 0 in: dBounds)
		  maxSliderPos: (style orientation positionFor: 1 in: dBounds)
		  slider: self
]

{ #category : 'drawing' }
JuSlider >> drawingBounds [
	"JUCE's getSliderLayout: my area with the text box removed."
	^ (JuRectangle origin: 0 @ 0 extent: self extent) withTrimmedLeft: textBoxWidth

]

{ #category : 'colors' }
JuSlider >> findColour: anId [
	^ colours at: anId ifAbsent: [ lookAndFeel findColour: anId ]
]

{ #category : 'event handling' }
JuSlider >> handleMouseAt: aPoint [
	| fraction |
	fraction := style orientation fractionFor: aPoint in: self drawingBounds.
	self value: minimum + (fraction * (maximum - minimum))
]

{ #category : 'initialization' }
JuSlider >> initialize [
	"JUCE's defaults: LinearHorizontal, range 0 to 10, value 0."
	super initialize.
	style := JuSliderStyle linearHorizontal.
	range := JuNormalisableRange start: 0 end: 10.
	value := 0.
	onValueChange := [ ].
	self size: self defaultExtent

]

{ #category : 'initialization' }
JuSlider >> initializeDragHandler [
	self addEventHandlerOn: BlMouseDownEvent do: [ :anEvent | self handleMouseAt: anEvent localPosition ].
	self addEventHandlerOn: BlMouseMoveEvent do: [ :anEvent |
		anEvent isPrimaryButtonPressed ifTrue: [ self handleMouseAt: anEvent localPosition ] ]
]

{ #category : 'initialization' }
JuSlider >> initializeTextElement [
	textElement := BlTextElement new
		position: 4 @ 4;
		yourself
]

{ #category : 'accessing' }
JuSlider >> minimum: aNumber maximum: anotherNumber [
	minimum := aNumber. maximum := anotherNumber. self rebuild
]

{ #category : 'event handling' }
JuSlider >> mouseDown: aBlMouseEvent [
	"JUCE: Pimpl::mouseDown, which ends by calling mouseDrag."
	self mouseDrag: aBlMouseEvent
]

{ #category : 'event handling' }
JuSlider >> mouseDrag: aBlMouseEvent [
	self dragTo: aBlMouseEvent localPosition

]

{ #category : 'accessing' }
JuSlider >> onValueChange: aBlock [
	"JUCE: onValueChange. aBlock takes no argument, or the slider."
	onValueChange := aBlock
]

{ #category : 'accessing' }
JuSlider >> orientation [ 
 ^ style orientation
]

{ #category : 'accessing' }
JuSlider >> range [ 
^ range
]

{ #category : 'accessing' }
JuSlider >> range: aNormalisableRange [
	"JUCE: setNormalisableRange. Re-snaps the value without notifying, as updateRange does."
	range := aNormalisableRange.
	value := range snapToLegalValue: value.
	self invalidate
]

{ #category : 'drawing' }
JuSlider >> rebuild [
	self removeChildren.
	self drawing acceptVisitor: (JuBlocRenderer on: self).
	textElement text: (value printShowingDecimalPlaces: 2) asRopedText.
	self addChild: textElement
]

{ #category : 'colors' }
JuSlider >> setColour: anId to: aColour [
	colours at: anId put: aColour.
	self rebuild
]

{ #category : 'drawing' }
JuSlider >> sliderPos [
	^ style orientation positionFor: self valueProportion in: self drawingBounds
]

{ #category : 'accessing' }
JuSlider >> style [ 
^ style
]

{ #category : 'accessing' }
JuSlider >> style: aSliderStyle [
	"JUCE: setSliderStyle."
	style := aSliderStyle.
	self invalidate
]

{ #category : 'accessing' }
JuSlider >> value [ 
^ value 
]

{ #category : 'accessing' }
JuSlider >> value: aNumber [
	"JUCE: setValue. Always synchronous: Bloc has one UI process."
	| newValue |
	newValue := range snapToLegalValue: aNumber.
	(newValue closeTo: value) ifTrue: [ ^ self ].
	value := newValue.
	self invalidate.
	onValueChange cull: self
]

{ #category : 'drawing' }
JuSlider >> valueProportion [
	^ (value - minimum) / (maximum - minimum)
]
