Extension { #name : 'Color' }

{ #category : '*JuBloc' }
Color >> juAlpha [
	^ (self alpha * 255) rounded

]

{ #category : '*JuBloc' }
Color >> juBlue [
	^ (self blue * 255) rounded

]

{ #category : '*JuBloc' }
Color >> juContrasting: anAmount [
	"JUCE: contrasting (amount): black over a light colour, white over a dark one."
	^ self juOverlaidWith: ((self juPerceivedBrightness >= 0.5
		ifTrue: [ Color black ]
		ifFalse: [ Color white ]) juWithAlpha: anAmount)

]

{ #category : '*JuBloc' }
Color >> juGreen [
	^ (self green * 255) rounded

]

{ #category : '*JuBloc' }
Color >> juOverlaidWith: aColour [
	"JUCE: overlaidWith, integer arithmetic included."
	| destAlpha invA resA da |
	destAlpha := self juAlpha.
	destAlpha <= 0 ifTrue: [ ^ aColour ].
	invA := 255 - aColour juAlpha.
	resA := 255 - (((255 - destAlpha) * invA) bitShift: -8).
	resA <= 0 ifTrue: [ ^ self ].
	da := invA * destAlpha // resA.
	^ Color
		juR: aColour juRed + (((self juRed - aColour juRed) * da) bitShift: -8)
		g: aColour juGreen + (((self juGreen - aColour juGreen) * da) bitShift: -8)
		b: aColour juBlue + (((self juBlue - aColour juBlue) * da) bitShift: -8)
		a: resA
]

{ #category : '*JuBloc' }
Color >> juPerceivedBrightness [
	"JUCE: getPerceivedBrightness."
	^ ((0.241 * (self juRed / 255.0) squared)
		+ (0.691 * (self juGreen / 255.0) squared)
		+ (0.068 * (self juBlue / 255.0) squared)) sqrt
]

{ #category : '*JuBloc' }
Color class >> juR: r g: g b: b a: a [
	"juce::Colour (uint8 r, uint8 g, uint8 b, uint8 a): JUCE keeps 8 bits a channel."

	| aColor |
	aColor := self new.

	^ (aColor
		   r: r
		   g: g
		   b: b
		   range: 255) alpha: a / 255.0
]

{ #category : '*JuBloc' }
Color >> juR: r g: g b: b a: a [ 
	^ self class juR: r g: g b: b a: a 
]

{ #category : '*JuBloc' }
Color >> juRed [
	^ (self red * 255) rounded

]

{ #category : '*JuBloc' }
Color >> juWithAlpha: aFloat [
	"JUCE: withAlpha (float). alpha: truncates (0.05 gives 12); JUCE rounds (13)."
	^ self alpha: (aFloat * 255) rounded / 25
]

{ #category : '*JuBloc' }
Color >> juWithMultipliedAlpha: aMultiplier [
	"JUCE: withMultipliedAlpha."
	^ self alpha: ((aMultiplier * self juAlpha) rounded min: 255) / 255.0
]

{ #category : '*JuBloc' }
Color >> juWithMultipliedSaturation: anAmount [
	"JUCE: withMultipliedSaturation, through JUCE's 8-bit HSB."
	^ ((JuHSB of: self) withMultipliedSaturation: anAmount) asColour
]
