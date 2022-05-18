Class {
	#name : #MAWorker,
	#superclass : #MARole,
	#instVars : [
		'phase'
	],
	#category : #'MolAnts-Model'
}

{ #category : #'life cycle' }
MAWorker >> componentInitialize [
	"here write the code corresponding to component initialisation phase"
	
	roleName := #worker.
	phase := #explorating.
]

{ #category : #role }
MAWorker >> doSimulationStepFor: anAnt [
]

{ #category : #role }
MAWorker >> moveFrom: anAnt [
	
	| newPos |
	
	phase = #explorating ifTrue: [ | antRectangle pheromonesDict pheromonesVisibles |
			
		antRectangle := BlBounds origin: ((anAnt position) - (10@10)) extent: (20@20).
		pheromonesDict := anAnt getPheromonesDict.
		pheromonesVisibles := OrderedCollection new.
		pheromonesDict keysDo: [ :each | | pheromoneRectangle |
			each = anAnt position ifFalse:[
				pheromoneRectangle := BlBounds origin: (each) extent: (0@0).
				(antRectangle intersects: pheromoneRectangle) ifTrue: [
					pheromonesVisibles add: each.
				].
			].
		].
	
		pheromonesVisibles isEmpty ifTrue:[
			newPos := (anAnt position) + (((Random new next * 10 - 5) rounded) @ ((Random new next * 10 - 5) rounded)). 
		] ifFalse: [ 
			(Random new nextIntegerBetween: 1 and: 3) = 1 ifTrue:[
				newPos := (anAnt position) + (((Random new next * 10 - 5) rounded) @ ((Random new next * 10 - 5) rounded)). 
			] ifFalse: [ 
				newPos := anAnt position + (anAnt position - pheromonesVisibles at: 1).
			].
		].
	
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
	].
]
