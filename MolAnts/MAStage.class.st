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

{ #category : #private }
MAStage >> computeStageFor: anAnt [
	
	self getStageName = #egg ifTrue:[
		ageInMs > eggStateDurationInMs ifTrue:[ 
			stageName := #adult.
			self getTMAStageEventsNotifier stageNameChanged: stageName for: anAnt. 
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
MAStage >> getTMAStageEventsNotifier [
	^self eventsNotifiers at: TMAStageEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMAStageEvents name: nil].
]

{ #category : #role }
MAStage >> moveFrom: aPosition [

	self getStageName ~= #adult ifTrue:[^aPosition].
	^ aPosition + (((Random new next * 10 - 5) rounded) @ ((Random new next * 10 - 5) rounded))
]
