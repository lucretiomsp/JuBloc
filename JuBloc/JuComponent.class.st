"
I am **juce::Component:** the base of every _JuBloc_ widget and container. I am a _BlElement_, so Bloc lays me out, draws me and sends me events, but I speak JUCE''s protocol, so a tree of me maps one to one onto a **juce::Component** tree.

Responsibility.
I decide nothing about appearance. I hold my own colour overrides and, optionally, my look and feel, and I turn four Bloc mechanisms into their JUCE counterparts:
- Painting (Template Method). Bloc calls aeDrawGeometryOn: with my position and transformation applied and before my children, which is where JUCE calls paint. I draw my Bloc background and border (super), then paint. Subclasses override paint and answer a JuDrawing; they never override the Bloc hook. Do not use aeDrawOn: either: BlElement draws my children inside it, so anything drawn after super lands in my parent''s coordinates, on top of my children.
- Colours (Chain of Responsibility). findColour: answers my own colour, else my look and feel''s. That is JUCE''s default, inheritFromParent = false.
- Look and feel (Chain of Responsibility). lookAndFeel answers mine, else the first one set on a parent, else JuLookAndFeel default. The walk passes through plain BlElements (BlElement >> juLookAndFeel).
- Mouse (Adapter). BlMouseDownEvent and BlDragEvent become mouseDown: and mouseDrag:, empty here as in JUCE. I consume the events so they never reach my parent, and consuming BlDragStartEvent is what makes Bloc keep sending me the drag.

Collaborators.
_JuLookAndFeel_ answers my colours and my subclasses'' drawings. JuBlocRenderer realizes paint on the Alexandrie canvas; the C++ emitter will consume the same JuDrawing. JuRectangle is the geometry I hand out, and localBounds is the single conversion from Bloc.

Public API and Key Messages.
- paint  answers a _JuDrawing_, empty here as Component::paint is
- findColour: aColourId, setColour: aColourId to: aColour  JUCE''s names, kept because the export prints them back
- lookAndFeel, lookAndFeel: aLookAndFeel  getLookAndFeel and setLookAndFeel; nil inherits again
- localBounds  getLocalBounds, as a JuRectangle
- mouseDown: aBlMouseEvent, mouseDrag: aBlMouseEvent  the JUCE callbacks widgets override

Example.
```language=Pharo
	| editor slider |
	editor := JuComponent new
		lookAndFeel: (JuLookAndFeelV4 colourScheme: JuColourScheme light);
		yourself.
	slider := JuSlider linearHorizontal.
	editor addChild: slider.
	slider findColour: #sliderThumb    ""the light scheme''s thumb, found through editor""
```
Internal Representation and Key Implementation Points.
	Instance Variables
	colours:	<Dictionary>	my own overrides, colour id to Color, consulted before my look and feel
	lookAndFeel:	<JuLookAndFeel | nil>	my explicit look and feel; nil means inherit

	Implementation Points
	- paint is a pure function of my state: no cache, no child elements. JUCE recomputes on every repaint, and a cache diverges silently between preview and export.
	- Not ported yet: the inheritFromParent colour walk, isColourSpecified:, colourChanged, lookAndFeelChanged, paintOverChildren, resized, and the other mouse callbacks (up, move, wheel, double click).
	- No JUCE equivalent, so the export must check: Bloc does not clip a childless element''s own drawing to its bounds, while JUCE clips every paint to the component; and a plain BlElement between two of me must be rejected or exported as a bare juce::Component.'
"
Class {
	#name : 'JuComponent',
	#superclass : 'BlElement',
	#instVars : [
		'colours',
		'lookAndFeel',
		'mouseState'
	],
	#category : 'JuBloc-Component',
	#package : 'JuBloc',
	#tag : 'Component'
}

{ #category : 'as yet unclassified' }
JuComponent >> aeDrawGeometryOn: anAeCanvas [
	"Bloc's slot for JUCE's paint: position and transformation applied, children after.
	 Subclasses override paint, never this."
	super aeDrawGeometryOn: anAeCanvas.
	self paint acceptVisitor: (JuBlocRenderer on: anAeCanvas)
]

{ #category : 'colors' }
JuComponent >> findColour: aColourId [
	^ colours
		at: aColourId
		ifAbsent: [ self lookAndFeel findColour: aColourId ]
]

{ #category : 'event handling' }
JuComponent >> hasKeyboardFocus: trueIfChildIsFocused [
	"JUCE: hasKeyboardFocus. JUCE's grab on mouse click is not ported yet."
	^ trueIfChildIsFocused
		ifTrue: [ self hasFocus ]
		ifFalse: [ self isFocused ]
]

{ #category : 'initialization' }
JuComponent >> initialize [
	super initialize.
	colours := Dictionary new.
	self initializeMouseCallbacks

]

{ #category : 'initialization' }
JuComponent >> initializeHoverCallbacks [
	self
		addEventHandlerOn: BlMouseMoveEvent do: [ :anEvent |
			anEvent consume.
			self mouseMovedAt: anEvent localPosition ];
		addEventHandlerOn: BlMouseEnterEvent do: [ :anEvent |
			self mouseEnteredAt: anEvent localPosition ];
		addEventHandlerOn: BlMouseLeaveEvent do: [ :anEvent |
			self mouseExitedAt: anEvent localPosition ]
]

{ #category : 'initialization' }
JuComponent >> initializeMouseCallbacks [
	"Adapter. Consuming keeps events off the parent, as in JUCE, and a consumed drag start
	 makes Bloc keep sending the drag here. mouseState rebuilds JUCE's implicit capture."
	mouseState := JuMouseUncaptured new.
	self
		initializePressCallbacks;
		initializeReleaseCallbacks;
		initializeHoverCallbacks
]

{ #category : 'initialization' }
JuComponent >> initializePressCallbacks [
	self
		addEventHandlerOn: BlMouseDownEvent do: [ :anEvent |
			anEvent consume.
			self mousePressedAt: anEvent localPosition ];
		addEventHandlerOn: BlDragStartEvent do: [ :anEvent | anEvent consume ];
		addEventHandlerOn: BlDragEvent do: [ :anEvent |
			anEvent consume.
			self mouseMovedAt: anEvent localPosition ]
]

{ #category : 'initialization' }
JuComponent >> initializeReleaseCallbacks [
	"Bloc ends a press in one of three events: a mouse up over me, a drag end after a drag,
	 or a click aborted when released over something else. The aborted event's position is
	 the press; the release is its up event's, in space coordinates."
	self
		addEventHandlerOn: BlMouseUpEvent do: [ :anEvent |
			anEvent consume.
			self mouseReleasedAt: anEvent localPosition ];
		addEventHandlerOn: BlDragEndEvent do: [ :anEvent |
			anEvent consume.
			self mouseReleasedAt: anEvent localPosition ];
		addEventHandlerOn: BlClickAbortedEvent do: [ :anEvent |
			anEvent consume.
			self mouseReleasedAt: (self globalPointToLocal: anEvent upEvent position) ]
]

{ #category : 'event handling' }
JuComponent >> isEnabled [
	"JUCE: isEnabled. Bloc's core has no enablement, so I will own the flag as
	 juce::Component does. Not ported yet."
	^ true
]

{ #category : 'event handling' }
JuComponent >> isMouseButtonDown [
	"JUCE: isMouseButtonDown, for a press that started on me."
	^ mouseState isMouseButtonDown

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

{ #category : 'event handling' }
JuComponent >> mouseEnter: aMouseEvent [
	"JUCE: Component::mouseEnter, empty."
]

{ #category : 'event handling' }
JuComponent >> mouseEnteredAt: aPoint [
	mouseState := mouseState enterAt: aPoint on: self

]

{ #category : 'event handling' }
JuComponent >> mouseExit: aMouseEvent [
	"JUCE: Component::mouseExit, empty."

]

{ #category : 'event handling' }
JuComponent >> mouseExitedAt: aPoint [
	mouseState := mouseState exitAt: aPoint on: self

]

{ #category : 'event handling' }
JuComponent >> mouseMove: aMouseEvent [
	"JUCE: Component::mouseMove, empty."

]

{ #category : 'event handling' }
JuComponent >> mouseMovedAt: aPoint [
	mouseState := mouseState moveAt: aPoint on: self

]

{ #category : 'event handling' }
JuComponent >> mousePressedAt: aPoint [
	mouseState := mouseState pressAt: aPoint on: self

]

{ #category : 'event handling' }
JuComponent >> mouseReleasedAt: aPoint [
	mouseState := mouseState releaseAt: aPoint on: self

]

{ #category : 'event handling' }
JuComponent >> mouseUp: aMouseEvent [
	"JUCE: Component::mouseUp, empty."
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
