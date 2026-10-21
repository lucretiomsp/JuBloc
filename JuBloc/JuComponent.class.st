Class {
	#name : 'JuComponent',
	#superclass : 'BlElement',
	#instVars : [
		'colours',
		'lookAndFeel'
	],
	#category : 'JuBloc-Component',
	#package : 'JuBloc',
	#tag : 'Component'
}

{ #category : 'painting' }
JuComponent >> aeDrawOn: anAeCanvas [
	"Subclasses override paint, never this."
	super aeDrawOn: anAeCanvas.
	self paint acceptVisitor: (JuBlocRenderer on: anAeCanvas)
]

{ #category : 'initialization' }
JuComponent >> findColour: aColourId [
	"JUCE's default, inheritFromParent = false: my own colour, else my look and feel's."
	^ colours
		at: aColourId
		ifAbsent: [ self lookAndFeel findColour: aColourId ]

]

{ #category : 'initialization' }
JuComponent >> initialize [
	super initialize.
	colours := Dictionary new.
	self initializeMouseCallbacks

]

{ #category : 'initialization' }
JuComponent >> initializeMouseCallbacks [
	"Consuming keeps events off the parent, as in JUCE, and a consumed drag start
	 is what makes Bloc keep sending the drag here."
	self
		addEventHandlerOn: BlMouseDownEvent do: [ :anEvent |
			anEvent consume.
			self mouseDown: anEvent ];
		addEventHandlerOn: BlDragStartEvent do: [ :anEvent | anEvent consume ];
		addEventHandlerOn: BlDragEvent do: [ :anEvent |
			anEvent consume.
			self mouseDrag: anEvent ]
]

{ #category : 'lookAndFeel' }
JuComponent >> juLookAndFeel [
	^ lookAndFeel ifNil: [ super juLookAndFeel ]
]

{ #category : 'geometry' }
JuComponent >> localBounds [
	"JUCE: getLocalBounds. The single conversion from Bloc."
	^ JuRectangle fromElement: self
]

{ #category : 'lookAndFeel' }
JuComponent >> lookAndFeel [
	"JUCE: getLookAndFeel."
	^ self juLookAndFeel
]

{ #category : 'lookAndFeel' }
JuComponent >> lookAndFeel: aLookAndFeel [
	"JUCE: setLookAndFeel. nil inherits again."
	lookAndFeel := aLookAndFeel.
	self invalidate

]

{ #category : 'event handling' }
JuComponent >> mouseDown: aBlMouseEvent [
	"JUCE: Component::mouseDown, empty."

]

{ #category : 'event handling' }
JuComponent >> mouseDrag: aBlMouseEvent [
	"JUCE: Component::mouseDrag, empty."
]

{ #category : 'painting' }
JuComponent >> paint [
	"JUCE: Component::paint, empty by default. Answers a JuDrawing, like every drawing method."
	^ JuDrawing withAll: #()
]

{ #category : 'initialization' }
JuComponent >> setColour: aColourId to: aColour [
	"JUCE's name, kept: the export prints it back."
	colours at: aColourId put: aColour.
	self invalidate
]
