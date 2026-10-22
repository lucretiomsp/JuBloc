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

{ #category : 'initialization' }
JuSlider >> initialize [
	"JUCE's defaults: LinearHorizontal, range 0 to 10, value 0."

	super initialize.
	style := JuSliderStyle linearHorizontal.
	range := JuNormalisableRange start: 0 end: 10.
	value := 0.
	onValueChange := [ ].
	self extent: self defaultExtent
]

{ #category : 'as yet unclassified' }
JuSlider >> linearSliderPosFor: aValue [
	"JUCE: Pimpl::getLinearSliderPos."
	^ self orientation
		positionFor: (self valueToProportionOfLength: aValue)
		in: self sliderBounds
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

{ #category : 'as yet unclassified' }
JuSlider >> proportionOfLengthToValue: aProportion [
	^ range convertFrom0to1: aProportion
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

{ #category : 'initialization' }
JuSlider >> sliderBounds [
	"JUCE: Pimpl::sliderRect, cached in resized. Recomputed here, so never stale."
	^ (self lookAndFeel sliderLayoutFor: self) sliderBounds
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

{ #category : 'as yet unclassified' }
JuSlider >> valueToProportionOfLength: aValue [
	"JUCE: valueToProportionOfLength, virtual there too."
	^ range convertTo0to1: aValue
]
