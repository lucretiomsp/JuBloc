"
I draw widgets the way JUCE''s LookAndFeel_V4 does, with its dark colour scheme. Three V4 defects are deliberately not reproduced: getSliderThumbRadius returns a diameter despite its name, its drawing reads slider.getHeight() instead of the bounds it was handed, and the two-value branch omits the x and y offsets so it is only correct at the origin.
"
Class {
	#name : 'JuLookAndFeelV4',
	#superclass : 'JuLookAndFeel',
	#instVars : [
		'currentColourScheme'
	],
	#category : 'JuBloc-LookAndFeel',
	#package : 'JuBloc',
	#tag : 'LookAndFeel'
}

{ #category : 'colors' }
JuLookAndFeelV4 class >> colourScheme: aColourScheme [
	"JUCE: LookAndFeel_V4 (ColourScheme)."
	^ self new
		setColourScheme: aColourScheme;
		yourself

]

{ #category : 'as yet unclassified' }
JuLookAndFeelV4 >> arcIn: aJuRectangle radius: aRadius from: fromAngle to: toAngle [
	"JUCE: Path p; p.addCentredArc (centreX, centreY, r, r, 0.0f, from, to, true);"
	^ JuPath new
		addCentredArc: aJuRectangle center
		radii: aRadius @ aRadius
		rotation: 0
		from: fromAngle
		to: toAngle
		startAsNewSubPath: true;
		yourself
]

{ #category : 'colors' }
JuLookAndFeelV4 >> colourTable [
	"LookAndFeel_V4::initialiseColours, rows ported so far."
	| scheme |
	scheme := currentColourScheme.
	^ {
		#sliderBackground.          (scheme getUIColour: #widgetBackground).
		#sliderThumb.               (scheme getUIColour: #defaultFill).
		#sliderTrack.               (scheme getUIColour: #highlightedFill).
		#rotarySliderFill.          (scheme getUIColour: #highlightedFill).
		#rotarySliderOutline.       (scheme getUIColour: #widgetBackground).
		#sliderTextBoxText.         (scheme getUIColour: #defaultText).
		#sliderTextBoxBackground.   ((scheme getUIColour: #widgetBackground) alpha: 0.0).
		#sliderTextBoxHighlight.    ((scheme getUIColour: #defaultFill) alpha: 0.4).
		#sliderTextBoxOutline.      (scheme getUIColour: #outline).
		#labelText.                 (scheme getUIColour: #defaultText).
		#labelBackground.           Color transparent.
		#labelOutline.              Color transparent.
		#resizableWindowBackground. (scheme getUIColour: #windowBackground) }
]

{ #category : 'colors' }
JuLookAndFeelV4 >> currentColourScheme [
	"JUCE: getCurrentColourScheme."
	^ currentColourScheme
]

{ #category : 'drawing' }
JuLookAndFeelV4 >> drawLinearSliderIn: aJuRectangle sliderPos: sliderPos minSliderPos: minSliderPos maxSliderPos: maxSliderPos slider: aSlider [
	"JUCE: LookAndFeel_V4::drawLinearSlider: the bar branch, else the single-value branch."
	| orientation strokeType trackStart thumbPoint thumbDiameter |
	aSlider isBar ifTrue: [ ^ self linearBarIn: aJuRectangle sliderPos: sliderPos slider: aSlider ].
	orientation := aSlider orientation.
	strokeType := JuPathStrokeType
		strokeThickness: (orientation trackWidthIn: aJuRectangle)
		jointStyle: #curved
		endStyle: #rounded.
	trackStart := orientation trackStartIn: aJuRectangle.
	thumbPoint := orientation pointAt: sliderPos in: aJuRectangle.
	thumbDiameter := self sliderThumbDiameterFor: aSlider.
	^ JuDrawing withAll: {
		JuStrokePath
			path: (self lineFrom: trackStart to: (orientation trackEndIn: aJuRectangle))
			strokeType: strokeType
			colour: (aSlider findColour: #sliderBackground).
		JuStrokePath
			path: (self lineFrom: trackStart to: thumbPoint)
			strokeType: strokeType
			colour: (aSlider findColour: #sliderTrack).
		JuFillEllipse
			bounds: ((JuRectangle origin: 0 @ 0 extent: thumbDiameter @ thumbDiameter) withCentre: thumbPoint)
			colour: (aSlider findColour: #sliderThumb) }
]

{ #category : 'as yet unclassified' }
JuLookAndFeelV4 >> drawLinearSliderOutlineIn: aJuRectangle slider: aSlider [
	"JUCE: LookAndFeel_V2::drawLinearSliderOutline, which V4 inherits. Like V2 it outlines the whole
	 component, not the bounds it is handed, and only without a text box: JuBloc has none yet."
	^ JuDrawing withAll: {
		JuDrawRect
			bounds: aSlider localBounds
			lineThickness: 1
			colour: (aSlider findColour: #sliderTextBoxOutline) }
]

{ #category : 'as yet unclassified' }
JuLookAndFeelV4 >> drawRotarySliderIn: aJuRectangle sliderPos: sliderPos rotaryStartAngle: startAngle rotaryEndAngle: endAngle slider: aSlider [
	"JUCE: LookAndFeel_V4::drawRotarySlider. V4 draws the value arc only when the slider is
	 enabled; JuComponent has no enablement yet, so it always does."
	| bounds radius toAngle lineW arcRadius strokeType thumbAngle thumbWidth thumbPoint |
	bounds := aJuRectangle reduced: 10.
	radius := (bounds width min: bounds height) / 2.
	toAngle := startAngle + (sliderPos * (endAngle - startAngle)).
	lineW := 8 min: radius * 0.5.
	arcRadius := radius - (lineW * 0.5).
	strokeType := JuPathStrokeType strokeThickness: lineW jointStyle: #curved endStyle: #rounded.
	thumbWidth := lineW * 2.
	"V4's own 12 o'clock correction for cos and sin, as in the C++."
	thumbAngle := toAngle - Float halfPi.
	thumbPoint := bounds center + ((thumbAngle cos @ thumbAngle sin) * arcRadius).
	^ JuDrawing withAll: {
		JuStrokePath
			path: (self arcIn: bounds radius: arcRadius from: startAngle to: endAngle)
			strokeType: strokeType
			colour: (aSlider findColour: #rotarySliderOutline).
		JuStrokePath
			path: (self arcIn: bounds radius: arcRadius from: startAngle to: toAngle)
			strokeType: strokeType
			colour: (aSlider findColour: #rotarySliderFill).
		JuFillEllipse
			bounds: ((JuRectangle origin: 0 @ 0 extent: thumbWidth @ thumbWidth) withCentre: thumbPoint)
			colour: (aSlider findColour: #sliderThumb) }
]

{ #category : 'colors' }
JuLookAndFeelV4 >> initialiseColours [
	"JUCE: initialiseColours. The rows live in colourTable, as I gave it in the slider message."
	self colourTable pairsDo: [ :colourId :colour | self setColour: colourId to: colour ]
]

{ #category : 'colors' }
JuLookAndFeelV4 >> initialize [
	"JUCE: LookAndFeel_V4 (): the dark scheme, then initialiseColours."
	super initialize.
	currentColourScheme := JuColourScheme dark.
	self initialiseColours
]

{ #category : 'private' }
JuLookAndFeelV4 >> lineFrom: aPoint to: anotherPoint [
	"JUCE: Path p; p.startNewSubPath (a); p.lineTo (b);"
	^ JuPath new
		startNewSubPath: aPoint;
		lineTo: anotherPoint;
		yourself
]

{ #category : 'as yet unclassified' }
JuLookAndFeelV4 >> linearBarIn: aJuRectangle sliderPos: sliderPos slider: aSlider [
	"V4's bar branch: the value part filled in trackColourId, then drawLinearSliderOutline."
	^ JuDrawing withAll: {
		JuFillRect
			bounds: (aSlider orientation barIn: aJuRectangle at: sliderPos)
			colour: (aSlider findColour: #sliderTrack).
		self drawLinearSliderOutlineIn: aJuRectangle slider: aSlider }
]

{ #category : 'colors' }
JuLookAndFeelV4 >> setColourScheme: aColourScheme [
	"JUCE: setColourScheme. Every colour is rebuilt from the new scheme."
	currentColourScheme := aColourScheme.
	self initialiseColours

]

{ #category : 'drawing' }
JuLookAndFeelV4 >> sliderBoundsFor: aSlider [
	"V2's three cases: a bar keeps a 1 px border, a rotary keeps all of its bounds,
	 a linear slider is inset by the thumb along its axis."
	aSlider isBar ifTrue: [ ^ aSlider localBounds reduced: 1 ].
	aSlider isRotary ifTrue: [ ^ aSlider localBounds ].
	^ aSlider localBounds reduced:
		(aSlider orientation alongAxis: (self sliderThumbDiameterFor: aSlider))
]

{ #category : 'drawing' }
JuLookAndFeelV4 >> sliderLayoutFor: aSlider [
	"JUCE: LookAndFeel_V2::getSliderLayout, inherited by V4. NoTextBox branch: JuBloc has no text box yet."
	^ JuSliderLayout
		sliderBounds: (self sliderBoundsFor: aSlider)
		textBoxBounds: (JuRectangle origin: 0 @ 0 extent: 0 @ 0)
]

{ #category : 'drawing' }
JuLookAndFeelV4 >> sliderThumbDiameterFor: aSlider [
	"JUCE: getSliderThumbRadius. Measures the whole component, exactly as V4 does."
	^ aSlider orientation thumbDiameterIn: aSlider localBounds
]
