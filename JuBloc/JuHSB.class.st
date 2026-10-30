Class {
	#name : 'JuHSB',
	#superclass : 'Object',
	#instVars : [
		'hue',
		'saturation',
		'brightness',
		'alpha'
	],
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'instance creation' }
JuHSB class >> hue: aHue saturation: aSaturation brightness: aBrightness alpha: anAlpha [
	^ self new
		initializeHue: aHue saturation: aSaturation brightness: aBrightness alpha: anAlpha;
		yourself
]

{ #category : 'instance creation' }
JuHSB class >> hueOf: channels [
	"JUCE: ColourHelpers::getHue, in turns. Only called when the channels differ."
	| hi span red green blue hue |
	hi := channels max.
	span := (hi - channels min) asFloat.
	red := (hi - channels first) / span.
	green := (hi - channels second) / span.
	blue := (hi - channels third) / span.
	hue := channels first = hi
		ifTrue: [ blue - green ]
		ifFalse: [
			channels second = hi
				ifTrue: [ 2.0 + red - blue ]
				ifFalse: [ 4.0 + green - red ] ].
	hue := hue / 6.0.
	^ hue < 0 ifTrue: [ hue + 1.0 ] ifFalse: [ hue ]
]

{ #category : 'instance creation' }
JuHSB class >> of: aColour [
	"JUCE: ColourHelpers::HSB (Colour), on the 8-bit channels."
	| channels hi lo saturation |
	channels := { aColour juRed. aColour juGreen. aColour juBlue }.
	hi := channels max.
	lo := channels min.
	hi = 0 ifTrue: [ ^ self hue: 0.0 saturation: 0.0 brightness: 0.0 alpha: aColour juAlpha ].
	saturation := (hi - lo) / hi asFloat.
	^ self
		hue: (saturation > 0 ifTrue: [ self hueOf: channels ] ifFalse: [ 0.0 ])
		saturation: saturation
		brightness: hi / 255.0
		alpha: aColour juAlpha
]

{ #category : 'converting' }
JuHSB >> asColour [
	"JUCE: HSB::toRGB. Every channel rounds to 8 bits."
	| v intV s h f x q t |
	v := (brightness * 255.0 max: 0.0) min: 255.0.
	intV := v rounded.
	saturation <= 0 ifTrue: [ ^ Color juR: intV g: intV b: intV a: alpha ].
	s := saturation min: 1.0.
	h := (hue - hue floor) * 6.0.
	f := h - h floor.
	x := (v * (1.0 - s)) rounded.
	q := (v * (1.0 - (s * f))) rounded.
	t := (v * (1.0 - (s * (1.0 - f)))) rounded.
	^ self colourFrom: ({
		{ intV. t. x }. { q. intV. x }. { x. intV. t }.
		{ x. q. intV }. { t. x. intV }. { intV. x. q } } at: h floor + 1)
]

{ #category : 'converting' }
JuHSB >> colourFrom: aTriple [
	^ Color juR: aTriple first g: aTriple second b: aTriple third a: alpha
]

{ #category : 'initialization' }
JuHSB >> initializeHue: aHue saturation: aSaturation brightness: aBrightness alpha: anAlpha [
	hue := aHue.
	saturation := aSaturation.
	brightness := aBrightness.
	alpha := anAlpha
]

{ #category : 'as yet unclassified' }
JuHSB >> withMultipliedSaturation: anAmount [
	^ self class
		hue: hue
		saturation: (saturation * anAmount min: 1.0)
		brightness: brightness
		alpha: alpha
]
