"
I am a Strategy object that draws widgets. I am the only place in **JuBloc** where a widget''s appearance is decided.

##Responsibility.
I answer drawing methods, one per widget shape, that record commands into a JUGraphics rather than painting directly. I hold no widget state: everything I need is passed to me as arguments, so the same instance can draw any number of components. I resolve colours by symbolic id through my JUColourScheme, never from literals in a drawing body.

##Collaborators.
JUComponent asks me to draw itself during paint, and finds me by walking up its parent chain to the default instance if it has no explicit look and feel of its own. JUGraphics receives my commands and replays them either into a Bloc canvas or into emitted JUCE C++. JUColourScheme answers a Color for a colour id.

Two axes, not one. I am the *what is drawn* axis: my subclasses differ in shape, so JUSimpleKnobLookAndFeel is a real subclass because it draws no disk and no outer ring. Palette differences are the *how it looks* axis and belong in JUColourScheme, not in a subclass of me. If you are about to subclass me and override only colours, make a colour scheme instead.

###Public API and Key Messages.
- drawRotarySliderOn:bounds:sliderPos:startAngle:endAngle:slider:
- drawLinearSliderOn:bounds:sliderPos:minSliderPos:maxSliderPos:style:slider:
- drawButtonBackgroundOn:bounds:button:isHighlighted:isDown:
- findColour: anId  answers my override for anId, falling back to my colour scheme
- setColour:to:
- JULookAndFeel default  answers the shared instance used by components with none set
- JULookAndFeel default: aLookAndFeel

Every drawing selector matches its JUCE counterpart after a mechanical rename, which is what makes emission a rename rather than a translation.
```language=Pharo
Example.
	| laf graphics |
	laf := JULookAndFeel new colourScheme: JUColourScheme darkAudio.
	graphics := JUGraphics new.
	laf
		drawRotarySliderOn: graphics
		bounds: (0 @ 0 extent: 80 @ 80)
		sliderPos: 0.5
		startAngle: Float pi * 1.2
		endAngle: Float pi * 2.8
		slider: aSlider.
	graphics acceptVisitor: JUCppEmitter new
```
Internal Representation and Key Implementation Points.
	Instance Variables
	colourScheme:	<JUColourScheme>	the palette I resolve colour ids against
	colours:		<Dictionary>		explicit per-id overrides, consulted before the scheme

	Class-side Instance Variables (declared in slots: on my metaclass)
	default:		<JULookAndFeel>		the fallback instance, lazily initialized

####Implementation Points
	- My drawing methods must be pure functions of their arguments. Do not read component state directly and do not cache. JUCE recomputes everything from sliderPos on each paint, and a cache here diverges silently between preview and export.
	- Do not touch child elements. Anything I draw is one flat command sequence.
	- Non-drawing hooks (layout queries, factory methods returning objects) bypass JUGraphics and have no emission path. They are forbidden in v1.'
"
Class {
	#name : 'JuLookAndFeel',
	#superclass : 'Object',
	#instVars : [
		'colours',
		'defaultFont'
	],
	#category : 'JuBloc-LookAndFeel',
	#package : 'JuBloc',
	#tag : 'LookAndFeel'
}

{ #category : 'drawing' }
JuLookAndFeel >> drawLinearSliderIn: aRectangle sliderPos: sliderPos minSliderPos: minSliderPos maxSliderPos: maxSliderPos slider: aSlider [

^ self subclassResponsibility 
]
