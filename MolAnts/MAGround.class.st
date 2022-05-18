Class {
	#name : #MAGround,
	#superclass : #BlElement,
	#traits : 'MolComponentImpl + TMAGroundType + TMASimulationEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAGroundType classTrait + TMASimulationEvents classTrait',
	#instVars : [
		'mySpace'
	],
	#category : #'MolAnts-View'
}

{ #category : #'events - lifecycle' }
MAGround >> ant: aModelObject changeRole: aSymbol [

	aSymbol = #queen ifTrue:[
		self childWithId: aModelObject componentName ifFound: [ :e |
			e background: (Color fromHexString: 'e000ff').
			e size: 5@5.
		].
	].

	aSymbol = #fighter ifTrue:[
		self childWithId: aModelObject componentName ifFound: [ :e |
			e background: (Color fromHexString: '68ff00').
		].
	].
]

{ #category : #'events - lifecycle' }
MAGround >> ant: aModelObject changeStage: aSymbol [
	
	aSymbol = #adult ifTrue:[
		self childWithId: aModelObject componentName ifFound: [ :e |
			e background: (Color fromHexString: '#DFFF00').	
		].
	].
]

{ #category : #'events - lifecycle' }
MAGround >> antBorn: anAnt [

	| antView |
	antView := BlElement new.
	antView id: anAnt componentName.
	antView geometry: BlCircleGeometry new.
	antView background: Color white.
	antView relocate: anAnt position.
	antView size: 3@3.
	antView zIndex: 3.
	self addChild: antView.
]

{ #category : #'events - lifecycle' }
MAGround >> antDead: anAnt [

	self childWithId: anAnt componentName ifFound: [ :e |
		self removeChild: e.	
	].

]

{ #category : #'life cycle' }
MAGround >> componentActivate [
	
	self getTMASimulationEventsSubscriber subscribe: self.
	
	mySpace := self openInNewSpace extent: (MASimulationManager simulationWidth + 5)@(MASimulationManager simulationWidth + 5).
]

{ #category : #'life cycle' }
MAGround >> componentPassivate [
	
	self getTMASimulationEventsSubscriber unsubscribe: self.
]

{ #category : #'life cycle' }
MAGround >> componentRemove [
	"here write the code corresponding to component remove phase"
	
	self stopped.
	mySpace close.
]

{ #category : #'component accessing' }
MAGround >> getTMASimulationEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMASimulationEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMASimulationEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #initialization }
MAGround >> initialize [ 

	super initialize.
	self constraintsDo:[ :c | 
			c horizontal matchParent. 
			c vertical matchParent 
	].
	self background: (Color fromHexString: 'c7baae').
]

{ #category : #'events - lifecycle' }
MAGround >> insectBorn: anInsect [

	| inscetView |
	inscetView := BlElement new.
	inscetView id: anInsect componentName.
	inscetView geometry: BlCircleGeometry new.
	inscetView background: Color black.
	inscetView relocate: anInsect position.
	inscetView size: 3@3.
	inscetView zIndex: 2.
	self addChild: inscetView.
]

{ #category : #'events - lifecycle' }
MAGround >> insectDead: anInsect [

	self childWithId: anInsect componentName ifFound: [ :e |
		e background: Color red.	
	].

]

{ #category : #'events - lifecycle' }
MAGround >> intensityChanged: anInteger for: aPheromone [

	self childWithId: aPheromone componentName ifFound: [ :e |
		e opacity: (aPheromone intensity/MAPheromone maxIntensity).	
	].

]

{ #category : #'events - lifecycle' }
MAGround >> pheromoneBorn: aPheromone [

	| pheromoneView |
	pheromoneView := BlElement new.
	pheromoneView id: aPheromone componentName.
	pheromoneView geometry: BlCircleGeometry new.
	pheromoneView background: Color blue.
	pheromoneView relocate: aPheromone position.
	pheromoneView size: 3@3.
	pheromoneView opacity: 1.0.
	pheromoneView zIndex: 1.
	self addChild: pheromoneView.
]

{ #category : #'events - lifecycle' }
MAGround >> pheromoneDead: aPheromone [

	self childWithId: aPheromone componentName ifFound: [ :e |
		self removeChild: e.
	].

]

{ #category : #events }
MAGround >> positionChanged: aPoint for: aModelObject [

	self childWithId: aModelObject componentName ifFound: [ :e |
		e relocate: aModelObject position.
	].
]

{ #category : #'events - control' }
MAGround >> stopped [

	self removeChildren 	
]
