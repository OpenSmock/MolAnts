Class {
	#name : #BlPheromone,
	#superclass : #BlElement,
	#instVars : [
		'location',
		'intensity'
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

	aCanvas figure
		path: (aCanvas shape circleAt: location radius: 2);
		background: Color blue;
		backgroundAlpha: intensity;
		draw
]

{ #category : #drawing }
BlPheromone >> initialize [

	super initialize.
	location := 0@0.
	intensity := 0.
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