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

{ #category : 'as yet unclassified' }
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

{ #category : 'drawing' }
JuLookAndFeelV4 >> drawLinearSliderIn: aJuRectangle sliderPos: sliderPos minSliderPos: minSliderPos maxSliderPos: maxSliderPos slider: aSlider [
	"JUCE: LookAndFeel_V4::drawLinearSlider, single-value branch."
	| orientation strokeType trackStart thumbPoint thumbDiameter |
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

{ #category : 'initialization' }
JuLookAndFeelV4 >> initialiseColours [
	"JUCE's dark scheme. The filled track really is darker than the background."
	self setColour: #sliderBackground to: (Color fromHexString: '263238').
	self setColour: #sliderTrack      to: (Color fromHexString: '181f22').
	self setColour: #sliderThumb      to: (Color fromHexString: '42a2c8').
	self setColour: #sliderTextBoxText to: Color white
]

{ #category : 'private' }
JuLookAndFeelV4 >> lineFrom: aPoint to: anotherPoint [
	"JUCE: Path p; p.startNewSubPath (a); p.lineTo (b);"
	^ JuPath new
		startNewSubPath: aPoint;
		lineTo: anotherPoint;
		yourself
]

{ #category : 'layout' }
JuLookAndFeelV4 >> sliderLayoutFor: aSlider [
	"JUCE: LookAndFeel_V2::getSliderLayout, inherited by V4. NoTextBox branch: JuBloc has no text box yet."
	^ JuSliderLayout
		sliderBounds: (aSlider localBounds reduced:
			(aSlider orientation alongAxis: (self sliderThumbDiameterFor: aSlider)))
		textBoxBounds: (JuRectangle origin: 0 @ 0 extent: 0 @ 0)
]

{ #category : 'drawing' }
JuLookAndFeelV4 >> sliderThumbDiameterFor: aSlider [
	"JUCE: getSliderThumbRadius. Measures the whole component, exactly as V4 does."
	^ aSlider orientation thumbDiameterIn: aSlider localBounds
]
