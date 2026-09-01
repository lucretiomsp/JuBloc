Class {
	#name : 'ComponentTest',
	#superclass : 'TestCase',
	#category : 'JuBloc-Tests',
	#package : 'JuBloc',
	#tag : 'Tests'
}

{ #category : 'tests' }
ComponentTest >> testName [ 

self assert: (JiComponent new: 'TestComponent') name equals: 'TestComponent' 
]
