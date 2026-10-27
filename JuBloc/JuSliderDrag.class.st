Class {
	#name : 'JuSliderDrag',
	#superclass : 'Object',
	#category : 'JuBloc-Slider',
	#package : 'JuBloc',
	#tag : 'Slider'
}

{ #category : 'accessing' }
JuSliderDrag >> valueAt: aPoint for: aSlider [
	"Answer the value the mouse at aPoint asks aSlider for."
	^ self subclassResponsibility
]
