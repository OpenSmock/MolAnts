Trait {
	#name : #TMAStageServices,
	#instVars : [
		'role',
		'stageName'
	],
	#traits : 'MolComponentServices',
	#classTraits : 'MolComponentServices classTrait',
	#category : #'MolAnts-Molecule Contracts'
}

{ #category : #role }
TMAStageServices >> getRole [

	^role
]

{ #category : #role }
TMAStageServices >> getStageName [

	^stageName ifNil: [ stageName := #egg ].
]

{ #category : #role }
TMAStageServices >> moveFrom: aPosition [
]
