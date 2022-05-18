Class {
	#name : #MAPheromones,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAPheromonesType + TMASimulationEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAPheromonesType classTrait + TMASimulationEvents classTrait',
	#instVars : [
		'pheromonesDict',
		'compt'
	],
	#category : #'MolAnts-Model'
}

{ #category : #accessing }
MAPheromones class >> maxIntensity [

	^ 50.
]

{ #category : #'life cycle' }
MAPheromones >> componentActivate [

	self getTMASimulationEventsSubscriber subscribe: self.
]

{ #category : #'life cycle' }
MAPheromones >> componentInitialize [
	"here write the code corresponding to component initialisation phase"
	
	
	pheromonesDict := Dictionary new.
	compt := 0.
]

{ #category : #'life cycle' }
MAPheromones >> componentPassivate [

	self getTMASimulationEventsSubscriber unsubscribe: self.
]

{ #category : #'life cycle' }
MAPheromones >> componentRemove [

	pheromonesDict := nil.
	compt := 0.
]

{ #category : #'events - lifecycle' }
MAPheromones >> doSimulationStep [

	compt := compt + 1.
	
	pheromonesDict keysDo: [ :each | 
		pheromonesDict at: each update: [ :v | v-1 ].
		(pheromonesDict at: each) <= 0 ifTrue: [ 
			self getTMAPheromoneEventsNotifier pheromoneDead: each.
			pheromonesDict removeKey: each.
		].
	].
	
	(compt % 20 = 0) ifTrue: [
		self getTMAPheromoneEventsNotifier pheromoneUpdate: pheromonesDict.
	].
]

{ #category : #'component accessing' }
MAPheromones >> getTMAPheromoneEventsNotifier [
	^self eventsNotifiers at: TMAPheromoneEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMAPheromoneEvents name: nil].
]

{ #category : #'component accessing' }
MAPheromones >> getTMASimulationEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMASimulationEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMASimulationEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'events - lifecycle' }
MAPheromones >> pheromoneNew: aPoint [

		(pheromonesDict includesKey: aPoint) ifFalse:[
			pheromonesDict add: (aPoint -> self class maxIntensity).
			self getTMAPheromoneEventsNotifier pheromoneBorn: aPoint.
		] ifTrue: [
			pheromonesDict at: aPoint  update: [:v | v - v + self class maxIntensity].
		].
]

{ #category : #accessing }
MAPheromones >> pheromonesDict [

	^ pheromonesDict
]

{ #category : #'events - lifecycle' }
MAPheromones >> simulationStepSent [

	self doSimulationStep.
]
