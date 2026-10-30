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
		'onValueChange',
		'rotaryParameters',
		'drag'
	],
	#category : 'JuBloc-Slider',
	#package : 'JuBloc',
	#tag : 'Slider'
}

{ #category : 'instance creation' }
JuSlider class >> linearBar [
	"JUCE: Slider (Slider::LinearBar, Slider::NoTextBox)."
	^ self style: JuSliderStyle linearBar
]

{ #category : 'instance creation' }
JuSlider class >> linearBarVertical [
	"JUCE: Slider (Slider::LinearBarVertical, Slider::NoTextBox)."
	^ self style: JuSliderStyle linearBarVertical
]

{ #category : 'examples' }
JuSlider class >> linearHorizontal [
	"JUCE: Slider (Slider::LinearHorizontal, Slider::NoTextBox)."
	^ self style: JuSliderStyle linearHorizontal
]

{ #category : 'examples' }
JuSlider class >> linearVertical [
	"JUCE: Slider (Slider::LinearVertical, Slider::NoTextBox)."
	^ self style: JuSliderStyle linearVertical
]

{ #category : 'instance creation' }
JuSlider class >> rotaryHorizontalVerticalDrag [
	"JUCE: Slider (Slider::RotaryHorizontalVerticalDrag, Slider::NoTextBox), the usual knob."
	^ self style: JuSliderStyle rotaryHorizontalVerticalDrag
]

{ #category : 'accessing' }
JuSlider class >> style: aSliderStyle [
	"JUCE: Slider (style, NoTextBox), sized for the preview."
	^ self new
		style: aSliderStyle;
		extent: aSliderStyle defaultExtent;
		yourself
]

{ #category : 'event handling' }
JuSlider >> dragTo: aPoint [
	"JUCE: Pimpl::mouseDrag in absolute mode (no velocity drag)."
	self value: (drag valueAt: aPoint for: self)
]

{ #category : 'initialization' }
JuSlider >> initialize [
	"JUCE's defaults: LinearHorizontal, range 0 to 10, value 0, rotary from 1.2 pi to 2.8 pi,
	 size 0 x 0 (the parent sizes it). The constructors give the preview its size, from the style."
	super initialize.
	style := JuSliderStyle linearHorizontal.
	range := JuNormalisableRange start: 0 end: 10.
	value := 0.
	rotaryParameters := JuRotaryParameters default.
	onValueChange := [ ]
]

{ #category : 'event handling' }
JuSlider >> isBar [
	"JUCE: Slider::isBar."
	^ style isBar
]

{ #category : 'event handling' }
JuSlider >> isRotary [
	"JUCE: Slider::isRotary."
	^ style isRotary
]

{ #category : 'helpers' }
JuSlider >> linearSliderPosFor: aValue [
	"JUCE: Pimpl::getLinearSliderPos."
	^ self orientation
		positionFor: (self valueToProportionOfLength: aValue)
		in: self sliderBounds
]

{ #category : 'event handling' }
JuSlider >> mouseDown: aMouseEvent [
	"JUCE: Pimpl::mouseDown: the drag starts here, then mouseDrag runs once."
	self startDragAt: aMouseEvent position.
	self mouseDrag: aMouseEvent

]

{ #category : 'event handling' }
JuSlider >> mouseDrag: aMouseEvent [
	self dragTo: aMouseEvent position
]

{ #category : 'event handling' }
JuSlider >> mouseDragSensitivity [
	"JUCE: getMouseDragSensitivity, the pixels for a full sweep."
	^ 250
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

{ #category : 'painting' }
JuSlider >> paint [
	"JUCE: Pimpl::paint. The style picks the linear or the rotary drawing."
	^ style paint: self
]

{ #category : 'helpers' }
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

{ #category : 'event handling' }
JuSlider >> rotaryParameters [
	"JUCE: getRotaryParameters."
	^ rotaryParameters
]

{ #category : 'event handling' }
JuSlider >> rotaryParameters: aRotaryParameters [
	"JUCE: setRotaryParameters."
	rotaryParameters := aRotaryParameters.
	self invalidate
]

{ #category : 'initialization' }
JuSlider >> sliderBounds [
	"JUCE: Pimpl::sliderRect, cached in resized. Recomputed here, so never stale."
	^ (self lookAndFeel sliderLayoutFor: self) sliderBounds
]

{ #category : 'event handling' }
JuSlider >> startDragAt: aPoint [
	drag := style dragStartingAt: aPoint for: self
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

{ #category : 'helpers' }
JuSlider >> valueToProportionOfLength: aValue [
	"JUCE: valueToProportionOfLength, virtual there too."
	^ range convertTo0to1: aValue
]
