Class {
	#name : 'JuButton',
	#superclass : 'JuComponent',
	#instVars : [
		'buttonText',
		'buttonState',
		'toggleState',
		'clickingTogglesState',
		'onClick',
		'onStateChange'
	],
	#category : 'JuBloc-Button',
	#package : 'JuBloc',
	#tag : 'Button'
}

{ #category : 'testing' }
JuButton class >> isAbstract [
	^ self == JuButton
]

{ #category : 'accessing' }
JuButton >> buttonState [
	"JUCE: getState: #buttonNormal, #buttonOver or #buttonDown."
	^ buttonState
]

{ #category : 'accessing' }
JuButton >> buttonText [
	"JUCE: getButtonText."
	^ buttonText
]

{ #category : 'accessing' }
JuButton >> buttonText: aString [
	"JUCE: setButtonText."
	buttonText := aString.
	self invalidate
]

{ #category : 'accessing' }
JuButton >> clickingTogglesState [
	"JUCE: getClickingTogglesState."
	^ clickingTogglesState
]

{ #category : 'accessing' }
JuButton >> clickingTogglesState: aBoolean [
	"JUCE: setClickingTogglesState."
	clickingTogglesState := aBoolean
]

{ #category : 'initialization' }
JuButton >> initialize [
	"JUCE: Button (name): normal, off, and a click does not toggle."
	super initialize.
	buttonText := ''.
	buttonState := #buttonNormal.
	toggleState := false.
	clickingTogglesState := false.
	onClick := [ ].
	onStateChange := [ ]
]

{ #category : 'accessing' }
JuButton >> internalClickCallback [
	"JUCE: Button::internalClickCallback. Without radio groups, a toggling click always flips."
	clickingTogglesState ifTrue: [ ^ self toggleState: toggleState not ].
	self sendClickMessage
]

{ #category : 'accessing' }
JuButton >> isDown [
	"JUCE: Button::isDown."
	^ buttonState = #buttonDown
]

{ #category : 'event handling' }
JuButton >> isMouseSourceOver: aMouseEvent [
	"JUCE asks isMouseOver; Bloc answers it from the position."
	^ self containsPoint: aMouseEvent position
]

{ #category : 'accessing' }
JuButton >> isOver [
	"JUCE: Button::isOver, also true while down."
	^ buttonState ~= #buttonNormal
]

{ #category : 'event handling' }
JuButton >> mouseDown: aMouseEvent [
	"JUCE: Button::mouseDown. Auto-repeat and triggerOnMouseDown are not ported."
	self updateStateOver: true down: true

]

{ #category : 'event handling' }
JuButton >> mouseDrag: aMouseEvent [
	"JUCE: Button::mouseDrag."
	self updateStateOver: (self isMouseSourceOver: aMouseEvent) down: true
]

{ #category : 'event handling' }
JuButton >> mouseEnter: aMouseEvent [
	"JUCE: Button::mouseEnter."
	self updateStateOver: true down: false
]

{ #category : 'event handling' }
JuButton >> mouseExit: aMouseEvent [
	"JUCE: Button::mouseExit."
	self updateStateOver: false down: false
]

{ #category : 'event handling' }
JuButton >> mouseUp: aMouseEvent [
	"JUCE: Button::mouseUp: a click needs the press and the release both over me."
	| wasDown wasOver |
	wasDown := self isDown.
	wasOver := self isOver.
	self updateStateOver: (self isMouseSourceOver: aMouseEvent) down: false.
	(wasDown and: [ wasOver ]) ifFalse: [ ^ self ].
	self internalClickCallback.
	self updateStateOver: (self isMouseSourceOver: aMouseEvent) down: false
]

{ #category : 'accessing' }
JuButton >> onClick: aBlock [
	"JUCE: onClick. aBlock takes no argument, or the button."
	onClick := aBlock
]

{ #category : 'accessing' }
JuButton >> onStateChange: aBlock [
	"JUCE: onStateChange. aBlock takes no argument, or the button."
	onStateChange := aBlock
]

{ #category : 'painting' }
JuButton >> paint [
	"JUCE: Button::paint, a Template Method over paintButton."
	^ self paintButtonHighlighted: self isOver down: self isDown
]

{ #category : 'painting' }
JuButton >> paintButtonHighlighted: shouldDrawButtonAsHighlighted down: shouldDrawButtonAsDown [
	"JUCE: paintButton, pure virtual. Answers a JuDrawing."
	^ self subclassResponsibility
]

{ #category : 'accessing' }
JuButton >> sendClickMessage [
	"JUCE: sendClickMessage. Listeners and the command manager are not ported."
	onClick cull: self

]

{ #category : 'accessing' }
JuButton >> sendStateMessage [
	"JUCE: sendStateMessage."
	onStateChange cull: self
]

{ #category : 'initialization' }
JuButton >> setState: aButtonState [
	"JUCE: Button::setState."
	buttonState = aButtonState ifTrue: [ ^ self ].
	buttonState := aButtonState.
	self invalidate.
	self sendStateMessage
]

{ #category : 'accessing' }
JuButton >> stateForOver: over down: down [
	(down and: [ over ]) ifTrue: [ ^ #buttonDown ].
	over ifTrue: [ ^ #buttonOver ].
	^ #buttonNormal
]

{ #category : 'accessing' }
JuButton >> toggleState [
	"JUCE: getToggleState."
	^ toggleState
]

{ #category : 'accessing' }
JuButton >> toggleState: aBoolean [
	"JUCE: setToggleState (shouldBeOn, sendNotification), synchronous as JuSlider >> value:
	 is. Radio groups are not ported."
	aBoolean = toggleState ifTrue: [ ^ self ].
	toggleState := aBoolean.
	self invalidate.
	self sendClickMessage.
	self sendStateMessage
]

{ #category : 'accessing' }
JuButton >> triggerClick [
	"JUCE: triggerClick. Synchronous (JUCE posts a message), without the 100 ms flash."
	self internalClickCallback

]

{ #category : 'accessing' }
JuButton >> updateStateOver: over down: down [
	"JUCE: Button::updateState (over, down). Not ported: enablement, visibility,
	 modal blocking, key presses, triggerOnMouseDown."
	self setState: (self stateForOver: over down: down)
]
