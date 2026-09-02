"
I am a Visitor that realizes a JuDrawing on screen by adding a child BlElement per operation. Children are my private business: the drawing logic stays in one look-and-feel method, so this is not the exploded child tree that ICKnob had. I am the throwaway backend. A visitor painting straight onto the Alexandrie canvas replaces me without anything above me moving, and I only handle axis-aligned strokes, which covers linear sliders but not rotary.
"
Class {
	#name : 'JuBlocRenderer',
	#superclass : 'Object',
	#instVars : [
		'element'
	],
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'instance creation' }
JuBlocRenderer class >> on: aBlElement [
	^ self new initializeElement: aBlElement; yourself
]

{ #category : 'initialization' }
JuBlocRenderer >> initializeElement: aBlElement [
	element := aBlElement
]

{ #category : 'visiting' }
JuBlocRenderer >> visitDrawing: aDrawing [
	aDrawing operations do: [ :each | each acceptVisitor: self ]

]

{ #category : 'visiting' }
JuBlocRenderer >> visitFillEllipse: anOperation [
	element addChild: (BlElement new
		geometry: BlEllipseGeometry new;
		background: anOperation colour;
		position: anOperation bounds origin;
		size: anOperation bounds extent;
		yourself)
]

{ #category : 'visiting' }
JuBlocRenderer >> visitStrokeLine: anOperation [
	| half origin extent |
	half := anOperation width / 2.
	origin := (anOperation from x min: anOperation to x) - half
		@ ((anOperation from y min: anOperation to y) - half).
	extent := ((anOperation from x - anOperation to x) abs + anOperation width)
		@ ((anOperation from y - anOperation to y) abs + anOperation width).
	element addChild: (BlElement new
		geometry: (BlRoundedRectangleGeometry cornerRadius: half);
		background: anOperation colour;
		position: origin;
		size: extent;
		yourself)
]
