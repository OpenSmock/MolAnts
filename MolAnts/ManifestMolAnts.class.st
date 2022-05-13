"
To start the simulation :

MASimulationManager start.
"
Class {
	#name : #ManifestMolAnts,
	#superclass : #PackageManifest,
	#category : #'MolAnts-Manifest'
}

{ #category : #'code-critics' }
ManifestMolAnts class >> ruleGuardingClauseRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#MolAnts)) #'2022-05-13T07:29:41.80178+01:00') )
]

{ #category : #'code-critics' }
ManifestMolAnts class >> ruleReGuardClauseRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#MolAnts)) #'2022-05-13T07:29:44.66026+01:00') )
]

{ #category : #'code-critics' }
ManifestMolAnts class >> ruleRefersToClassRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#MASimulationManager #start #false)) #'2022-05-12T14:12:58.495687+01:00') #(#(#RGClassDefinition #(#MASimulationManager)) #'2022-05-12T14:19:02.133629+01:00') )
]

{ #category : #'code-critics' }
ManifestMolAnts class >> ruleStringConcatenationRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#MASimulationManager #start #false)) #'2022-05-12T13:21:16.824486+01:00') #(#(#RGClassDefinition #(#MASimulationManager)) #'2022-05-12T14:18:59.859494+01:00') )
]
