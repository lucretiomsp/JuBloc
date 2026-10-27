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

{ #category : 'as yet unclassified' }
JuLookAndFeelV4Test >> rotaryDrawing [
	"V4's knob in 80 x 80 at half travel, with JUCE's default angles."
	^ JuLookAndFeelV4 new
		drawRotarySliderIn: (JuRectangle origin: 0 @ 0 extent: 80 @ 80)
		sliderPos: 1 / 2
		rotaryStartAngle: Float pi * 1.2
		rotaryEndAngle: Float pi * 2.8
		slider: JuSlider rotaryHorizontalVerticalDrag
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

{ #category : 'tests' }
JuLookAndFeelV4Test >> testBarFillsUpToTheSliderPos [
	| bar drawing fill outline |
	bar := JuSlider linearBar.
	bar forceLayout.
	drawing := JuLookAndFeelV4 new
		drawLinearSliderIn: (JuRectangle origin: 1 @ 1 extent: 198 @ 22)
		sliderPos: 100
		minSliderPos: 1
		maxSliderPos: 1
		slider: bar.
	fill := drawing operations first bounds.
	outline := drawing operations second operations first.
	self
		assert: fill origin equals: 1 @ 1.5;
		assert: fill extent equals: 99 @ 21;
		assert: outline bounds extent equals: 200 @ 24;
		assert: outline lineThickness equals: 1
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

{ #category : 'tests' }
JuLookAndFeelV4Test >> testMissingColourIsResumableBlack [
	| lookAndFeel |
	lookAndFeel := JuLookAndFeelV4 new.
	self should: [ lookAndFeel findColour: #noSuchColour ] raise: JuMissingColour.
	self
		assert: ([ lookAndFeel findColour: #noSuchColour ] on: JuMissingColour do: [ :warning | warning resume ])
		equals: Color black
]

{ #category : 'tests' }
JuLookAndFeelV4Test >> testRotaryArcsFollowTheAngles [
	| background valueArc |
	background := self rotaryDrawing operations first.
	valueArc := self rotaryDrawing operations second path elements first.
	self
		assert: background strokeType strokeThickness equals: 8;
		assert: background path elements first radii equals: 26 @ 26;
		assert: background path elements first toAngle equals: Float pi * 2.8;
		assert: (valueArc toAngle closeTo: Float twoPi)
]

{ #category : 'tests' }
JuLookAndFeelV4Test >> testRotaryThumbSitsAtTheValueAngle [
	| thumb |
	thumb := self rotaryDrawing operations third bounds.
	self
		assert: (thumb center x closeTo: 40);
		assert: (thumb center y closeTo: 14);
		assert: thumb extent equals: 16 @ 16
]

{ #category : 'tests' }
JuLookAndFeelV4Test >> testSchemeFeedsTheSliderColours [
	| scheme lookAndFeel |
	scheme := JuColourScheme light.
	lookAndFeel := JuLookAndFeelV4 colourScheme: scheme.
	self
		assert: (lookAndFeel findColour: #sliderBackground) equals: (scheme getUIColour: #widgetBackground);
		assert: (lookAndFeel findColour: #sliderThumb) equals: (scheme getUIColour: #defaultFill);
		assert: (lookAndFeel findColour: #sliderTrack) equals: (scheme getUIColour: #highlightedFill)
]

{ #category : 'running' }
JuLookAndFeelV4Test >> testThumbIsCentredOnTheSliderPos [
	| thumb |
	thumb := drawing operations third bounds.
	self
		assert: thumb center equals: 100 @ 12;
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
