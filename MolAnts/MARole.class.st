Class {
	#name : #MARole,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMARoleType + TMARoleServices',
	#classTraits : 'MolComponentImpl classTrait + TMARoleType classTrait + TMARoleServices classTrait',
	#category : #'MolAnts-Model'
}

{ #category : #'life cycle' }
MARole >> componentInitialize [
	"here write the code corresponding to component initialisation phase"
	
	roleName := { #worker . #fighter . #queen } atRandom.
]

{ #category : #role }
MARole >> moveFrom: aPosition [

	roleName = #worker ifTrue: [ 
		^ aPosition + (((Random new next * 10 - 5) rounded) @ ((Random new next * 10 - 5) rounded))
	].

	roleName = #fighter ifTrue: [ 
		^ aPosition + (0 @ ((Random new next * 10 - 5) rounded))
	].

	roleName = #queen ifTrue: [ 
		^ aPosition + (((Random new next * 10 - 5) rounded) @ 0)
	].
]
