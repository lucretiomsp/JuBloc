Class {
	#name : 'JuMouseEvent',
	#superclass : 'Object',
	#instVars : [
		'position'
	],
	#category : 'JuBloc-Component',
	#package : 'JuBloc',
	#tag : 'Component'
}

{ #category : 'accessing' }
JuMouseEvent class >> position: aPoint [
	^ self new
		initializePosition: aPoint;
		yourself
]

{ #category : 'initialization' }
JuMouseEvent >> initializePosition: aPoint [
	position := aPoint
]

{ #category : 'accessing' }
JuMouseEvent >> position [
	"JUCE: MouseEvent::position, local to the component receiving the callback,
	 whichever Bloc event produced me."
	^ position
]
