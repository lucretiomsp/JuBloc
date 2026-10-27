Class {
	#name : 'JuRotaryHorizontalVerticalDrag',
	#superclass : 'JuSliderDrag',
	#instVars : [
		'startPoint',
		'startValue'
	],
	#category : 'JuBloc-Slider',
	#package : 'JuBloc',
	#tag : 'Slider'
}

{ #category : 'accessing' }
JuRotaryHorizontalVerticalDrag class >> startingAt: aPoint value: aValue [
	^ self new
		initializeStartPoint: aPoint startValue: aValue;
		yourself
]

{ #category : 'initialization' }
JuRotaryHorizontalVerticalDrag >> initializeStartPoint: aPoint startValue: aValue [
	startPoint := aPoint.
	startValue := aValue
]

{ #category : 'accessing' }
JuRotaryHorizontalVerticalDrag >> valueAt: aPoint for: aSlider [
	"JUCE: Pimpl::handleAbsoluteDrag, RotaryHorizontalVerticalDrag: right and up both increase,
	 mouseDragSensitivity pixels for the whole range, clamped at the ends (stopAtEnd)."
	| mouseDiff proportion |
	mouseDiff := (aPoint x - startPoint x) + (startPoint y - aPoint y).
	proportion := (aSlider valueToProportionOfLength: startValue)
		+ (mouseDiff / aSlider mouseDragSensitivity).
	^ aSlider proportionOfLengthToValue: proportion
]
