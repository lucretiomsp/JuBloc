Class {
	#name : 'JuSliderTest',
	#superclass : 'TestCase',
	#instVars : [
		'slider'
	],
	#category : 'JuBloc-Tests',
	#package : 'JuBloc',
	#tag : 'Tests'
}

{ #category : 'running' }
JuSliderTest >> setUp [
	super setUp.
	slider := JuSlider linearHorizontal.
	slider forceLayout

]

{ #category : 'tests' }
JuSliderTest >> testBarKeepsAOnePixelBorder [
	| bar |
	bar := JuSlider linearBar.
	bar forceLayout.
	self
		assert: bar sliderBounds origin equals: 1 @ 1;
		assert: bar sliderBounds extent equals: 198 @ 22;
		assert: (bar linearSliderPosFor: 5) equals: 100
]

{ #category : 'tests' }
JuSliderTest >> testBarRendersThroughBloc [
	| bar form |
	bar := JuSlider linearBar.
	bar forceLayout.
	bar value: 5.
	form := bar aeAsForm.
	self
		assert: (form colorAt: 50 @ 12) asHexString equals: (bar findColour: #sliderTrack) asHexString;
		assert: (form colorAt: 0 @ 12) asHexString equals: (bar findColour: #sliderTextBoxOutline) asHexString
]

{ #category : 'tests' }
JuSliderTest >> testColourFallsThroughToTheLookAndFeel [
	self
		assert: (slider findColour: #sliderTrack)
		equals: (slider lookAndFeel findColour: #sliderTrack)

]

{ #category : 'tests' }
JuSliderTest >> testDefaultLookAndFeelWhenNoneIsSet [
	self assert: slider lookAndFeel identicalTo: JuLookAndFeel default

]

{ #category : 'tests' }
JuSliderTest >> testDragSetsTheValueFromTheMouse [
	slider startDragAt: 100 @ 3.
	slider dragTo: 100 @ 3.
	self assert: slider value equals: 5.
	slider dragTo: -40 @ 3.
	self assert: slider value equals: 0.
	slider dragTo: 400 @ 3.
	self assert: slider value equals: 10
]

{ #category : 'tests' }
JuSliderTest >> testLayoutInsetsTheTrackByTheThumbDiameter [
	self
		assert: slider sliderBounds origin equals: 12 @ 0;
		assert: slider sliderBounds extent equals: 176 @ 24
]

{ #category : 'tests' }
JuSliderTest >> testLookAndFeelIsInheritedThroughPlainElements [
	| lookAndFeel editor |
	lookAndFeel := JuLookAndFeelV4 new.
	editor := JuComponent new lookAndFeel: lookAndFeel; yourself.
	editor addChild: (BlElement new addChild: slider; yourself).
	self assert: slider lookAndFeel identicalTo: lookAndFeel
]

{ #category : 'tests' }
JuSliderTest >> testOwnColourOverridesTheLookAndFeel [
	slider setColour: #sliderThumb to: Color red.
	self assert: (slider findColour: #sliderThumb) equals: Color red

]

{ #category : 'tests' }
JuSliderTest >> testPaintRendersOnAnAlexandrieCanvas [
	"No pixels yet (phase 5): this only proves every canvas call exists in your Bloc."
	self
		shouldnt: [ slider paint acceptVisitor: (JuBlocRenderer on: (AeCanvas extent: slider extent)) ]
		raise: Error
]

{ #category : 'tests' }
JuSliderTest >> testRendersThroughBloc [
	"The whole Bloc pipeline, hook included: the thumb (value 0, x = 12) and the background track."
	| form |
	form := slider aeAsForm.
	self
		assert: (form colorAt: 12 @ 12) asHexString equals: (slider findColour: #sliderThumb) asHexString;
		assert: (form colorAt: 150 @ 12) asHexString equals: (slider findColour: #sliderBackground) asHexString
]

{ #category : 'tests' }
JuSliderTest >> testRotaryDragIsRelative [
	"Right and up both increase: 250 pixels for the whole range, clamped at the ends."
	| knob |
	knob := JuSlider rotaryHorizontalVerticalDrag.
	knob forceLayout.
	knob value: 5.
	knob startDragAt: 40 @ 40.
	knob dragTo: 65 @ 40.
	self assert: knob value equals: 6.
	knob dragTo: 65 @ 15.
	self assert: knob value equals: 7.
	knob dragTo: 900 @ 40.
	self assert: knob value equals: 10
]

{ #category : 'tests' }
JuSliderTest >> testRotaryRendersThroughBloc [
	"At value 5 the value arc ends at 12 o'clock, under the thumb."
	| knob form |
	knob := JuSlider rotaryHorizontalVerticalDrag.
	knob forceLayout.
	knob value: 5.
	form := knob aeAsForm.
	self
		assert: (form colorAt: 40 @ 14) asHexString equals: (knob findColour: #sliderThumb) asHexString;
		assert: (form colorAt: 15 @ 32) asHexString equals: (knob findColour: #rotarySliderFill) asHexString;
		assert: (form colorAt: 64 @ 32) asHexString equals: (knob findColour: #rotarySliderOutline) asHexString
]

{ #category : 'tests' }
JuSliderTest >> testRotaryUsesAllOfItsBounds [
	| knob |
	knob := JuSlider rotaryHorizontalVerticalDrag.
	knob forceLayout.
	self
		assert: knob sliderBounds origin equals: 0 @ 0;
		assert: knob sliderBounds extent equals: 80 @ 80
]

{ #category : 'tests' }
JuSliderTest >> testValueChangeNotifiesOnlyOnChange [
	| calls |
	calls := 0.
	slider onValueChange: [ calls := calls + 1 ].
	slider value: 3; value: 3.
	self assert: calls equals: 1

]

{ #category : 'tests' }
JuSliderTest >> testValueMapsToAPixelOnTheTrack [
	slider value: 5.
	self assert: (slider linearSliderPosFor: slider value) equals: 100
]

{ #category : 'tests' }
JuSliderTest >> testValueSnapsToTheInterval [
	slider range: (JuNormalisableRange start: 0 end: 10 interval: 1).
	slider value: 3.4.
	self assert: slider value equals: 3
]

{ #category : 'tests' }
JuSliderTest >> testVerticalRunsBottomToTop [
	| vertical |
	vertical := JuSlider linearVertical.
	vertical forceLayout.
	self
		assert: vertical sliderBounds origin equals: 0 @ 12;
		assert: vertical sliderBounds extent equals: 24 @ 176;
		assert: (vertical linearSliderPosFor: 0) equals: 188;
		assert: (vertical linearSliderPosFor: 10) equals: 12.
	vertical startDragAt: 3 @ 100.
	vertical dragTo: 3 @ 100.
	self assert: vertical value equals: 5
]
