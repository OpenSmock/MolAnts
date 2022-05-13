Trait {
	#name : #TMARoleType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'MolAnts-Molecule Contracts'
}

{ #category : #'accessing - services' }
TMARoleType classSide >> providedComponentServices [
	<componentContract>
	^ {TMARoleServices} 
]
