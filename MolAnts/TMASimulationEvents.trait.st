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

{ #category : #'events - control' }
TMASimulationEvents >> paused [
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
