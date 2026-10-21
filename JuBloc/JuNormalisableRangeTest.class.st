Class {
	#name : 'JuNormalisableRangeTest',
	#superclass : 'TestCase',
	#category : 'JuBloc-Tests',
	#package : 'JuBloc',
	#tag : 'Tests'
}

{ #category : 'tests' }
JuNormalisableRangeTest >> testConvertFrom0to1IsTheInverse [
	| range |
	range := JuNormalisableRange start: 20 end: 220.
	self
		assert: (range convertFrom0to1: 1 / 2) equals: 120;
		assert: (range convertFrom0to1: (range convertTo0to1: 37)) equals: 37
]

{ #category : 'tests' }
JuNormalisableRangeTest >> testConvertTo0to1IsLinearAndClamped [
	| range |
	range := JuNormalisableRange start: 0 end: 10.
	self
		assert: (range convertTo0to1: 5) equals: 1 / 2;
		assert: (range convertTo0to1: -1) equals: 0;
		assert: (range convertTo0to1: 11) equals: 1
]

{ #category : 'tests' }
JuNormalisableRangeTest >> testRejectsInvalidRanges [
	self
		should: [ JuNormalisableRange start: 1 end: 1 ] raise: Error;
		should: [ JuNormalisableRange start: 0 end: 1 interval: -1 ] raise: Error
]

{ #category : 'tests' }
JuNormalisableRangeTest >> testSnapsToIntervalFromStart [
	| range |
	range := JuNormalisableRange start: 1 end: 10 interval: 2.
	self
		assert: (range snapToLegalValue: 3.9) equals: 3;
		assert: (range snapToLegalValue: 4) equals: 5;
		assert: (range snapToLegalValue: 42) equals: 10
]
