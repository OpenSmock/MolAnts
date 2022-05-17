Class {
	#name : #MASimulationManager,
	#superclass : #MolAbstractComponentImpl,
	#traits : 'TMASimulationManagerType + TMAStageEvents + TMASimulationServices + TMARoleEvents + TMAPositionEvents',
	#classTraits : 'TMASimulationManagerType classTrait + TMAStageEvents classTrait + TMASimulationServices classTrait + TMARoleEvents classTrait + TMAPositionEvents classTrait',
	#instVars : [
		'simulationThread',
		'ground',
		'isAntHillCreated',
		'isInsectsCreated',
		'nbAnt',
		'InsectsPos'
	],
	#category : #'MolAnts-Core'
}

{ #category : #properties }
MASimulationManager class >> simulationAntHillPosition [

	^ 200@200.
]

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

{ #category : #scripts }
MASimulationManager class >> stopSimulation [
	<script>
	
	self stop.
	MolComponentManager cleanUp.
	
]

{ #category : #services }
MASimulationManager >> InsectsPos [

	^ InsectsPos.
]

{ #category : #events }
MASimulationManager >> ant: anAnt eatAt: aPoint [

	| insect |
	
	"remove the insect in the dictionary."
	(InsectsPos includesKey: aPoint) ifTrue: [
		insect := (InsectsPos at: aPoint) removeFirst.
		(InsectsPos at: aPoint) isEmpty ifTrue:[
			InsectsPos removeKey: aPoint.
		].
	].

	"remove the insect from the ground."
	self getTMASimulationEventsNotifier insectDead: insect.
	
	"Tell the insect that he is dead."
]

{ #category : #'component life cycle' }
MASimulationManager >> componentActivate [ 

	super componentActivate.
	self getTMAStageEventsSubscriber subscribe: self.
	self getTMARoleEventsSubscriber subscribe: self.
	self getTMAPositionEventsSubscriber subscribe: self.
	
	ground := MAGround start: 'Ground'. 
	self start.
]

{ #category : #'component life cycle' }
MASimulationManager >> componentInitialize [ 
	"Create a ground"

	super componentInitialize.
	simulationThread := nil.
	ground := nil.
	isAntHillCreated := false.
	isInsectsCreated := false.
	nbAnt := 0.
	InsectsPos := Dictionary new.
]

{ #category : #'component life cycle' }
MASimulationManager >> componentPassivate [

	self getTMAStageEventsSubscriber unsubscribe: self.
	self getTMARoleEventsSubscriber unsubscribe: self.
	self getTMAPositionEventsSubscriber unsubscribe: self.
	
	super componentPassivate.

]

{ #category : #'component life cycle' }
MASimulationManager >> componentRemove [

	self stop.

]

{ #category : #private }
MASimulationManager >> createAnt [
	
	| name ant |

	isAntHillCreated ifTrue: [ 
		
		nbAnt := nbAnt + 1.
		
		name := ('Ant', nbAnt printString) asSymbol.
		ant := MAAnt start: name.
		ant position: self class simulationAntHillPosition.
		
		"Adding events producer into SimulationMManager and Ground"
		self forEvents: TMAStageEvents addProducer: (ant getStage componentName). 
		self forEvents: TMARoleEvents addProducer: (ant getStage getRole componentName). 
		self forEvents: TMAPositionEvents addProducer: name.
		
		"Notify Ant creation"
		self getTMASimulationEventsNotifier antBorn: ant.
	].

	
]

{ #category : #private }
MASimulationManager >> createAntHill [

	self isAntHillCreated: true.

	"Create x ants"
	"1 to: 50 do:[ :e |
		self createAnt.
	]."
	
	"Create the first queen of ants"
	self createAnt.
	
]

{ #category : #private }
MASimulationManager >> createInsects [

	self isInsectsCreated: true.

	"Create 100 insects"
	1 to: 100 do:[ :e | | insect name newPos |
		"Create Ant"
		name := ('Insect', e printString) asSymbol.
		insect := MAInsect start: name.
		
		newPos := (Random new nextIntegerBetween: 1 and: MASimulationManager simulationWidth)@(Random new nextIntegerBetween: 1 and: MASimulationManager simulationHeight).
		insect position: newPos.
		
		"Adding events producer into SimulationMManager"
		self forEvents: TMAPositionEvents addProducer: name.
		
		"Notify Ant creation"
		self getTMASimulationEventsNotifier insectBorn: insect.
		
		"Add the insect to the dictionary of their positions."
		(InsectsPos includesKey: newPos) ifFalse:[ | collection |
			collection := (OrderedCollection new).
			collection add:insect.
			InsectsPos add: (newPos -> collection ).
		] ifTrue: [
			(InsectsPos at: newPos) addLast: insect.
		].
	].
	
]

{ #category : #'component accessing' }
MASimulationManager >> getTMAPositionEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMAPositionEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMAPositionEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MASimulationManager >> getTMARoleEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMARoleEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMARoleEvents named: eventsSymbol ]. 
	^eventsSubscriber
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

{ #category : #accessing }
MASimulationManager >> isInsectsCreated [

	^ isInsectsCreated
]

{ #category : #accessing }
MASimulationManager >> isInsectsCreated: anObject [

	isInsectsCreated := anObject
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

{ #category : #events }
MASimulationManager >> positionChanged: aPoint for: aModelObject [

	self getTMASimulationEventsNotifier positionChanged: aPoint for: aModelObject.
]

{ #category : #events }
MASimulationManager >> positionChangedFor: aModelObject oldPos: aPoint newPos: anotherPoint [

	"Add the insect position in the dictionary."
	
	"remove the old position."
	(InsectsPos includesKey: aPoint) ifTrue: [
		(InsectsPos at: aPoint) remove: aModelObject ifAbsent: [].
		(InsectsPos at: aPoint) isEmpty ifTrue:[
			InsectsPos removeKey: aPoint.
		].
	].
	
	"Add to the new position."
	(InsectsPos includesKey: anotherPoint) ifFalse:[ | collection |
		collection := (OrderedCollection new).
		collection add: aModelObject.
		InsectsPos add: (anotherPoint -> collection ).
	] ifTrue: [
		(InsectsPos at: anotherPoint) addLast: aModelObject.
	].
	
	self getTMASimulationEventsNotifier positionChanged: anotherPoint for: aModelObject.
]

{ #category : #events }
MASimulationManager >> queenLaid [

	self createAnt.
]

{ #category : #private }
MASimulationManager >> removeAntHill [

	"Delete nbAnt ants"
	1 to: nbAnt do:[ :e | | name |
		"Delete Ant"
		name := ('Ant', e printString) asSymbol.
		MAAnt stop: name.
	].

	nbAnt := 0.
	self isAntHillCreated: false.
]

{ #category : #private }
MASimulationManager >> removeInsects [

	"Delete 100 insects"
	1 to: 100 do:[ :e | | name |
		"Delete insect"
		name := ('Insect', e printString) asSymbol.
		MAInsect stop: name.
	].
	
	self isInsectsCreated: false.
	InsectsPos := nil
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
	
	MAGround stop: 'Ground'.
	ground := nil.
	
	self isAntHillCreated ifTrue:[	self removeAntHill ].
	self isInsectsCreated ifTrue:[	self removeInsects ].
		
	isRunning := false.
	
	self getTMASimulationEventsNotifier stopped.
]

{ #category : #private }
MASimulationManager >> stopSimulationLoop [

	simulationThread ifNil:[^self].
	simulationThread terminate.
	simulationThread := nil.	
	
]
