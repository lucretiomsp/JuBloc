"
'I am juce::Slider::SliderLayout: the drawing area and the text box area a look and feel decides for a slider. JuLookAndFeel >> sliderLayoutFor: builds me, JuSlider reads my sliderBounds. I am immutable: no setters.
"
Class {
	#name : 'JuSliderLayout',
	#superclass : 'Object',
	#instVars : [
		'sliderBounds',
		'textBoxBounds'
	],
	#category : 'JuBloc-Slider',
	#package : 'JuBloc',
	#tag : 'Slider'
}

{ #category : 'as yet unclassified' }
JuSliderLayout class >> sliderBounds: aJuRectangle textBoxBounds: anotherJuRectangle [
	^ self new
		initializeSliderBounds: aJuRectangle textBoxBounds: anotherJuRectangle;
		yourself
]

{ #category : 'initialization' }
JuSliderLayout >> initializeSliderBounds: aJuRectangle textBoxBounds: anotherJuRectangle [
	sliderBounds := aJuRectangle.
	textBoxBounds := anotherJuRectangle
]

{ #category : 'initialization' }
JuSliderLayout >> sliderBounds [ 
^ sliderBounds
]

{ #category : 'initialization' }
JuSliderLayout >> textBoxBounds [ 
^textBoxBounds 
]
