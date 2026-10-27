Class {
	#name : 'JuColourScheme',
	#superclass : 'Object',
	#instVars : [
		'palette'
	],
	#category : 'JuBloc-LookAndFeel',
	#package : 'JuBloc',
	#tag : 'LookAndFeel'
}

{ #category : 'api' }
JuColourScheme class >> argb: anInteger [
	"JUCE scheme literals are 0xAARRGGBB."
	| alpha red green blue |
	alpha := (anInteger bitShift: -24) bitAnd: 16rFF.
	red := (anInteger bitShift: -16) bitAnd: 16rFF.
	green := (anInteger bitShift: -8) bitAnd: 16rFF.
	blue := anInteger bitAnd: 16rFF.
	^ (Color r: red g: green b: blue range: 255) alpha: alpha / 255.0
]

{ #category : 'instance creation' }
JuColourScheme class >> argbColours: anArrayOfNine [
	anArrayOfNine size = self roles size
		ifFalse: [ ^ self error: 'Must supply one colour for each UIColour item' ].
	^ self new
		initializePalette: (Dictionary newFrom:
			(self roles with: anArrayOfNine collect: [ :role :argb | role -> (self argb: argb) ]));
		yourself
]

{ #category : 'api' }
JuColourScheme class >> dark [
	^ self argbColours: #(
		16rff323e44 16rff263238 16rff323e44
		16rff8e989b 16rffffffff 16rff42a2c8
		16rffffffff 16rff181f22 16rffffffff )
]

{ #category : 'api' }
JuColourScheme class >> grey [
	^ self argbColours: #(
		16rff505050 16rff424242 16rff606060
		16rffa6a6a6 16rffffffff 16rff21ba90
		16rff000000 16rffffffff 16rffffffff )
]

{ #category : 'api' }
JuColourScheme class >> light [
	^ self argbColours: #(
		16rffefefef 16rffffffff 16rffffffff
		16rffdddddd 16rff000000 16rffa9a9a9
		16rffffffff 16rff42a2c8 16rff000000 )
]

{ #category : 'api' }
JuColourScheme class >> midnight [
	^ self argbColours: #(
		16rff2f2f3a 16rff191926 16rffd0d0d0
		16rff66667c 16rc8ffffff 16rffd8d8d8
		16rffffffff 16rff606073 16rff000000 )
]

{ #category : 'api' }
JuColourScheme class >> roles [
	"JUCE's UIColour enum, in order, so the stock literals below paste in verbatim."
	^ #( #windowBackground #widgetBackground #menuBackground #outline
	     #defaultText #defaultFill #highlightedText #highlightedFill #menuText )
]

{ #category : 'comparing' }
JuColourScheme >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	^ self class = anObject class and: [ palette = anObject palette ]

]

{ #category : 'accessing' }
JuColourScheme >> getUIColour: aRole [
	"JUCE: getUIColour. An unknown role is a typo, so KeyNotFound says so (JUCE asserts)."
	^ palette at: aRole
]

{ #category : 'comparing' }
JuColourScheme >> hash [ 
^ palette hash
]

{ #category : 'initialization' }
JuColourScheme >> initializePalette: aDictionary [
	palette := aDictionary
]

{ #category : 'as yet unclassified' }
JuColourScheme >> palette [ 
^ palette
]

{ #category : 'accessing' }
JuColourScheme >> palettte [ 
^ palette
]
