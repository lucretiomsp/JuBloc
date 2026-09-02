"
JuSliderOrientation comment: 'I am a Strategy that knows which way a slider runs. My subclasses are JuHorizontalOrientation and JuVerticalOrientation.

I have no JUCE counterpart, deliberately. JUCE keeps this knowledge as predicates over the SliderStyle enum on Slider::Pimpl (isHorizontal, isVertical), and every caller tests them inline: 17 such tests in juce_Slider.cpp and 17 more in juce_LookAndFeel_V4.cpp. I replace all of them.

Why I exist.
The same axis fact is needed twice, by code that lives in different files in JUCE. Drawing needs it to place the track and the thumb. Interaction needs it to decide which mouse axis drives the value, where to park the cursor during a drag, and how to turn a mouse position back into a value. In JUCE those are two independent sets of conditionals that can disagree. I make disagreement impossible, because positionFor:in: and its inverse fractionFor:in: are methods on the same object, and JuLookAndFeel and JuSlider share that object.

Public API and Key Messages.
- positionFor: aFraction in: aRectangle   answers a pixel position along my axis (drawing)
- fractionFor: aPoint in: aRectangle      the inverse, clamped to 0.0 .. 1.0 (dragging)
- pointAt: aPosition in: aRectangle       lifts a position on my axis to a Point
- trackStartIn: / trackEndIn: aRectangle  the track''s extremes, in JUCE''s path order
- trackWidthIn: / thumbDiameterIn:        metrics derived from the cross extent
- isHorizontal

Note trackStartIn: answers the bottom for vertical sliders. JUCE builds the background path bottom to top and the stroke emission order must match.

Internal Representation and Key Implementation Points.
	I am stateless. All my methods are pure functions of their arguments, so instances are interchangeable and shareable.

	- I am one axis of what JUCE''s SliderStyle enum collapses into one flat list. The other two axes are value count (one, two, three) and bar-ness. Those become their own strategies when needed; do not fold them into me.
	- I have no C++ existence. Under instance emission the style is known when generating, so my methods have already answered concrete numbers before the emitter runs. Nothing about me appears in the generated plugin. My payoff is entirely on the Pharo side.
	- Adding an orientation means adding one subclass. It must never mean editing a drawing body.'
"
Class {
	#name : 'JuSliderOrientation',
	#superclass : 'Object',
	#category : 'JuBloc-model',
	#package : 'JuBloc',
	#tag : 'model'
}

{ #category : 'geometry' }
JuSliderOrientation >> crossExtentOf: aRectangle [
"The extent across my axis: height for horizontal, width for vertical."

	^ self subclassResponsibility
]

{ #category : 'converting' }
JuSliderOrientation >> fractionFor: aPoint in: aJuRectangle [
	"Pixel space to value space, clamped. Dragging uses this. Inverse of positionFor:in:."
	^ self subclassResponsibility
]

{ #category : 'testing' }
JuSliderOrientation >> isHorizontal [
	^ self subclassResponsibility
]

{ #category : 'geometry' }
JuSliderOrientation >> pointAt: aPosition in: aRectangle [
"Lift a pixel position on my axis to a Point."
	^ self subclassResponsibility
]

{ #category : 'converting' }
JuSliderOrientation >> positionFor: aFraction in: aJuRectangle [
	"Value space to pixel space. Drawing uses this."
	^ self subclassResponsibility
]

{ #category : 'metrics' }
JuSliderOrientation >> thumbDiameterIn: aJuRectangle [
	"A diameter, despite JUCE calling its counterpart getSliderThumbRadius."
	^ 12 min: ((self crossExtentOf: aJuRectangle) * 0.5) truncated
]

{ #category : 'geometry' }
JuSliderOrientation >> trackEndIn: aRectangle [

	^ self subclassResponsibility
]

{ #category : 'geometry' }
JuSliderOrientation >> trackStartIn: aRectangle [
"The track's low-value end. Bottom for vertical, matching JUCE's path order."
	^ self subclassResponsibility
]

{ #category : 'metrics' }
JuSliderOrientation >> trackWidthIn: aJuRectangle [
	^ 6.0 min: (self crossExtentOf: aJuRectangle) * 0.25

]
