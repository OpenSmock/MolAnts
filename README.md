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
Object subclass: #MAAnt uses: MolComponentImpl + TMAAntsType.
Trait named: #TMAAntsType uses: MolComponentType.
TMASimulationManagerType class>>producedComponentEvents
  <componentContract>
  ↑{ TMAPositionEvents . TMAStateEvents }
TMASimulationManagerType class>>consumedComponentEvents
  <componentContract>
  ↑{ TMASimulationEvents }

BlElement subclass: #MAGround uses: MolComponentImpl + TMAGroundType.
Trait named: #TMAGroundType uses: MolComponentType.
TMASimulationManagerType class>>consumedComponentEvents
  <componentContract>
  ↑{ TMAPositionEvents . TMASimulationEvents }
  
MolAbstractComponentImpl subclass: #MASimulationManager uses: TMASimulationManagerType.
Trait named: #TMASimulationManagerType uses: MolComponentType.
TMASimulationManagerType class>>providedComponentServices
  <componentContract>
  ↑{ TMASimulationServices }
TMASimulationManagerType class>>producedComponentEvents
  <componentContract>
  ↑{ TMASimulationEvents }
TMASimulationManagerType class>>consumedComponentEvents
  <componentContract>
  ↑{ TMAStateEvents }

Trait named: #TMAPositionEvents	uses: MolComponentEvents.

Trait named: #TMASimulationEvents uses: MolComponentEvents.
  
Trait named: #TMAStateEvents uses: MolComponentEvents.

Trait named: #TMASimulationServices uses: MolComponentServices.
```
