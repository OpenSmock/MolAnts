Class {
	#name : #MAAnt,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAAntsType + TMASimulationServices + TMASimulationEvents + TMAAntServices',
	#classTraits : 'MolComponentImpl classTrait + TMAAntsType classTrait + TMASimulationServices classTrait + TMASimulationEvents classTrait + TMAAntServices classTrait',
	#instVars : [
		'position',
		'ageInMs'
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
	
	self initializeStage.
	
	self forServices: TMAStageServices useProvider: (#stage, self componentName asSymbol) asSymbol.

	ageInMs := 0.
]

{ #category : #'life cycle' }
MAAnt >> componentPassivate [
		
	self getTMASimulationEventsSubscriber unsubscribe: self.
	
]

{ #category : #'life cycle' }
MAAnt >> componentRemove [
	"here write the code corresponding to component remove phase"
	
	self removeStage.
]

{ #category : #private }
MAAnt >> doSimulationStep [

	ageInMs := ageInMs + MASimulationManager simulationStepDurationInMs.
	self getStage doSimulationStepFor: self.
	
	self position: (self getStage moveFrom: self position).  
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
MAAnt >> getTMAStageServicesProvider [
	| servicesSymbol servicesProvider itf |
	itf := TMAStageServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [^MolNotFoundServicesProvider new interface: itf name: nil].
	servicesSymbol isSymbol
	 	ifTrue: 
			[servicesProvider := MolComponentManager default locatorServices 
						searchServicesProviderFor: TMAStageServices named: servicesSymbol]. 
	^servicesProvider
]

{ #category : #stage }
MAAnt >> initializeStage [

	MAStage start: (#stage, self componentName asSymbol) asSymbol
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

{ #category : #stage }
MAAnt >> removeStage [

	MAStage stop: (#stage, self componentName asSymbol) asSymbol
]

{ #category : #'events - lifecycle' }
MAAnt >> simulationStepSent [

	self doSimulationStep.
]
