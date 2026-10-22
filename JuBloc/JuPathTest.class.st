Class {
	#name : 'JuPathTest',
	#superclass : 'TestCase',
	#instVars : [
		'visits'
	],
	#category : 'JuBloc-Tests',
	#package : 'JuBloc',
	#tag : 'Tests'
}

{ #category : 'tests' }
JuPathTest >> testCopyIsIndependent [
	| original copy |
	original := JuPath new startNewSubPath: 0 @ 0; yourself.
	copy := original copy.
	copy lineTo: 10 @ 0.
	self assert: original elements size equals: 1
]

{ #category : 'tests' }
JuPathTest >> testLineToOnAnEmptyPathStartsAtOrigin [
	self
		assert: (JuPath new lineTo: 10 @ 10; yourself) elements first
		equals: (JuPathStartNewSubPath point: 0 @ 0)

]

{ #category : 'tests' }
JuPathTest >> testRecordsCallsInOrder [
	| path |
	path := JuPath new startNewSubPath: 0 @ 12; lineTo: 200 @ 12; yourself.
	self assert: path elements equals: {
		JuPathStartNewSubPath point: 0 @ 12.
		JuPathLineTo point: 200 @ 12 }
]

{ #category : 'tests' }
JuPathTest >> testVisitsElementsInOrder [
	"Self Shunt: the test case is the visitor."
	visits := OrderedCollection new.
	(JuPath new startNewSubPath: 0 @ 0; lineTo: 5 @ 0; yourself) acceptVisitor: self.
	self assert: visits asArray equals: { #start -> (0 @ 0). #line -> (5 @ 0) }

]

{ #category : 'tests' }
JuPathTest >> visitPath: aPath [
	aPath elements do: [ :each | each acceptVisitor: self ]

]

{ #category : 'tests' }
JuPathTest >> visitPathLineTo: anElement [
	visits add: #line -> anElement point
]

{ #category : 'tests' }
JuPathTest >> visitPathStartNewSubPath: anElement [
	visits add: #start -> anElement point
]
