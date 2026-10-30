Class {
	#name : 'JuTextButton',
	#superclass : 'JuButton',
	#category : 'JuBloc-Button',
	#package : 'JuBloc',
	#tag : 'Button'
}

{ #category : 'accessing' }
JuTextButton class >> buttonText: aString [
	"JUCE: TextButton (buttonName). A juce::TextButton starts at 0 x 0 and its parent
	 sizes it; the preview gets a size here, as JuSlider's constructors do."
	^ self new
		buttonText: aString;
		extent: 100 @ 24;
		yourself
]

{ #category : 'painting' }
JuTextButton >> paintButtonHighlighted: shouldDrawButtonAsHighlighted down: shouldDrawButtonAsDown [
	"JUCE: TextButton::paintButton. drawButtonText arrives with the text operation."
	^ self lookAndFeel
		drawButtonBackground: self
		backgroundColour: (self findColour: (self toggleState
			ifTrue: [ #textButtonOn ]
			ifFalse: [ #textButton ]))
		highlighted: shouldDrawButtonAsHighlighted
		down: shouldDrawButtonAsDown
]
