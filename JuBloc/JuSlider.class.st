"
I am a slider, mirroring JUCE''s Slider. I own a value in a range, a JuSliderStyle, and a JuLookAndFeel; I do not decide how I look. On any change I rebuild: I ask my look-and-feel for a JuDrawing and hand it to a JuBlocRenderer.

I am the boundary class. I am the only one that converts Bloc geometry into a JuRectangle, in drawingBounds, and therefore the only place rounding happens. Everything below me takes values, never elements.

My text box is a child BlTextElement. In JUCE it is a Label built by createSliderTextBox, which is outside the drawing recorder, so it has no emission path in v1.
"
Class {
	#name : 'JuSlider',
	#superclass : 'BlElement',
	#instVars : [
		'value',
		'minimum',
		'maximum',
		'style',
		'lookAndFeel',
		'colours',
		'textBoxWidth',
		'textElement'
	],
	#category : 'JuBloc-widgets',
	#package : 'JuBloc',
	#tag : 'widgets'
}

{ #category : 'examples' }
JuSlider class >> linearHorizontal [
	^ self new style: JuSliderStyle linearHorizontal; yourself

]

{ #category : 'examples' }
JuSlider class >> linearVertical [
	^ self new style: JuSliderStyle linearVertical; yourself
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
	super initialize.
	minimum := 0.0.
	maximum := 1.0.
	value := 0.5.
	style := JuSliderStyle linearHorizontal.
	lookAndFeel := JuLookAndFeel default.
	colours := Dictionary new.
	textBoxWidth := 60.
	self size: 260 @ 24.
	self background: (Color fromHexString: '323e44').
	self initializeTextElement.
	self initializeDragHandler.
	self rebuild


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
JuSlider >> style: aStyle [ 

style := aStyle.
self rebuild
]

{ #category : 'accessing' }
JuSlider >> value [ 
^ value 
]

{ #category : 'accessing' }
JuSlider >> value: aNumber [

value := (aNumber max: minimum) min: maximum.
	self rebuild
]

{ #category : 'drawing' }
JuSlider >> valueProportion [
	^ (value - minimum) / (maximum - minimum)
]
