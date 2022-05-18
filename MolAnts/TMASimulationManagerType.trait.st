Trait {
	#name : #TMASimulationManagerType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'MolAnts-Molecule Contracts'
}

{ #category : #'accessing - events' }
TMASimulationManagerType classSide >> consumedComponentEvents [
	<componentContract>
	^ {TMAStageEvents . TMARoleEvents . TMAPositionEvents . TMAPheromoneEvents}
]

{ #category : #'accessing - events' }
TMASimulationManagerType classSide >> producedComponentEvents [
	<componentContract>
	^ {TMASimulationEvents } 
]

{ #category : #'accessing - services' }
TMASimulationManagerType classSide >> providedComponentServices [
	<componentContract>
	^ {TMASimulationServices} 
]
