Class {
	#name : #MAGround,
	#superclass : #BlElement,
	#traits : 'MolComponentImpl + TMAGroundType + TMAPositionEvents + TMASimulationEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAGroundType classTrait + TMAPositionEvents classTrait + TMASimulationEvents classTrait',
	#category : #'MolAnts-View'
}

{ #category : #'events - lifecycle' }
MAGround >> antBorn: anAnt [

	| antView |
	antView := BlElement new.
	antView id: anAnt componentName.
	antView geometry: BlCircleGeometry new.
	antView background: Color white.
	antView relocate: anAnt position.
	antView size: 2@2.
	
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
	
	self openInNewSpace.
]

{ #category : #'life cycle' }
MAGround >> componentPassivate [
	
	self getTMAPositionEventsSubscriber unsubscribe: self.
	self getTMASimulationEventsSubscriber unsubscribe: self.
]

{ #category : #'component accessing' }
MAGround >> getTMAPositionEventsSubscriber [
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
	self background: Color brown.
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
