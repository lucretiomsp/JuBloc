Class {
	#name : 'JuPathStrokeType',
	#superclass : 'Object',
	#instVars : [
		'strokeThickness',
		'jointStyle',
		'endStyle'
	],
	#category : 'JuBloc-Graphics',
	#package : 'JuBloc',
	#tag : 'Graphics'
}

{ #category : 'style' }
JuPathStrokeType class >> endStyles [
	"PathStrokeType::EndCapStyle."
	^ #( #butt #square #rounded )
]

{ #category : 'style' }
JuPathStrokeType class >> jointStyles [
	"PathStrokeType::JointStyle."
	^ #( #mitered #curved #beveled )
]

{ #category : 'instance creation' }
JuPathStrokeType class >> strokeThickness: aThickness [
	"JUCE: PathStrokeType (thickness): mitered joints, butt ends."
	^ self strokeThickness: aThickness jointStyle: #mitered endStyle: #butt
]

{ #category : 'instance creation' }
JuPathStrokeType class >> strokeThickness: aThickness jointStyle: aJointStyle endStyle: anEndStyle [
	"Styles are spelled as in C++, so a Bloc spelling (#round) fails here, not in the renderer."
	self validate: aJointStyle among: self jointStyles.
	self validate: anEndStyle among: self endStyles.
	^ self new
		initializeStrokeThickness: aThickness jointStyle: aJointStyle endStyle: anEndStyle;
		yourself
]

{ #category : 'private' }
JuPathStrokeType class >> validate: aStyle among: someStyles [
	(someStyles includes: aStyle) ifFalse: [
		self error: ('{1} is not a JUCE PathStrokeType style' format: { aStyle printString }) ]
]

{ #category : 'initialization' }
JuPathStrokeType >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	^ self class = anObject class and: [
		strokeThickness = anObject strokeThickness and: [
		jointStyle = anObject jointStyle and: [
		endStyle = anObject endStyle ] ] ]

]

{ #category : 'initialization' }
JuPathStrokeType >> endStyle [ 
^ endStyle 
]

{ #category : 'comparing' }
JuPathStrokeType >> hash [
	^ (strokeThickness hash bitXor: jointStyle hash) bitXor: endStyle hash
]

{ #category : 'initialization' }
JuPathStrokeType >> initializeStrokeThickness: aThickness jointStyle: aJointStyle endStyle: anEndStyle [
	strokeThickness := aThickness.
	jointStyle := aJointStyle.
	endStyle := anEndStyle
]

{ #category : 'initialization' }
JuPathStrokeType >> joinStyle [ 
^ jointStyle 
]

{ #category : 'initialization' }
JuPathStrokeType >> strokeThickness [ 
^ strokeThickness 
]
