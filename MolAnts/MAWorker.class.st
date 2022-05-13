Class {
	#name : #MAWorker,
	#superclass : #MARole,
	#category : #'MolAnts-Model'
}

{ #category : #'life cycle' }
MAWorker >> componentInitialize [
	"here write the code corresponding to component initialisation phase"
	
	roleName := #worker
]

{ #category : #role }
MAWorker >> moveFrom: aPosition [

	roleName = #worker ifTrue: [ 
		^ aPosition + (((Random new next * 10 - 5) rounded) @ ((Random new next * 10 - 5) rounded)). 
	].
]
