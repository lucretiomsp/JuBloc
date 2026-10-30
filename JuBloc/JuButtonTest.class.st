Class {
	#name : 'JuButtonTest',
	#superclass : 'TestCase',
	#instVars : [
		'button',
		'clicks'
	],
	#category : 'JuBloc-Tests',
	#package : 'JuBloc',
	#tag : 'Tests'
}

{ #category : 'running' }
JuButtonTest >> backgroundHighlighted: isHighlighted down: isDown [
	^ JuLookAndFeelV4 new
		drawButtonBackground: button
		backgroundColour: (button findColour: #textButton)
		highlighted: isHighlighted
		down: isDown
]

{ #category : 'running' }
JuButtonTest >> setUp [
	super setUp.
	button := JuTextButton buttonText: 'Play'.
	button forceLayout.
	clicks := 0.
	button onClick: [ clicks := clicks + 1 ]
]

{ #category : 'tests' }
JuButtonTest >> testClickingTogglesState [
	button clickingTogglesState: true.
	button triggerClick.
	self
		assert: button toggleState;
		assert: clicks equals: 1.
	button triggerClick.
	self
		deny: button toggleState;
		assert: clicks equals: 2
]

{ #category : 'tests' }
JuButtonTest >> testHoverHighlightsWithoutClicking [
	button mouseEnteredAt: 10 @ 10.
	self
		assert: button buttonState equals: #buttonOver;
		deny: button isDown;
		assert: clicks equals: 0
]

{ #category : 'tests' }
JuButtonTest >> testLeavingWhilePressedCancelsTheClick [
	"Below Bloc's drag threshold, leaving arrives as a mouse leave, not a drag."
	button
		mousePressedAt: 10 @ 10;
		mouseExitedAt: 150 @ 10.
	self assert: button buttonState equals: #buttonNormal.
	button mouseReleasedAt: 150 @ 10.
	self
		assert: clicks equals: 0;
		assert: button buttonState equals: #buttonNormal
]

{ #category : 'tests' }
JuButtonTest >> testMovingBackInKeepsTheClick [
	button
		mousePressedAt: 10 @ 10;
		mouseMovedAt: 150 @ 10;
		mouseMovedAt: 20 @ 10;
		mouseReleasedAt: 20 @ 10.
	self assert: clicks equals: 1
]

{ #category : 'tests' }
JuButtonTest >> testPressAndReleaseOverTheButtonClicks [
	button
		mouseEnteredAt: 10 @ 10;
		mousePressedAt: 10 @ 10.
	self assert: button isDown.
	button mouseReleasedAt: 10 @ 10.
	self
		assert: clicks equals: 1;
		assert: button buttonState equals: #buttonOver
]

{ #category : 'tests' }
JuButtonTest >> testReleaseWithoutPressIsIgnored [
	"Bloc sends a release to whatever is under the mouse; JUCE only to the pressed component."
	button mouseReleasedAt: 10 @ 10.
	self
		assert: clicks equals: 0;
		assert: button buttonState equals: #buttonNormal
]

{ #category : 'tests' }
JuButtonTest >> testRendersThroughBloc [
	| form |
	form := button aeAsForm.
	self
		assert: (form colorAt: 50 @ 12) asHexString
		equals: (Color juR: 40 g: 51 b: 56 a: 255) asHexString
]

{ #category : 'tests' }
JuButtonTest >> testStateChangesReportAMomentaryPress [
	"A Faust button reads onStateChange and isDown, as Faust's JuceGUI does."
	| downs |
	downs := OrderedCollection new.
	button onStateChange: [ :aButton | downs add: aButton isDown ].
	button
		mouseEnteredAt: 10 @ 10;
		mousePressedAt: 10 @ 10;
		mouseReleasedAt: 10 @ 10.
	self assert: downs asArray equals: #( false true false )
]

{ #category : 'tests' }
JuButtonTest >> testV4BackgroundFollowsTheState [
	"JUCE's numbers for the dark scheme: 0xff263238 at saturation 0.9, then contrasting
	 0.05 when highlighted and 0.2 when down."
	self
		assert: (self backgroundHighlighted: false down: false) operations first colour
		equals: (Color juR: 40 g: 51 b: 56 a: 255).
	self
		assert: (self backgroundHighlighted: true down: false) operations first colour
		equals: (Color juR: 51 g: 62 b: 66 a: 255).
	self
		assert: (self backgroundHighlighted: true down: true) operations first colour
		equals: (Color juR: 83 g: 92 b: 96 a: 255)
]

{ #category : 'tests' }
JuButtonTest >> testV4BackgroundIsInsetByHalfAPixel [
	| fill outline |
	fill := (self backgroundHighlighted: false down: false) operations first.
	outline := (self backgroundHighlighted: false down: false) operations second.
	self
		assert: fill bounds origin equals: 0.5 @ 0.5;
		assert: fill bounds extent equals: 99 @ 23;
		assert: fill cornerSize equals: 6;
		assert: outline lineThickness equals: 1;
		assert: outline colour equals: (button findColour: #comboBoxOutline)
]
