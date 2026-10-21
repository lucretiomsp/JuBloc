Class {
	#name : 'JuNormalisableRange',
	#superclass : 'Object',
	#instVars : [
		'start',
		'end',
		'interval'
	],
	#category : 'JuBloc-Slider',
	#package : 'JuBloc',
	#tag : 'Slider'
}

{ #category : 'private - text' }
JuNormalisableRange class >> start: aStart end: anEnd [
	^ self start: aStart end: anEnd interval: 0
]

{ #category : 'private - text' }
JuNormalisableRange class >> start: aStart end: anEnd interval: anInterval [
	"JUCE asserts these in checkInvariants. Failing here means no invalid range exists,
	 so getLinearSliderPos's 0.5 fallback for an empty range has nothing to guard."
	anEnd > aStart ifFalse: [ ^ self error: 'A range must end after it starts' ].
	anInterval < 0 ifTrue: [ ^ self error: 'An interval cannot be negative' ].
	^ self new
		initializeStart: aStart end: anEnd interval: anInterval;
		yourself
]

{ #category : 'comparing' }
JuNormalisableRange >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	^ self class = anObject class and: [
		start = anObject start and: [
		end = anObject end and: [
		interval = anObject interval ] ] ]
]

{ #category : 'converting' }
JuNormalisableRange >> convertFrom0to1: aProportion [
	^ start + ((end - start) * ((aProportion max: 0) min: 1))
]

{ #category : 'converting' }
JuNormalisableRange >> convertTo0to1: aValue [
	"Linear until skew arrives."
	^ (((aValue - start) / (end - start)) max: 0) min: 1
]

{ #category : 'accessing' }
JuNormalisableRange >> end [ 
^ end
]

{ #category : 'comparing' }
JuNormalisableRange >> hash [
	^ (start hash bitXor: end hash) bitXor: interval hash
]

{ #category : 'initialization' }
JuNormalisableRange >> initializeStart: aStart end: anEnd interval: anInterval [
	start := aStart.
	end := anEnd.
	interval := anInterval
]

{ #category : 'accessing' }
JuNormalisableRange >> interval [ 
^ interval
]

{ #category : 'converting' }
JuNormalisableRange >> snapToLegalValue: aValue [
	"Rounds to the interval counted from start, then clamps."
	| snapped |
	snapped := interval > 0
		ifTrue: [ start + (interval * ((aValue - start) / interval + 0.5) floor) ]
		ifFalse: [ aValue ].
	^ (snapped max: start) min: end
]

{ #category : 'accessing' }
JuNormalisableRange >> start [ 
^ start
]
