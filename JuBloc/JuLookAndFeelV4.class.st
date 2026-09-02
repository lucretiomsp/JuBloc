"
I draw widgets the way JUCE''s LookAndFeel_V4 does, with its dark colour scheme. Three V4 defects are deliberately not reproduced: getSliderThumbRadius returns a diameter despite its name, its drawing reads slider.getHeight() instead of the bounds it was handed, and the two-value branch omits the x and y offsets so it is only correct at the origin.
"
Class {
	#name : 'JuLookAndFeelV4',
	#superclass : 'JuLookAndFeel',
	#category : 'JuBloc-LookAndFeel',
	#package : 'JuBloc',
	#tag : 'LookAndFeel'
}

{ #category : 'drawing' }
JuLookAndFeelV4 >> drawLinearSliderIn: aJuRectangle sliderPos: sliderPos minSliderPos: minSliderPos maxSliderPos: maxSliderPos slider: aSlider [

	| orientation trackWidth thumbPoint diameter |
	orientation := aSlider style orientation.
	trackWidth := orientation trackWidthIn: aJuRectangle.
	thumbPoint := orientation pointAt: sliderPos in: aJuRectangle.
	diameter := orientation thumbDiameterIn: aJuRectangle.

	^ JuDrawing withAll: {
		JuStrokeLine
			from: (orientation trackStartIn: aJuRectangle)
			to: (orientation trackEndIn: aJuRectangle)
			width: trackWidth
			colour: (aSlider findColour: #sliderBackground) .
		JuStrokeLine
			from: (orientation trackStartIn: aJuRectangle)
			to: thumbPoint
			width: trackWidth
			colour: (aSlider findColour: #sliderTrack) .
		JuFillEllipse
			bounds: (JuRectangle
				origin: thumbPoint - (diameter / 2)
				extent: diameter @ diameter)
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
