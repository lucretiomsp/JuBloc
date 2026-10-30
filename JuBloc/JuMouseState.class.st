Class {
	#name : 'JuMouseState',
	#superclass : 'Object',
	#category : 'JuBloc-Component',
	#package : 'JuBloc',
	#tag : 'Component'
}

{ #category : 'accessing' }
JuMouseState >> enterAt: aPoint on: aComponent [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
JuMouseState >> exitAt: aPoint on: aComponent [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
JuMouseState >> isMouseButtonDown [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
JuMouseState >> moveAt: aPoint on: aComponent [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
JuMouseState >> pressAt: aPoint on: aComponent [
	"Each message answers the next state."
	^ self subclassResponsibility
]

{ #category : 'accessing' }
JuMouseState >> releaseAt: aPoint on: aComponent [
	^ self subclassResponsibility
]
