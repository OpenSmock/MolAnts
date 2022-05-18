Trait {
	#name : #TMAPheromonesType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'MolAnts-Molecule Contracts'
}

{ #category : #'accessing - events' }
TMAPheromonesType classSide >> consumedComponentEvents [
	<componentContract>
	^ {TMASimulationEvents}
]

{ #category : #'accessing - events' }
TMAPheromonesType classSide >> producedComponentEvents [
	<componentContract>
	^ {TMAPheromoneEvents} 
]
