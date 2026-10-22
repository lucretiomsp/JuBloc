Class {
	#name : 'JuMissingColour',
	#superclass : 'Warning',
	#instVars : [
		'colourId'
	],
	#category : 'JuBloc-LookAndFeel',
	#package : 'JuBloc',
	#tag : 'LookAndFeel'
}

{ #category : 'signalling' }
JuMissingColour class >> signalColourId: aColourId [
	^ self new
		initializeColourId: aColourId;
		signal
]

{ #category : 'accessing' }
JuMissingColour >> colourId [ 
^ colourId 
]

{ #category : 'initialization' }
JuMissingColour >> initializeColourId: aColourId [
	colourId := aColourId

]

{ #category : 'accessing' }
JuMissingColour >> messageText [ 
^ 'No colour registered for {1}' format: { colourId printString }
]
