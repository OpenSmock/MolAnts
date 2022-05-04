# MolAnts

Ants version Molecule

## Getting Started

### Installing Molecule

Pharo 8, Pharo 9 and Pharo 10 : 

(https://github.com/OpenSmock/MolAnts)

### Prerequisites

MolAnts require Molecule (https://github.com/OpenSmock/Molecule) for the component aspect and Bloc (https://github.com/pharo-graphics/Bloc) for the visual aspect.
  
## Overview of the Components, Types, Services and Events organisation with Molecule
![MolAnts](https://user-images.githubusercontent.com/64481702/166678508-2be44458-5095-4cd3-b772-d144f2707f6c.png)

## MolAnts : an example usage of Molecule

### Declaration of Type traits

```smallTalk
Trait named: #TMAAntsType uses: MolComponentType.

Trait named: #TMAGroundType uses: MolComponentType.
  
Trait named: #TMASimulationManagerType uses: MolComponentType.
```
### Declaration of Components

```smallTalk
Object subclass: #MAAnt uses: MolComponentImpl + TMAAntsType.

BlElement subclass: #MAGround uses: MolComponentImpl + TMAGroundType.
  
MolAbstractComponentImpl subclass: #MASimulationManager uses: TMASimulationManagerType.
```
### Declaration of Event traits

```smallTalk
Trait named: #TMAPositionEvents	uses: MolComponentEvents.

Trait named: #TMASimulationEvents uses: MolComponentEvents.
  
Trait named: #TMAStateEvents uses: MolComponentEvents.
```
### Declaration of Service traits

```smallTalk
Trait named: #TMASimulationServices uses: MolComponentServices.
```
