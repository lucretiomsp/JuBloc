Class {
	#name : 'JuLinearSliderStyle',
	#superclass : 'JuSliderStyle',
	#category : 'JuBloc-Model',
	#package : 'JuBloc',
	#tag : 'Model'
}

{ #category : 't - orientable' }
JuLinearSliderStyle class >> orientation: aSliderOrientation [
	^ self new
		initializeOrientation: aSliderOrientation;
		yourself
]

{ #category : 'accessing' }
JuLinearSliderStyle >> defaultExtent [
	^ orientation defaultExtent
]

{ #category : 'accessing' }
JuLinearSliderStyle >> dragStartingAt: aPoint for: aSlider [
	"Linear and bar sliders snap to the mouse, JUCE's default: nothing to remember."
	^ JuAbsoluteDrag new
]

{ #category : 'initialization' }
JuLinearSliderStyle >> initializeOrientation: aSliderOrientation [
	orientation := aSliderOrientation
]

{ #category : 'accessing' }
JuLinearSliderStyle >> orientation [
	^ orientation
]

{ #category : 'accessing' }
JuLinearSliderStyle >> paint: aSlider [
	"JUCE: Pimpl::paint, linear branch. lastValueMin and lastValueMax stay 0 on a single-value
	 slider, so JUCE passes the position of 0 for both."
	| unsetPos |
	unsetPos := aSlider linearSliderPosFor: 0.
	^ aSlider lookAndFeel
		drawLinearSliderIn: aSlider sliderBounds
		sliderPos: (aSlider linearSliderPosFor: aSlider value)
		minSliderPos: unsetPos
		maxSliderPos: unsetPos
		slider: aSlider
]
