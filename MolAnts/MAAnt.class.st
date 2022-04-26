Class {
	#name : #MAAnt,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAAntsType + TMASimulationServices + TMASimulationEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAAntsType classTrait + TMASimulationServices classTrait + TMASimulationEvents classTrait',
	#instVars : [
		'position',
		'state',
		'ageInMs',
		'eggStateDurationInMs',
		'adultStateDurationInMs'
	],
	#category : #'MolAnts-Model'
}

{ #category : #'life cycle' }
MAAnt >> componentActivate [
	
	self getTMASimulationEventsSubscriber subscribe: self.
]

{ #category : #'life cycle' }
MAAnt >> componentInitialize [
	"here write the code corresponding to component initialisation phase"
	
	self state: #egg.

	eggStateDurationInMs := (Random new next * 10000) rounded + 10000.
	adultStateDurationInMs := (Random new next * 50000) rounded + 50000.
	ageInMs := 0.
]

{ #category : #'life cycle' }
MAAnt >> componentPassivate [
	
	self getTMASimulationEventsSubscriber unsubscribe: self.
	
]

{ #category : #private }
MAAnt >> computeState [

	self state = #egg ifTrue:[
		ageInMs > eggStateDurationInMs ifTrue:[ self state: #adult ].
		^self	
	].

	self state = #adult ifTrue:[
		ageInMs > adultStateDurationInMs ifTrue:[ self state: #dead ].
		^self	
	].
]

{ #category : #private }
MAAnt >> doSimulationStep [

	ageInMs := ageInMs + MASimulationManager simulationStepDurationInMs.
	self computeState.
	self move.
]

{ #category : #'component accessing' }
MAAnt >> getTMAPositionEventsNotifier [
	^self eventsNotifiers at: TMAPositionEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMAPositionEvents name: nil].
]

{ #category : #'component accessing' }
MAAnt >> getTMASimulationEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMASimulationEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMASimulationEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MAAnt >> getTMAStateEventsNotifier [
	^self eventsNotifiers at: TMAStateEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMAStateEvents name: nil].
]

{ #category : #private }
MAAnt >> move [

	self state ~= #adult ifTrue:[^self].
	
	self position: (self position + (((Random new next * 10 - 5) rounded) @ ((Random new next * 10 - 5) rounded))).
]

{ #category : #accessing }
MAAnt >> position [

	^ position
]

{ #category : #accessing }
MAAnt >> position: aPoint [

	position ~= aPoint ifFalse:[^self]. 
	position := aPoint.
	self getTMAPositionEventsNotifier positionChanged: aPoint for: self.
	
	
]

{ #category : #'events - lifecycle' }
MAAnt >> simulationStepSent [

	self doSimulationStep.
]

{ #category : #accessing }
MAAnt >> state [

	^ state
]

{ #category : #accessing }
MAAnt >> state: anObject [

	state ~= anObject ifFalse:[^self].
	state := anObject.
	self getTMAStateEventsNotifier stateChanged: state for: self.
]
