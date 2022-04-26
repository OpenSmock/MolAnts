Trait {
	#name : #TMAAntsType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'MolAnts-Molecule Contracts'
}

{ #category : #'accessing - events' }
TMAAntsType classSide >> consumedComponentEvents [
	<componentContract>
	^ {TMASimulationEvents }
]

{ #category : #'accessing - events' }
TMAAntsType classSide >> producedComponentEvents [
	<componentContract>
	^ {TMAPositionEvents . TMAStateEvents } 
]

{ #category : #'accessing - services' }
TMAAntsType classSide >> providedComponentServices [
	<componentContract>
	^ {} 
]
