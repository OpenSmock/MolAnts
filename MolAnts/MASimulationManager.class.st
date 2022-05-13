Class {
	#name : #MASimulationManager,
	#superclass : #MolAbstractComponentImpl,
	#traits : 'TMASimulationManagerType + TMAStageEvents + TMASimulationServices',
	#classTraits : 'TMASimulationManagerType classTrait + TMAStageEvents classTrait + TMASimulationServices classTrait',
	#instVars : [
		'simulationThread',
		'ground',
		'isAntHillCreated'
	],
	#category : #'MolAnts-Core'
}

{ #category : #properties }
MASimulationManager class >> simulationHeight [

	^ 500
]

{ #category : #properties }
MASimulationManager class >> simulationStepDurationInMs [

	^ 50
]

{ #category : #properties }
MASimulationManager class >> simulationWidth [

	^ 500
]

{ #category : #scripts }
MASimulationManager class >> startSimulation [
	<script>
	
	self start.
]

{ #category : #'component life cycle' }
MASimulationManager >> componentActivate [ 

	super componentActivate.
	self getTMAStageEventsSubscriber subscribe: self.
	
	ground := MAGround start: 'Ground'. 
	self start.
]

{ #category : #'component life cycle' }
MASimulationManager >> componentInitialize [ 
	"Create a ground"

	super componentInitialize.

]

{ #category : #'component life cycle' }
MASimulationManager >> componentPassivate [

	self getTMAStageEventsSubscriber unsubscribe: self.
	
	MAGround stop: 'Ground'.
	ground := nil.
	self stop.
	super componentPassivate.

]

{ #category : #private }
MASimulationManager >> createAntHill [

	self isAntHillCreated: true.

	"Create x ants"
	1 to: 50 do:[ :e | | ant name |
		"Create Ant"
		name := ('Ant', e printString) asSymbol.
		ant := MAAnt start: name.
		ant position: 200@200.
		
		"Adding events producer into SimulationMManager and Ground"
		self forEvents: TMAStageEvents addProducer: (ant getStage componentName). 
		ground forEvents: TMAPositionEvents addProducer: name.
		
		"Notify Ant creation"
		self getTMASimulationEventsNotifier antBorn: ant.
	].

	
]

{ #category : #private }
MASimulationManager >> createInsects [

	"Create 100 insects"
	1 to: 100 do:[ :e | | insect name |
		"Create Ant"
		name := ('Insect', e printString) asSymbol.
		insect := MAInsect start: name.
		insect position: (Random new nextIntegerBetween: 1 and: MASimulationManager simulationWidth)@(Random new nextIntegerBetween: 1 and: MASimulationManager simulationHeight).
		
		"Adding events producer into SimulationMManager and Ground"
		ground forEvents: TMAPositionEvents addProducer: name.
		
		"Notify Ant creation"
		self getTMASimulationEventsNotifier insectBorn: insect.
	].
	
]

{ #category : #'component accessing' }
MASimulationManager >> getTMASimulationEventsNotifier [
	^self eventsNotifiers at: TMASimulationEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMASimulationEvents name: nil].
]

{ #category : #'component accessing' }
MASimulationManager >> getTMAStageEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMAStageEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMAStageEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #accessing }
MASimulationManager >> isAntHillCreated [

	^ isAntHillCreated ifNil:[ isAntHillCreated := false ]
]

{ #category : #accessing }
MASimulationManager >> isAntHillCreated: anObject [

	isAntHillCreated := anObject
]

{ #category : #services }
MASimulationManager >> pause [

	self isRunning ifFalse:[^self].
	self pauseSimulationLoop.
	isRunning := false.
	self getTMASimulationEventsNotifier paused.
]

{ #category : #private }
MASimulationManager >> pauseSimulationLoop [

	simulationThread ifNil:[^self].
	simulationThread suspend.
]

{ #category : #private }
MASimulationManager >> removeAntHill [

	"Delete x ants"
	1 to: 50 do:[ :e | | name |
		"Delete Ant"
		name := ('Ant', e printString) asSymbol.
		MAAnt stop: name.
	].
	
	self isAntHillCreated: false.
]

{ #category : #events }
MASimulationManager >> roleChanged: aSymbol for: aModelObject [

	self getTMASimulationEventsNotifier ant: aModelObject changeRole: aSymbol.
	^ self
]

{ #category : #events }
MASimulationManager >> stageNameChanged: aSymbol for: aModelObject [

	aSymbol = #dead ifFalse:[
		self getTMASimulationEventsNotifier ant: aModelObject changeStage: aSymbol.
		^self.
	].
	
	self getTMASimulationEventsNotifier antDead: aModelObject.
]

{ #category : #services }
MASimulationManager >> start [

	self isRunning ifTrue:[^self].
	self isAntHillCreated ifFalse:[self createAntHill].
	
	self createInsects.

	self startSimulationLoop.
	isRunning := true.
	self getTMASimulationEventsNotifier started.
]

{ #category : #private }
MASimulationManager >> startSimulationLoop [

	simulationThread ifNil:[
		simulationThread := [
			[true] whileTrue: [ 
				self getTMASimulationEventsNotifier simulationStepSent.
				(Delay forMilliseconds: self class simulationStepDurationInMs) wait. 	
			].
		] newProcess priority: Processor userBackgroundPriority.

		simulationThread name: 'Molecule SimulationManager Process'.
	].
	
	simulationThread resume.
]

{ #category : #services }
MASimulationManager >> stop [

	self stopSimulationLoop.
	self isAntHillCreated ifTrue:[	self removeAntHill ].
	isRunning := false.
	self getTMASimulationEventsNotifier stopped.
]

{ #category : #private }
MASimulationManager >> stopSimulationLoop [

	simulationThread ifNil:[^self].

	simulationThread terminate.
	simulationThread := nil.	
	
]
