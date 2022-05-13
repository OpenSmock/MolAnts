Class {
	#name : #MAFighter,
	#superclass : #MARole,
	#category : #'MolAnts-Model'
}

{ #category : #role }
MAFighter >> componentInitialize [
	"here write the code corresponding to component initialisation phase"
	
	roleName := #fighter
]

{ #category : #role }
MAFighter >> moveFrom: aPosition [

	roleName = #fighter ifTrue: [ 
		^ aPosition + (0 @ ((Random new next * 10 - 5) rounded))
	].

]
