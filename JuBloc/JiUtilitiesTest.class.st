Class {
	#name : 'JiUtilitiesTest',
	#superclass : 'TestCase',
	#category : 'JuBloc-Tests',
	#package : 'JuBloc',
	#tag : 'Tests'
}

{ #category : 'tests' }
JiUtilitiesTest >> testJiRangeBetweenAnd [  

| r |
r := JiRange between: 2 and: 9.
self assert: r startValue equals: 2 .
self assert: r endValue equals: 9 .
]
