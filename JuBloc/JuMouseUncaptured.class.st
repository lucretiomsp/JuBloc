Class {
	#name : 'JuMouseUncaptured',
	#superclass : 'JuMouseState',
	#category : 'JuBloc-Component',
	#package : 'JuBloc',
	#tag : 'Component'
}

{ #category : 'accessing' }
JuMouseUncaptured >> enterAt: aPoint on: aComponent [
	aComponent mouseEnter: (JuMouseEvent position: aPoint).
	^ self
]

{ #category : 'accessing' }
JuMouseUncaptured >> exitAt: aPoint on: aComponent [
	aComponent mouseExit: (JuMouseEvent position: aPoint).
	^ self
]

{ #category : 'accessing' }
JuMouseUncaptured >> isMouseButtonDown [
	^ false
]

{ #category : 'accessing' }
JuMouseUncaptured >> moveAt: aPoint on: aComponent [
	aComponent mouseMove: (JuMouseEvent position: aPoint).
	^ self
]

{ #category : 'accessing' }
JuMouseUncaptured >> pressAt: aPoint on: aComponent [
	aComponent mouseDown: (JuMouseEvent position: aPoint).
	^ JuMouseCaptured new
]

{ #category : 'accessing' }
JuMouseUncaptured >> releaseAt: aPoint on: aComponent [
	"Bloc releases over whatever is under the mouse, even after a press elsewhere.
	 JUCE sends mouseUp only to the pressed component."
	^ self
]
