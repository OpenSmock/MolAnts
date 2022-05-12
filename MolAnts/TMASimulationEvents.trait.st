Trait {
	#name : #TMASimulationEvents,
	#traits : 'MolComponentEvents',
	#classTraits : 'MolComponentEvents classTrait',
	#category : #'MolAnts-Molecule Contracts'
}

{ #category : #'events - lifecycle' }
TMASimulationEvents >> ant: aModelObject changeState: aSymbol [
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

{ #category : #'events - control' }
TMASimulationEvents >> paused [
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
