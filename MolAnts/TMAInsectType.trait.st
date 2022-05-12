Trait {
	#name : #TMAInsectType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'MolAnts-Molecule Contracts'
}

{ #category : #'accessing - events' }
TMAInsectType classSide >> consumedComponentEvents [
	<componentContract>
	^ {TMASimulationEvents}
]

{ #category : #'accessing - events' }
TMAInsectType classSide >> producedComponentEvents [
	<componentContract>
	^ {TMAPositionEvents} 
]
