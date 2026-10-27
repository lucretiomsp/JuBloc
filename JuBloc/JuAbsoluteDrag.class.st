Class {
	#name : 'JuAbsoluteDrag',
	#superclass : 'JuSliderDrag',
	#category : 'JuBloc-Slider',
	#package : 'JuBloc',
	#tag : 'Slider'
}

{ #category : 'accessing' }
JuAbsoluteDrag >> valueAt: aPoint for: aSlider [
	"JUCE: Pimpl::handleAbsoluteDrag, linear styles snapping to the mouse."
	^ aSlider proportionOfLengthToValue:
		(aSlider orientation fractionFor: aPoint in: aSlider sliderBounds)
]
