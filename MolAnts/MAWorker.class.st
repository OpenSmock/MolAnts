Class {
	#name : #MAWorker,
	#superclass : #MARole,
	#instVars : [
		'phase'
	],
	#category : #'MolAnts-Model'
}

{ #category : #role }
MAWorker >> avoidPheromones: aPheromoneOrderedCollection for: anAnt [
	
	| newPos onTop onLeft randomPheromone |
				
	randomPheromone := Random new nextIntegerBetween: 1 and: aPheromoneOrderedCollection size .
	((anAnt position - aPheromoneOrderedCollection at: randomPheromone) x < 0)
		ifTrue: [ onLeft := false. ] ifFalse: [ 	onLeft := true. ].	
	((anAnt position - aPheromoneOrderedCollection at: randomPheromone) y < 0)
		ifTrue: [ onTop := false. ] ifFalse: [ onTop := true. ].
		
	"newPos := (anAnt position) + (((Random new nextIntegerBetween: 1 and: 3) rounded) @ ((Random new nextIntegerBetween: 1 and: 3) rounded)). "
	newPos := anAnt position.	
	onLeft 
		ifTrue: [ newPos := newPos + (((Random new nextIntegerBetween: 1 and: 3) rounded)@0).  ]
		ifFalse: [ newPos := newPos - (((Random new nextIntegerBetween: 1 and: 3) rounded)@0). ].
	onTop
		ifTrue: [ newPos := newPos + (0@((Random new nextIntegerBetween: 1 and: 3) rounded)).  ]
		ifFalse: [ newPos := newPos - (0@((Random new nextIntegerBetween: 1 and: 3) rounded)). ].

	^ newPos.
]

{ #category : #'life cycle' }
MAWorker >> componentInitialize [
	"here write the code corresponding to component initialisation phase"
	
	roleName := #worker.
	phase := #explorating.
]

{ #category : #role }
MAWorker >> doSimulationStepFor: anAnt [

	phase = #explorating ifTrue: [
		| antRectangle insectsList |
	
		antRectangle := BlBounds origin: ((anAnt position) - (5@5)) extent: (10@10).
	
		insectsList := anAnt getInsects.
	
		insectsList keysDo: [ :each | | insectRectangle |
			insectRectangle := BlBounds origin: (each) extent: (0@0).
			(antRectangle intersects: insectRectangle) ifTrue: [
				self getTMARoleEventsNotifier worker: anAnt eatAt: each.
				phase := #retrunToAntHill.
				^ self.
			].
		].
	].

	phase = #retrunToAntHill ifTrue: [
			
		| antRectangle  antHillRectangle |
			
		antRectangle := BlBounds origin: ((anAnt position) - (10@10)) extent: (20@20).
		antHillRectangle := BlBounds origin: MASimulationManager simulationAntHillPosition extent: (0@0).
		(antRectangle intersects: antHillRectangle) ifTrue: [
			phase := #explorating.
			self getTMARoleEventsNotifier workerDeliver: anAnt.
			Transcript show:'WorkerDeliver'; cr.
		].
	].

]

{ #category : #role }
MAWorker >> getPheromonesAround: anAnt [ 

	| antRectangle pheromonesDict pheromonesVisibles |
			
	antRectangle := BlBounds origin: ((anAnt position) - (5@5)) extent: (10@10).
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
	^ pheromonesVisibles.
]

{ #category : #role }
MAWorker >> moveFrom: anAnt [
	
	| newPos |
	
	phase = #explorating ifTrue: [ | pheromonesVisibles |
			
		pheromonesVisibles := self getPheromonesAround: anAnt.
	
		pheromonesVisibles ifEmpty: [
			newPos := self randomMove: anAnt.
		] ifNotEmpty: [
			(Random new nextIntegerBetween: 1 and: 10) > 1 ifTrue: [
				newPos := self avoidPheromones: pheromonesVisibles for: anAnt.
			] ifFalse: [ 
				newPos := self randomMove: anAnt.
			].
		].
	
		newPos := self newPositionCheckBorder: newPos.
		self getTMARoleEventsNotifier workerExploringPositionChanged: newPos for: anAnt.
		^ newPos.
	].
	phase = #retrunToAntHill ifTrue: [ | pheromonesVisibles |
		
		pheromonesVisibles := self getPheromonesAround: anAnt.
	
		pheromonesVisibles ifEmpty: [
			newPos := self randomMove: anAnt.
		] ifNotEmpty: [
			(Random new nextIntegerBetween: 1 and: 10) > 1 ifTrue: [
				newPos := self targetPheromones: pheromonesVisibles for: anAnt.
			] ifFalse: [ 
				newPos := self randomMove: anAnt.
			].
		].
	
		newPos := self newPositionCheckBorder: newPos.
		self getTMARoleEventsNotifier workerReturningPositionChanged: newPos for: anAnt .
		^ newPos.
	].
]

{ #category : #role }
MAWorker >> newPositionCheckBorder: aPoint [
	"Check if the ant is in the ground. If not keep the ant on the ground."
	| newPos |
	
	newPos:=aPoint.	

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

{ #category : #role }
MAWorker >> randomMove: anAnt [

	^ (anAnt position) + ((((Random new nextIntegerBetween: 0 and: 6)-3) rounded) @ (((Random new nextIntegerBetween: 0 and: 6)-3) rounded)). 
]

{ #category : #role }
MAWorker >> targetPheromones: aPheromoneOrderedCollection for: anAnt [
	
	| newPos randomPheromone |
	
	randomPheromone := Random new nextIntegerBetween: 1 and: aPheromoneOrderedCollection size .
	newPos := aPheromoneOrderedCollection at: randomPheromone.

	^ newPos.
]
