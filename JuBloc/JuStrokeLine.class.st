"
I am a line stroked with a round cap, which is geometrically a capsule. JUCE draws slider tracks as a two-point Path plus strokePath; I record the same thing without the Path.
"
Class {
	#name : 'JuStrokeLine',
	#superclass : 'JuDrawOperation',
	#instVars : [
		'from',
		'to',
		'width',
		'colour'
	],
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'instance creation' }
JuStrokeLine class >> from: aPoint to: anotherPoint width: aNumber colour: aColour [
	^ self new
		initializeFrom: aPoint to: anotherPoint width: aNumber colour: aColour;
		yourself
]

{ #category : 'visiting' }
JuStrokeLine >> acceptVisitor: aVisitor [
	^ aVisitor visitStrokeLine: self
]

{ #category : 'accessing' }
JuStrokeLine >> colour [ 
^ colour 
]

{ #category : 'accessing' }
JuStrokeLine >> from [ 
^ from
]

{ #category : 'initialization' }
JuStrokeLine >> initializeFrom: aPoint to: anotherPoint width: aNumber colour: aColour [
	from := aPoint. to := anotherPoint. width := aNumber. colour := aColour
]

{ #category : 'accessing' }
JuStrokeLine >> to [ 
^ to
]

{ #category : 'accessing' }
JuStrokeLine >> width [ 
^ width
]
