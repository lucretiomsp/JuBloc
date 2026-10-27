"
I am the rotary family of JUCE's Slider::SliderStyle, the knob. So far I am Slider::RotaryHorizontalVerticalDrag, JUCE's usual knob style.

Responsibility.
I decide for a knob what Slider::Pimpl decides inside juce::Slider:
- paint: asks the look and feel for drawRotarySlider. The position I pass is a proportion of the range (0 to 1), not a pixel, and the angles come from the slider's JuRotaryParameters.
- dragStartingAt:for: answers a JuRotaryHorizontalVerticalDrag: a relative drag where right and up both increase the value, over the slider's mouseDragSensitivity pixels for the whole range.
- isRotary answers true, so the slider layout gives me all of the slider's bounds, as LookAndFeel_V2::getSliderLayout does.
I have no orientation: a knob turns, it does not run along an axis.

Collaborators.
JuSlider holds me and delegates paint and the mouse to me. JuLookAndFeel draws me with drawRotarySliderIn:sliderPos:rotaryStartAngle:rotaryEndAngle:slider:. JuRotaryParameters holds the start and end angles. JuRotaryHorizontalVerticalDrag is the drag I create, one per gesture.

Public API and Key Messages.
- JuSliderStyle rotaryHorizontalVerticalDrag  creates me
- paint: aSlider  answers a JuDrawing
- dragStartingAt: aPoint for: aSlider  answers a new JuSliderDrag for one gesture
- defaultExtent  80 @ 80, the preview's starting size (a juce::Slider starts at 0 x 0)
- isRotary

Example.
```language=Pharo
JuSlider rotaryHorizontalVerticalDrag openInSpace
```

Implementation Points.
- I hold no state. JUCE's three other rotary styles (Rotary, RotaryHorizontalDrag, RotaryVerticalDrag) differ from me only in the drag, so they will become a drag-mode slot on me, not subclasses: drawing and layout are the same for all four.
- Only my JUCE name reaches C++: the export will write setSliderStyle (juce::Slider::RotaryHorizontalVerticalDrag), and the plugin's own juce::Slider does the dragging.
- Not ported: stopAtEnd false (a knob that wraps around) and velocity drag.
"
Class {
	#name : 'JuRotarySliderStyle',
	#superclass : 'JuSliderStyle',
	#category : 'JuBloc-Model',
	#package : 'JuBloc',
	#tag : 'Model'
}

{ #category : 'testing' }
JuRotarySliderStyle >> defaultExtent [ 
^ 80 @ 80
]

{ #category : 'accessing' }
JuRotarySliderStyle >> dragStartingAt: aPoint for: aSlider [
	"A relative drag needs where it started and from which value."
	^ JuRotaryHorizontalVerticalDrag startingAt: aPoint value: aSlider value
]

{ #category : 'testing' }
JuRotarySliderStyle >> isRotary [ 
^ true 
]

{ #category : 'accessing' }
JuRotarySliderStyle >> paint: aSlider [
	"JUCE: Pimpl::paint, rotary branch: the position is a proportion, not a pixel."
	^ aSlider lookAndFeel
		drawRotarySliderIn: aSlider sliderBounds
		sliderPos: (aSlider valueToProportionOfLength: aSlider value)
		rotaryStartAngle: aSlider rotaryParameters startAngleRadians
		rotaryEndAngle: aSlider rotaryParameters endAngleRadians
		slider: aSlider
]
