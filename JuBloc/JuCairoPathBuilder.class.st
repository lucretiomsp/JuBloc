Class {
	#name : 'JuCairoPathBuilder',
	#superclass : 'Object',
	#instVars : [
		'cairoContext'
	],
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'instance creation' }
JuCairoPathBuilder class >> on: anAeCairoContext [
	^ self new
		initializeCairoContext: anAeCairoContext;
		yourself
]

{ #category : 'initialization' }
JuCairoPathBuilder >> initializeCairoContext: anAeCairoContext [
	cairoContext := anAeCairoContext
]

{ #category : 'visiting' }
JuCairoPathBuilder >> visitPath: aPath [
	"addCentredArc lands here with the rotary, and the minus pi/2 with it: the one place angles change convention."
	aPath elements do: [ :each | each acceptVisitor: self ]
]

{ #category : 'visiting' }
JuCairoPathBuilder >> visitPathLineTo: anElement [
	cairoContext lineTo: anElement point
]

{ #category : 'visiting' }
JuCairoPathBuilder >> visitPathStartNewSubPath: anElement [
	cairoContext moveTo: anElement point
]
