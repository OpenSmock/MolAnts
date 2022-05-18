Class {
	#name : #MAPheromone,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAPheromonesType + TMASimulationEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAPheromonesType classTrait + TMASimulationEvents classTrait',
	#instVars : [
		'position',
		'intensity'
	],
	#category : #'MolAnts-Model'
}

{ #category : #accessing }
MAPheromone class >> maxIntensity [

	^ 50.
]

{ #category : #adding }
MAPheromone >> addIntensity [

	intensity := self class maxIntensity.
]

{ #category : #'life cycle' }
MAPheromone >> componentActivate [
		
	self getTMASimulationEventsSubscriber subscribe: self.
]

{ #category : #'life cycle' }
MAPheromone >> componentInitialize [
	"here write the code corresponding to component initialisation phase"
	
	position := 0@0.
	intensity := self class maxIntensity.
]

{ #category : #'life cycle' }
MAPheromone >> componentPassivate [
		
	self getTMASimulationEventsSubscriber unsubscribe: self.
]

{ #category : #'events - lifecycle' }
MAPheromone >> doSimulationStep [

	intensity > 0 ifTrue:[
		intensity := intensity - 1.
		intensity <= 0 ifTrue: [
			self getTMAPheromoneEventsNotifier intensityNilFor: self.
			^ self.
		].
		self getTMAPheromoneEventsNotifier intensityChanged: intensity for: self.
	].
]

{ #category : #'component accessing' }
MAPheromone >> getTMAPheromoneEventsNotifier [
	^self eventsNotifiers at: TMAPheromoneEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMAPheromoneEvents name: nil].
]

{ #category : #'component accessing' }
MAPheromone >> getTMASimulationEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMASimulationEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMASimulationEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #accessing }
MAPheromone >> intensity [

	^ intensity
]

{ #category : #accessing }
MAPheromone >> position [

	^ position
]

{ #category : #accessing }
MAPheromone >> position: anObject [

	position := anObject
]

{ #category : #'events - lifecycle' }
MAPheromone >> simulationStepSent [

	self doSimulationStep.
]
