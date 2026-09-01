Class {
	#name : 'JuSlider',
	#superclass : 'BlElement',
	#instVars : [
		'defaultStyle'
	],
	#category : 'JiBloc-widgets',
	#package : 'JiBloc',
	#tag : 'widgets'
}

{ #category : 'accessing - styles' }
JuSlider >> defaultStyle [
	^ defaultStyle
]

{ #category : 'initialization' }
JuSlider >> initialize [ 
super initialize .
defaultStyle := #LinearHorizontal 
]
