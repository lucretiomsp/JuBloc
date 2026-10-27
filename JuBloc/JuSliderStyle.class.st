"
I am the information in JUCE's Slider::SliderStyle enum, as objects. The enum flattens four independent axes into 13 values: the family (linear, rotary, inc/dec buttons), the linear variant (plain, bar, two-value, three-value), the orientation (linear only) and the drag mode (rotary only).

Responsibility.
I decide what Slider::Pimpl decides inside juce::Slider: which drawing to ask the look and feel for (paint:), how the mouse drags (dragStartingAt:for:), and the predicates JUCE tests (isBar, isRotary). Pimpl is never emitted, so polymorphism here instead of enum tests costs no mappability.

My subclasses split by family, then by variant: JuLinearSliderStyle (the plain linear slider) with its subclass JuLinearBarSliderStyle, and JuRotarySliderStyle. Each variant exists only inside its family, so the hierarchy stays a tree, never a cross product. Orientation multiplies with the variant (every linear variant comes horizontal and vertical), so it is composed instead: the linear family holds a JuSliderOrientation. The rotary drag mode changes only the drag, so it will be a slot on the rotary family too.

JuSlider stays one class, as juce::Slider is: the style varies, not the slider.

The look and feel still tests isBar and isRotary inside its drawing and layout methods, as LookAndFeel_V4 and V2 do. Those are the methods a custom look and feel overrides and the emitter prints, so they keep JUCE's shape.

Collaborators.
JuSlider holds one of my instances and delegates paint and the mouse to it. JuLookAndFeel draws what I ask for. The JuSliderDrag subclasses are the drags I create.

Public API and Key Messages.
- JuSliderStyle linearHorizontal, linearVertical, linearBar, linearBarVertical, rotaryHorizontalVerticalDrag  one per JUCE enum value ported so far
- paint: aSlider  answers a JuDrawing
- dragStartingAt: aPoint for: aSlider  answers a JuSliderDrag for one gesture
- defaultExtent  the preview's starting size
- isBar, isRotary

Implementation Points.
- Not ported: the TwoValue and ThreeValue styles; the Rotary, RotaryHorizontalDrag and RotaryVerticalDrag drag modes; IncDecButtons. IncDecButtons is a different widget filed under the enum (two buttons, no track, no thumb): if ever needed it becomes a sibling of JuSlider, not a style.
"
Class {
	#name : 'JuSliderStyle',
	#superclass : 'Object',
	#category : 'JuBloc-Model',
	#package : 'JuBloc',
	#tag : 'Model'
}

{ #category : 'instance creation' }
JuSliderStyle class >> linearBar [
	"JUCE: Slider::LinearBar."
	^ JuLinearBarSliderStyle orientation: JuHorizontalOrientation new
]

{ #category : 'instance creation' }
JuSliderStyle class >> linearBarVertical [
	"JUCE: Slider::LinearBarVertical."
	^ JuLinearBarSliderStyle orientation: JuVerticalOrientation new
]

{ #category : 'instance creation' }
JuSliderStyle class >> linearHorizontal [
	"JUCE: Slider::LinearHorizontal."
	^ JuLinearSliderStyle orientation: JuHorizontalOrientation new
]

{ #category : 'instance creation' }
JuSliderStyle class >> linearVertical [
	"JUCE: Slider::LinearVertical."
	^ JuLinearSliderStyle orientation: JuVerticalOrientation new
]

{ #category : 'instance creation' }
JuSliderStyle class >> rotaryHorizontalVerticalDrag [
	"JUCE: Slider::RotaryHorizontalVerticalDrag, the usual knob."
	^ JuRotarySliderStyle new
]

{ #category : 'accessing' }
JuSliderStyle >> defaultExtent [
	"The preview's starting size. A juce::Slider starts at 0 x 0 and its parent sizes it."
	^ self subclassResponsibility
]

{ #category : 'accessing' }
JuSliderStyle >> dragStartingAt: aPoint for: aSlider [
	"Answer the JuSliderDrag for a gesture starting at aPoint."
	^ self subclassResponsibility
]

{ #category : 'testing' }
JuSliderStyle >> isBar [
	"JUCE: Slider::isBar."
	^ false
]

{ #category : 'testing' }
JuSliderStyle >> isRotary [
	"JUCE: Slider::isRotary."
	^ false
]

{ #category : 'accessing' }
JuSliderStyle >> paint: aSlider [
	"JUCE: Slider::Pimpl::paint, which asks the look and feel for a linear or a rotary drawing."
	^ self subclassResponsibility
]
