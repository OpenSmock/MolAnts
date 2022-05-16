Class {
	#name : #MAWorker,
	#superclass : #MARole,
	#category : #'MolAnts-Model'
}

{ #category : #'life cycle' }
MAWorker >> componentInitialize [
	"here write the code corresponding to component initialisation phase"
	
	roleName := #worker
]

{ #category : #role }
MAWorker >> doSimulationStepFor: anAnt [
]

{ #category : #role }
MAWorker >> moveFrom: aPosition [
	
	| newPos |
	
	newPos := aPosition + (((Random new next * 10 - 5) rounded) @ ((Random new next * 10 - 5) rounded)). 
	
	(newPos x < 0) ifTrue: [
		newPos := 0@(newPos y)
	].
	(newPos y < 0) ifTrue: [
		newPos := (newPos x)@0
	].
	(newPos x > MASimulationManager simulationWidth) ifTrue: [
		newPos := (MASimulationManager simulationHeight)@(newPos y)
	].
	(newPos y > MASimulationManager simulationHeight ) ifTrue: [ 
		newPos := (newPos x)@(MASimulationManager simulationWidth)
	].

	^ newPos.
]
