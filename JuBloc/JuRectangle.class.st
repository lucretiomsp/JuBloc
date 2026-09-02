"
JuRectangle comment: 'I am an immutable rectangle held as an origin Point and an extent Point. I am the geometry currency of JuBloc: every drawing method, orientation and layout query takes me, never a BlElement and never a bare pair of numbers.

Why I exist rather than Pharo''s Rectangle.
Pharo''s Rectangle stores origin and corner, so it computes width as corner x - origin x. I store origin and extent, so my width is a direct reference. That matters only in symbolic mode, and it matters completely: JUCE''s drawing methods take x, y, width and height as four separate parameters, and an emitter must print `width`, not `(x + width) - x`. Every other difference between us is in Pharo''s favour.

Why I work in both modes.
My components are Points, and Pharo''s Point does not type-check its coordinates. Fill me with numbers and I answer numbers, so a JuLookAndFeel draws a picture. Fill me with JuExpressions and I answer expression trees, so the same method emits C++ that recomputes at runtime. No drawing body can tell which it is holding, which is the load-bearing property of the whole library. Neither Rectangle nor BlBounds can do this, because neither can hold a JuParamRef.

Collaborators.
JuSliderOrientation, JuSliderGeometry and JuLookAndFeel all take me as their bounds argument. JuSlider builds me in drawingBounds and is the only class that ever converts from Bloc.

Public API and Key Messages.
- origin, extent  my two Points
- x, y, width, height  the four values JUCE passes separately
- left, top, right, bottom, corner, centre  derived, so they emit as arithmetic just as JUCE writes it
- reduced: aNumber, withTrimmedLeft: aNumber, withWidth: aNumber  named after their JUCE counterparts so they emit as bounds.reduced (10) rather than reconstructed arithmetic
- JuRectangle origin: aPoint extent: aPoint
- JuRectangle fromElement: aBlElement  the single conversion point from Bloc, and the only place rounding happens


	Implementation Points
	- I am immutable. Every transform answers a new instance. This is not style: my components may be expression trees shared by several drawing operations, and mutating one would corrupt the others.
	- Do not add a comparison or containment protocol that has to answer a Boolean. There is no symbolic Boolean, so containsPoint: and friends work in Bloc and break silently under emission. Anything unavoidably Bloc-only belongs in the bloc-only protocol so the boundary stays visible.
	- Never branch on one of my components in a drawing body for the same reason. Checked against LookAndFeel_V4: it branches on style and never on a coordinate, so this costs nothing.
	- Rounding to integers happens in fromElement: and nowhere else. Bloc bounds are floats; JUCE takes ints. Rounding in two places is how preview and export drift apart.'
"
Class {
	#name : 'JuRectangle',
	#superclass : 'Object',
	#instVars : [
		'origin',
		'extent'
	],
	#category : 'JuBloc-Model',
	#package : 'JuBloc',
	#tag : 'Model'
}

{ #category : 'instance creation' }
JuRectangle class >> fromElement: aBlElement [
	"The single conversion point from Bloc. Rounding happens here and nowhere else."
	| bounds |
	bounds := aBlElement boundsInLocal.
	^ self
		origin: bounds origin rounded
		extent: bounds extent rounded
]

{ #category : 'instance creation' }
JuRectangle class >> origin: aPoint extent: anotherPoint [
	^ self new
		initializeOrigin: aPoint extent: anotherPoint;
		yourself
]

{ #category : 'accessing' }
JuRectangle >> bottom [ 
 
^ origin y + extent y
]

{ #category : 'accessing' }
JuRectangle >> center [  
 
^ origin + (extent / 2)
]

{ #category : 'accessing' }
JuRectangle >> corner [ 
 
^ origin  + extent 
]

{ #category : 'accessing' }
JuRectangle >> extent [ 
^ extent
]

{ #category : 'accessing' }
JuRectangle >> height [ 
^ extent y
]

{ #category : 'initialization' }
JuRectangle >> initializeOrigin: aPoint extent: anotherPoint [
	origin := aPoint.
	extent := anotherPoint
]

{ #category : 'accessing' }
JuRectangle >> left [ 
^ origin x
]

{ #category : 'accessing' }
JuRectangle >> origin [ 

^ origin
]

{ #category : 'accessing' }
JuRectangle >> right [ 
^ origin x + extent x
]

{ #category : 'accessing' }
JuRectangle >> top [

	^ extent y
]

{ #category : 'accessing' }
JuRectangle >> width [ 
^ extent x 
]

{ #category : 'accessing' }
JuRectangle >> x [ 
^ origin x
]

{ #category : 'accessing' }
JuRectangle >> y [ 

^ origin y
]
