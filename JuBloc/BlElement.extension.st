Extension { #name : 'BlElement' }

{ #category : '*JuBloc' }
BlElement >> juLookAndFeel [
	"A plain element sets no look and feel, so it passes the question up."
	^ self parent
		ifNil: [ JuLookAndFeel default ]
		ifNotNil: [ :aParent | aParent juLookAndFeel ]
]
