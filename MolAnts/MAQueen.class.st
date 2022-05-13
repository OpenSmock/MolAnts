Class {
	#name : #MAQueen,
	#superclass : #MARole,
	#category : #'MolAnts-Model'
}

{ #category : #'life cycle' }
MAQueen >> componentInitialize [
	"here write the code corresponding to component initialisation phase"
	
	roleName := #queen
]

{ #category : #role }
MAQueen >> moveFrom: aPosition [

	roleName = #queen ifTrue: [ 
		^ aPosition + (((Random new next * 10 - 5) rounded) @ 0)
	].
]
