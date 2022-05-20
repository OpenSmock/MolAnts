Class {
	#name : #MAGround,
	#superclass : #BlElement,
	#traits : 'MolComponentImpl + TMAGroundType + TMASimulationEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAGroundType classTrait + TMASimulationEvents classTrait',
	#instVars : [
		'mySpace',
		'compt'
	],
	#category : #'MolAnts-View'
}

{ #category : #'events - lifecycle' }
MAGround >> ant: aModelObject changeRole: aSymbol [

	aSymbol = #queen ifTrue:[
		self childWithId: aModelObject componentName ifFound: [ :e |
			e background: (Color fromHexString: 'e000ff').
			e size: 6@6.
			e relocate: (aModelObject position - (3@3)).
		].
	].

	aSymbol = #fighter ifTrue:[
		self childWithId: aModelObject componentName ifFound: [ :e |
			e background: (Color fromHexString: '68ff00').
			e size: 4@4.
			e relocate: (aModelObject position - (2@2)).
		].
	].
]

{ #category : #'events - lifecycle' }
MAGround >> ant: aModelObject changeStage: aSymbol [
	
	aSymbol = #adult ifTrue:[
		self childWithId: aModelObject componentName ifFound: [ :e |
			e background: (Color fromHexString: '#DFFF00').
			e size: 4@4.
			e relocate: (aModelObject position - (2@2)).
		].
	].
]

{ #category : #'events - lifecycle' }
MAGround >> antBorn: anAnt [

	| antView |
	antView := BlElement new.
	antView id: anAnt componentName.
	antView geometry: BlCircleGeometry new.
	antView background: Color purple.
	antView relocate: (anAnt position - (1@1)).
	antView size: 2@2.
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
	
	compt := 0.
]

{ #category : #'life cycle' }
MAGround >> componentPassivate [
	
	self getTMASimulationEventsSubscriber unsubscribe: self.
]

{ #category : #'life cycle' }
MAGround >> componentRemove [
	
	compt := 0.
	self stopped.
	mySpace ifNotNil:[
		mySpace close.
	].
]

{ #category : #drawing }
MAGround >> drawMeAndChildrenOnSpartaCanvas: aCanvas [
	self drawOnSpartaCanvas: aCanvas.
	(compt % 10) = 0 ifTrue:[
		self drawChildrenOnSpartaCanvas: aCanvas.
	].
]

{ #category : #drawing }
MAGround >> drawOnSpartaCanvas: aCanvas [
	
	super drawOnSpartaCanvas: aCanvas.
	
	aCanvas figure
		path: (aCanvas shape circleAt: MASimulationManager simulationAntHillPosition radius: 10);
		background: Color white;
		draw.
	
	self getTMAPheromoneServicesProvider getPheromonesDict keysAndValuesDo: [ :k :v |
		aCanvas figure
			path: (aCanvas shape circleAt: k radius: 2);
			background: Color blue;
			backgroundAlpha: (v/self getTMAPheromoneServicesProvider getMaxIntensity);
			draw.
	].
	self getTMAPheromoneServicesProvider getPheromonesReturnDict keysAndValuesDo: [ :k :v | 
		aCanvas figure
			path: (aCanvas shape circleAt: k radius: 2);
			background: Color cyan;
			backgroundAlpha: (v/self getTMAPheromoneServicesProvider getMaxIntensity);
			draw.
	].
]

{ #category : #'component accessing' }
MAGround >> getTMAPheromoneServicesProvider [
	| servicesSymbol servicesProvider itf |
	itf := TMAPheromoneServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [^MolNotFoundServicesProvider new interface: itf name: nil].
	servicesSymbol isSymbol
	 	ifTrue: 
			[servicesProvider := MolComponentManager default locatorServices 
						searchServicesProviderFor: TMAPheromoneServices named: servicesSymbol]. 
	^servicesProvider
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
	inscetView relocate: (anInsect position - (2@2)).
	inscetView size: 4@4.
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
MAGround >> positionChanged: aPoint for: aModelObject [

	self childWithId: aModelObject componentName ifFound: [ :e |
		e relocate: (aModelObject position - (2@2)).
	].
]

{ #category : #'events - lifecycle' }
MAGround >> simulationStepSent [

	compt := compt + 1.
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
