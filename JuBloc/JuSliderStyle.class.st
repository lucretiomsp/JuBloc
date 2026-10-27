"
I am what a slider looks like, and I map to JUCE''s Slider::SliderStyle enum. That enum flattens four independent axes into 13 values: orientation, value count, bar-ness, and (for the rotary family only) drag mode. I hold those axes separately, one composed strategy each. For now only orientation exists; the rest arrive when two-value, bar or rotary styles do. Do not turn me into slider subclasses: a hierarchy has to pick one axis for its spine and there are four.
"
Class {
	#name : 'JuSliderStyle',
	#superclass : 'Object',
	#instVars : [
		'orientation'
	],
	#category : 'JuBloc-Model',
	#package : 'JuBloc',
	#tag : 'Model'
}

{ #category : 'instance creation' }
JuSliderStyle class >> linearBar [
	"JUCE: Slider::LinearBar."
	^ JuLinearBarSliderStyle orientation: JuHorizontalOrientation new
]

{ #category : 'instance creation' }
JuSliderStyle class >> linearBarVertical [
	"JUCE: Slider::LinearBarVertical."
	^ JuLinearBarSliderStyle orientation: JuVerticalOrientation new
]

{ #category : 'instance creation' }
JuSliderStyle class >> linearHorizontal [
	"JUCE: Slider::LinearHorizontal."
	^ JuLinearSliderStyle orientation: JuHorizontalOrientation new
]

{ #category : 'instance creation' }
JuSliderStyle class >> linearVertical [
	"JUCE: Slider::LinearVertical."
	^ JuLinearSliderStyle orientation: JuVerticalOrientation new
]

{ #category : 'instance creation' }
JuSliderStyle class >> rotaryHorizontalVerticalDrag [
	"JUCE: Slider::RotaryHorizontalVerticalDrag, the usual knob."
	^ JuRotarySliderStyle new
]

{ #category : 'accessing' }
JuSliderStyle >> defaultExtent [
	"The preview's starting size. A juce::Slider starts at 0 x 0 and its parent sizes it."
	^ self subclassResponsibility
]

{ #category : 'accessing' }
JuSliderStyle >> dragStartingAt: aPoint for: aSlider [
	"Answer the JuSliderDrag for a gesture starting at aPoint."
	^ self subclassResponsibility
]

{ #category : 'initialization' }
JuSliderStyle >> initializeOrientation: anOrientation [
	orientation := anOrientation
]

{ #category : 'testing' }
JuSliderStyle >> isBar [
	"JUCE: Slider::isBar."
	^ false
]

{ #category : 'testing' }
JuSliderStyle >> isHorizontal [ 
^ orientation isHorizontal 
]

{ #category : 'testing' }
JuSliderStyle >> isRotary [
	"JUCE: Slider::isRotary."
	^ false
]

{ #category : 'accessing' }
JuSliderStyle >> orientation [ 
^ orientation 
]

{ #category : 'accessing' }
JuSliderStyle >> paint: aSlider [
	"JUCE: Slider::Pimpl::paint, which asks the look and feel for a linear or a rotary drawing."
	^ self subclassResponsibility
]
