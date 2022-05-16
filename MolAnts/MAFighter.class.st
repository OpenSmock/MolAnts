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
MAFighter >> doSimulationStepFor: anAnt [


]

{ #category : #role }
MAFighter >> moveFrom: aPosition [

	| newPos AntHillPos |
	
	newPos := aPosition + (((Random new next * 10 - 5) rounded) @ ((Random new next * 10 - 5) rounded)).
	AntHillPos := MASimulationManager simulationAntHillPosition.
		
	(newPos x < (AntHillPos x - 50)) ifTrue: [
		newPos := (AntHillPos x - 50)@(newPos y)
	].
	(newPos y < (AntHillPos y - 50)) ifTrue: [
		newPos := (newPos x)@(AntHillPos y - 50)
	].
	(newPos x > (AntHillPos x + 50)) ifTrue: [
		newPos := (AntHillPos x + 50)@(newPos y)
	].
	(newPos y > (AntHillPos y + 50)) ifTrue: [ 
		newPos := (newPos x)@(AntHillPos y + 50)
	].
		
	^ newPos.
]
