Trait {
	#name : #TMASimulationEvents,
	#traits : 'MolComponentEvents',
	#classTraits : 'MolComponentEvents classTrait',
	#category : #'MolAnts-Molecule Contracts'
}

{ #category : #'events - lifecycle' }
TMASimulationEvents >> ant: aModelObject changeRole: aSymbol [
]

{ #category : #'events - lifecycle' }
TMASimulationEvents >> ant: aModelObject changeStage: aSymbol [
]

{ #category : #'events - lifecycle' }
TMASimulationEvents >> antBorn: anAnt [
]

{ #category : #'events - lifecycle' }
TMASimulationEvents >> antDead: anAnt [
]

{ #category : #'events - lifecycle' }
TMASimulationEvents >> insectBorn: anInsect [
]

{ #category : #'events - lifecycle' }
TMASimulationEvents >> insectDead: anInsect [
]

{ #category : #'events - lifecycle' }
TMASimulationEvents >> insectEated: anInsect [
]

{ #category : #'events - control' }
TMASimulationEvents >> paused [
]

{ #category : #'events - lifecycle' }
TMASimulationEvents >> pheromoneNew: aPoint [
]

{ #category : #'events - lifecycle' }
TMASimulationEvents >> pheromoneReturnNew: aPoint [
]

{ #category : #events }
TMASimulationEvents >> positionChanged: aPoint for: aModelObject [
]

{ #category : #'events - lifecycle' }
TMASimulationEvents >> simulationStepSent [
]

{ #category : #'events - control' }
TMASimulationEvents >> started [
]

{ #category : #'events - control' }
TMASimulationEvents >> stopped [
]

{ #category : #'events - lifecycle' }
TMASimulationEvents >> workerDeliver: anAnt [
]

{ #category : #'events - lifecycle' }
TMASimulationEvents >> workerEat: anAnt [
]
