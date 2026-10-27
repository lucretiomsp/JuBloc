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
	vertical dragTo: 3 @ 100.
	self assert: vertical value equals: 5
]
