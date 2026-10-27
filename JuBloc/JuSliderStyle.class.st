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
JuSliderStyle class >> linearHorizontal [
"JUCE: Slider::LinearHorizontal."
	^ self new
		initializeOrientation: JuHorizontalOrientation new;
		yourself
]

{ #category : 'instance creation' }
JuSliderStyle class >> linearVertical [
	^ self new initializeOrientation: JuVerticalOrientation new; yourself
]

{ #category : 'defaults' }
JuSliderStyle >> defaultExtent [
	^ orientation defaultExtent
]

{ #category : 'initialization' }
JuSliderStyle >> initializeOrientation: anOrientation [
	orientation := anOrientation
]

{ #category : 'testing' }
JuSliderStyle >> isHorizontal [ 
^ orientation isHorizontal 
]

{ #category : 'accessing' }
JuSliderStyle >> orientation [ 
^ orientation 
]
