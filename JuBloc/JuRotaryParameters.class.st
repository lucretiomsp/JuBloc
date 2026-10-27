Class {
	#name : 'JuRotaryParameters',
	#superclass : 'Object',
	#instVars : [
		'startAngleRadians',
		'endAngleRadians',
		'stopAtEnd'
	],
	#category : 'JuBloc-Slider',
	#package : 'JuBloc',
	#tag : 'Slider'
}

{ #category : 'as yet unclassified' }
JuRotaryParameters class >> default [
	"JUCE: Slider::Pimpl's defaults."
	^ self startAngleRadians: Float pi * 1.2 endAngleRadians: Float pi * 2.8 stopAtEnd: true
]

{ #category : 'as yet unclassified' }
JuRotaryParameters class >> startAngleRadians: aStartAngle endAngleRadians: anEndAngle stopAtEnd: aBoolean [
	^ self new
		initializeStartAngleRadians: aStartAngle endAngleRadians: anEndAngle stopAtEnd: aBoolean;
		yourself
]

{ #category : 'accessing' }
JuRotaryParameters >> endAngleRadians [
	^ endAngleRadians
]

{ #category : 'initialization' }
JuRotaryParameters >> initializeStartAngleRadians: aStartAngle endAngleRadians: anEndAngle stopAtEnd: aBoolean [
	startAngleRadians := aStartAngle.
	endAngleRadians := anEndAngle.
	stopAtEnd := aBoolean
]

{ #category : 'accessing' }
JuRotaryParameters >> startAngleRadians [
	^ startAngleRadians
]

{ #category : 'accessing' }
JuRotaryParameters >> stopAtEnd [
	^ stopAtEnd
]
