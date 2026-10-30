Class {
	#name : 'JuMouseCaptured',
	#superclass : 'JuMouseState',
	#category : 'JuBloc-Component',
	#package : 'JuBloc',
	#tag : 'Component'
}

{ #category : 'testing' }
JuMouseCaptured class >> isAbstract [
	^ self == JuMouseState
]

{ #category : 'accessing' }
JuMouseCaptured >> enterAt: aPoint on: aComponent [
	"JUCE sends no enter or exit while pressed. Below Bloc's drag threshold, crossing
	 my edge is the only news that the mouse moved: it is the drag JUCE would send."
	^ self moveAt: aPoint on: aComponent
]

{ #category : 'accessing' }
JuMouseCaptured >> exitAt: aPoint on: aComponent [
	^ self moveAt: aPoint on: aComponent
]

{ #category : 'accessing' }
JuMouseCaptured >> isMouseButtonDown [
	^ true
]

{ #category : 'accessing' }
JuMouseCaptured >> moveAt: aPoint on: aComponent [
	"JUCE: any move with a button down is a drag, from the first pixel."
	aComponent mouseDrag: (JuMouseEvent position: aPoint).
	^ self
]

{ #category : 'accessing' }
JuMouseCaptured >> pressAt: aPoint on: aComponent [
	"Another button while one is held: JUCE sends no second mouseDown."
	^ self
]

{ #category : 'accessing' }
JuMouseCaptured >> releaseAt: aPoint on: aComponent [
	"JUCE: mouseUp reaches the pressed component wherever the mouse is, then the
	 mouseExit held back during the press, if the release is outside."
	| event |
	event := JuMouseEvent position: aPoint.
	aComponent mouseUp: event.
	(aComponent containsPoint: aPoint) ifFalse: [ aComponent mouseExit: event ].
	^ JuMouseUncaptured new
]
