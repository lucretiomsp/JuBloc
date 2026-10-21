Class {
	#name : 'JuStrokePathTest',
	#superclass : 'TestCase',
	#category : 'JuBloc-Tests',
	#package : 'JuBloc',
	#tag : 'Tests'
}

{ #category : 'tests' }
JuStrokePathTest >> testSnapshotsItsPath [
	| path operation |
	path := JuPath new startNewSubPath: 0 @ 0; lineTo: 10 @ 0; yourself.
	operation := JuStrokePath
		path: path
		strokeType: (JuPathStrokeType strokeThickness: 1)
		colour: Color black.
	path lineTo: 20 @ 0.
	self assert: operation path elements size equals: 2
]
