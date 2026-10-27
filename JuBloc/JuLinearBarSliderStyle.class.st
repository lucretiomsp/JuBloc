Class {
	#name : 'JuLinearBarSliderStyle',
	#superclass : 'JuLinearSliderStyle',
	#category : 'JuBloc-Model',
	#package : 'JuBloc',
	#tag : 'Model'
}

{ #category : 'accessing' }
JuLinearBarSliderStyle >> defaultExtent [
	^ 80 @ 80
]

{ #category : 'accessing' }
JuLinearBarSliderStyle >> dragStartingAt: aPoint for: aSlider [
	"A relative drag needs where it started and from which value."
	^ JuRotaryHorizontalVerticalDrag startingAt: aPoint value: aSlider value
]

{ #category : 'testing' }
JuLinearBarSliderStyle >> isBar [
	^ true
]

{ #category : 'testing' }
JuLinearBarSliderStyle >> isRotary [
	^ true
]

{ #category : 'accessing' }
JuLinearBarSliderStyle >> paint: aSlider [
	"JUCE: Pimpl::paint, rotary branch: the position is a proportion, not a pixel."
	^ aSlider lookAndFeel
		drawRotarySliderIn: aSlider sliderBounds
		sliderPos: (aSlider valueToProportionOfLength: aSlider value)
		rotaryStartAngle: aSlider rotaryParameters startAngleRadians
		rotaryEndAngle: aSlider rotaryParameters endAngleRadians
		slider: aSlider
]
