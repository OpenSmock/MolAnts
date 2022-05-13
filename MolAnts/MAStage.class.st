Class {
	#name : #MAStage,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAStageType + TMAStageServices',
	#classTraits : 'MolComponentImpl classTrait + TMAStageType classTrait + TMAStageServices classTrait',
	#instVars : [
		'ageInMs',
		'eggStateDurationInMs',
		'adultStateDurationInMs'
	],
	#category : #'MolAnts-Model'
}

{ #category : #'life cycle' }
MAStage >> componentActivate [
	
]

{ #category : #'life cycle' }
MAStage >> componentInitialize [
	
	eggStateDurationInMs := (Random new next * 10000) rounded + 1000.
	adultStateDurationInMs := (Random new next * 50000) rounded + 50000.
	ageInMs := 0.
	
]

{ #category : #'life cycle' }
MAStage >> componentRemove [
	"here write the code corresponding to component remove phase"
	
	self removeRole.
]

{ #category : #private }
MAStage >> computeStageFor: anAnt [
	
	self getStageName = #egg ifTrue:[
		ageInMs > eggStateDurationInMs ifTrue:[ 
			stageName := #adult.
			self getTMAStageEventsNotifier stageNameChanged: stageName for: anAnt.
			
			self initializeRole.
			self forServices: TMARoleServices useProvider: (#role, self componentName asSymbol) asSymbol.
			self getTMAStageEventsNotifier roleChanged: (self getRole getRoleName) for: anAnt.
		].
		^self	 
	]. 

	self getStageName = #adult ifTrue:[
		ageInMs > adultStateDurationInMs ifTrue:[
			stageName := #dead.
			self getTMAStageEventsNotifier stageNameChanged: stageName for: anAnt. 
		].
		^self	
	].
]

{ #category : #private }
MAStage >> doSimulationStepFor: anAnt [

	ageInMs := ageInMs + MASimulationManager simulationStepDurationInMs.
	self computeStageFor: anAnt.
]

{ #category : #'component accessing' }
MAStage >> getTMARoleServicesProvider [
	| servicesSymbol servicesProvider itf |
	itf := TMARoleServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [^MolNotFoundServicesProvider new interface: itf name: nil].
	servicesSymbol isSymbol
	 	ifTrue: 
			[servicesProvider := MolComponentManager default locatorServices 
						searchServicesProviderFor: TMARoleServices named: servicesSymbol]. 
	^servicesProvider
]

{ #category : #'component accessing' }
MAStage >> getTMAStageEventsNotifier [
	^self eventsNotifiers at: TMAStageEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMAStageEvents name: nil].
]

{ #category : #initialization }
MAStage >> initializeRole [
	
	role := MARole start: (#role, self componentName asSymbol) asSymbol.
]

{ #category : #role }
MAStage >> moveFrom: aPosition [

	self getStageName ~= #adult ifTrue:[^aPosition].
	^ (self getRole moveFrom: aPosition).

]

{ #category : #'life cycle' }
MAStage >> removeRole [

	MARole stop: (#role, self componentName asSymbol) asSymbol
]
