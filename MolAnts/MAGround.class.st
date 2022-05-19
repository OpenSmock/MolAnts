Class {
	#name : #MAGround,
	#superclass : #BlElement,
	#traits : 'MolComponentImpl + TMAGroundType + TMASimulationEvents + TMAPheromoneEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAGroundType classTrait + TMASimulationEvents classTrait + TMAPheromoneEvents classTrait',
	#instVars : [
		'mySpace'
	],
	#category : #'MolAnts-View'
}

{ #category : #'accessing - events' }
MAGround class >> consumedComponentEvents [
	<componentContract>
	^ {TMASimulationEvents . TMAPheromoneEvents}
]

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
	self getTMAPheromoneEventsSubscriber subscribe: self.
	
	mySpace := self openInNewSpace extent: (MASimulationManager simulationWidth + 5)@(MASimulationManager simulationWidth + 5).
]

{ #category : #'life cycle' }
MAGround >> componentPassivate [
	
	self getTMASimulationEventsSubscriber unsubscribe: self.
	self getTMAPheromoneEventsSubscriber unsubscribe: self.
]

{ #category : #'life cycle' }
MAGround >> componentRemove [
	"here write the code corresponding to component remove phase"
	
	self stopped.
	mySpace close.
]

{ #category : #'component accessing' }
MAGround >> getTMAPheromoneEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMAPheromoneEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMAPheromoneEvents named: eventsSymbol ]. 
	^eventsSubscriber
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
MAGround >> insectEated: anInsect [

	self childWithId: anInsect componentName ifFound: [ :e |
		self removeChild: e.	
	].
]

{ #category : #events }
MAGround >> pheromoneBorn: aPoint [

	| pheromoneView |
	
	pheromoneView := BlPheromone new.
	pheromoneView id:(aPoint x printString, #@ , aPoint y printString) asSymbol.
	pheromoneView intensity: 1.0.
	pheromoneView location: aPoint.
	self addChild: pheromoneView.
]

{ #category : #events }
MAGround >> pheromoneDead: aPoint [

	self childWithId: ((aPoint x printString , #@ , aPoint y printString) asSymbol) ifFound: [ :e |
		self removeChild: e.
	].
]

{ #category : #events }
MAGround >> pheromoneUpdate: aDictionary [

	aDictionary keysDo: [ :each | 
		self childWithId: ((each x printString , #@ , each y printString) asSymbol) ifFound: [ :e |
			e intensity: ((aDictionary at: each)/MAPheromones maxIntensity).	 
		].
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

{ #category : #'events - lifecycle' }
MAGround >> workerDeliver: anAnt [

	self childWithId: anAnt componentName ifFound: [ :e |
		e background: (Color fromHexString: '#DFFF00').	
	].
]

{ #category : #'events - lifecycle' }
MAGround >> workerEat: anAnt [

	self childWithId: anAnt componentName ifFound: [ :e |
		e background: Color orange.	
	].
]
