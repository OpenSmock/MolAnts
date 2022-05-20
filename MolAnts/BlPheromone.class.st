Class {
	#name : #BlPheromone,
	#superclass : #BlElement,
	#instVars : [
		'location',
		'intensity',
		'type',
		'needReDraw'
	],
	#category : #MolAnts
}

{ #category : #example }
BlPheromone class >> example [ 

| pheromoneView ground |

ground := BlElement new.

ground openInNewSpace extent: (MASimulationManager simulationWidth + 5)@(MASimulationManager simulationWidth + 5).
ground constraintsDo:[ :c | 
			c horizontal matchParent. 
			c vertical matchParent 
].
ground background: (Color fromHexString: 'c7baae').


pheromoneView := BlPheromone new.
pheromoneView intensity: 1.0.
pheromoneView location: 100@100.
ground addChild: pheromoneView.
]

{ #category : #drawing }
BlPheromone >> drawOnSpartaCanvas: aCanvas [	
	
	type = #explore ifTrue: [ 
	aCanvas figure
		path: (aCanvas shape circleAt: location radius: 2);
		background: Color blue;
		backgroundAlpha: intensity;
		draw.
	] ifFalse:[
	aCanvas figure
		path: (aCanvas shape circleAt: location radius: 2);
		background: Color cyan;
		backgroundAlpha: intensity;
		draw.
	].
]

{ #category : #drawing }
BlPheromone >> initialize [

	super initialize.
	
	type := #explore.
	location := 0@0.
	intensity := 0.
	needReDraw := true.
]

{ #category : #accessing }
BlPheromone >> intensity [

	^ intensity
]

{ #category : #accessing }
BlPheromone >> intensity: anObject [

	intensity := anObject
]

{ #category : #accessing }
BlPheromone >> location [

	^ location
]

{ #category : #accessing }
BlPheromone >> location: anObject [

	location := anObject
]

{ #category : #accessing }
BlPheromone >> needReDraw: aBool [

	needReDraw := aBool.
]

{ #category : #accessing }
BlPheromone >> onSessionChanged: aNewSession [
	"Is sent when a Session is changed, for example if the program is closed and re-opened.
	When this happens the external heap memory (FFI Objects) is no longer valid.
	If an element relies on an external memory it is a good place to trigger an update here"
	children ifNotNil:[
		self childrenDo: [ :eachChild | eachChild onSessionChanged: aNewSession ]
	].
]

{ #category : #drawing }
BlPheromone >> type: aSymbol [

	type := aSymbol.
]
