Class {
	#name : 'JuSlider',
	#superclass : 'BlElement',
	#instVars : [
		'defaultStyle',
		'textEntryBoxPosition'
	],
	#category : 'JuBloc-widgets',
	#package : 'JuBloc',
	#tag : 'widgets'
}

{ #category : 'accessing - styles' }
JuSlider >> defaultStyle [
	^ defaultStyle
]

{ #category : 'accessing - styles' }
JuSlider >> defaultStyle: aSliderStyle [

"#LinearHorizontal , #LinearVertical , #LinearBar , #LinearBarVertical , #Rotary , #RotaryHorizontalDrag , RotaryVerticalDrag , #RotaryHorizontalVerticalDrag , #IncDecButtons , #TwoValueHorizontal , #TwoValueVertical , #ThreeValueHorizontal , #ThreeValueVertical"

defaultStyle := aSliderStyle 
]

{ #category : 'initialization' }
JuSlider >> initialize [ 
super initialize .
defaultStyle := #LinearHorizontal.
textEntryBoxPosition := #none 
]

{ #category : 'accessing - styles' }
JuSlider >> textEntryBoxPosition [ 
	^ textEntryBoxPosition 
]

{ #category : 'accessing - styles' }
JuSlider >> textEntryBoxPosition: aPosition [ 
	
" #none , #left , #right , #above"
	 textEntryBoxPosition := aPosition 
]
