Class {
	#name : 'JuLookAndFeelV4Test',
	#superclass : 'TestCase',
	#instVars : [
		'slider',
		'drawing'
	],
	#category : 'JuBloc-Tests',
	#package : 'JuBloc',
	#tag : 'Tests'
}

{ #category : 'running' }
JuLookAndFeelV4Test >> drawingFor: aSlider [
	"The bounds getSliderLayout gives a 200 x 24 slider, thumb at pixel 100."
	^ JuLookAndFeelV4 new
		drawLinearSliderIn: (JuRectangle origin: 12 @ 0 extent: 176 @ 24)
		sliderPos: 100
		minSliderPos: 12
		maxSliderPos: 12
		slider: aSlider
]

{ #category : 'running' }
JuLookAndFeelV4Test >> setUp [
	super setUp.
	slider := JuSlider linearHorizontal.
	slider forceLayout.
	drawing := self drawingFor: slider
]

{ #category : 'running' }
JuLookAndFeelV4Test >> testBackgroundTrackSpansTheBounds [
	self assert: drawing operations first path elements equals: {
		JuPathStartNewSubPath point: 12 @ 12.
		JuPathLineTo point: 188 @ 12 }
]

{ #category : 'running' }
JuLookAndFeelV4Test >> testColoursResolveThroughTheSlider [
	slider setColour: #sliderTrack to: Color red.
	drawing := self drawingFor: slider.
	self
		assert: drawing operations first colour equals: (slider findColour: #sliderBackground);
		assert: drawing operations second colour equals: Color red;
		assert: drawing operations third colour equals: (slider findColour: #sliderThumb)
]

{ #category : 'running' }
JuLookAndFeelV4Test >> testThumbIsCentredOnTheSliderPos [
	| thumb |
	thumb := drawing operations third bounds.
	self
		assert: thumb centre equals: 100 @ 12;
		assert: thumb extent equals: 12 @ 12

]

{ #category : 'running' }
JuLookAndFeelV4Test >> testTracksUseTheV4StrokeType [
	| expected |
	expected := JuPathStrokeType strokeThickness: 6 jointStyle: #curved endStyle: #rounded.
	self
		assert: drawing operations first strokeType equals: expected;
		assert: drawing operations second strokeType equals: expected
]

{ #category : 'running' }
JuLookAndFeelV4Test >> testValueTrackEndsAtTheSliderPos [
	self
		assert: drawing operations second path elements last
		equals: (JuPathLineTo point: 100 @ 12)
]
