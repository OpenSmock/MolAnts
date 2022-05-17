Trait {
	#name : #TMAGroundType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'MolAnts-Molecule Contracts'
}

{ #category : #'accessing - events' }
TMAGroundType classSide >> consumedComponentEvents [
	<componentContract>
	^ {TMASimulationEvents}
]
