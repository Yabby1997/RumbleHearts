//
//  CharacterStateMachine.swift
//  RumbleHeartsSwift
//
//  Created by Seunghun on 12/10/24.
//

import SwiftGodot

// MARK: - State and State Machine

class CharacterStateMachine {
    private var currentState: CharacterState?
    
    func changeState(_ newState: CharacterState) {
        currentState?.exit()
        currentState = newState
        newState.enter()
    }
    
    func update(delta: Double) {
        currentState?.update(delta: delta)
    }
}

protocol CharacterState {
    func enter()
    func update(delta: Double)
    func exit()
}

// MARK: - Idle

class IdleState: CharacterState {
    weak var character: Character?
    
    init(character: Character?) {
        self.character = character
    }
    
    func enter() {
        character?.animatedSprite?.play(name: "idle")
    }
    
    func update(delta: Double) {
        guard character?.targetPosition != nil else { return }
        character?.stateMachine.changeState(MovingState(character: character))
    }
    
    func exit() {}
}

// MARK: - Moving

class MovingState: CharacterState {
    weak var character: Character?
    
    init(character: Character?) {
        self.character = character
    }
    
    func enter() {
        character?.animatedSprite?.play(name: "move")
    }
    
    func update(delta: Double) {
        guard let character,
              let navigationAgent = character.navigationAgent,
              let targetPosition = character.targetPosition else {
            character?.stateMachine.changeState(IdleState(character: character))
            character?.targetPosition = nil
            return
        }
        
        character.animatedSprite?.flipH = targetPosition.x < character.globalPosition.x
        navigationAgent.targetPosition = targetPosition
          
        if navigationAgent.isNavigationFinished() {
            character.stateMachine.changeState(IdleState(character: character))
            character.targetPosition = nil
            return
        }
        
        let direction = character.globalPosition.directionTo(navigationAgent.getNextPathPosition())
        navigationAgent.velocity = direction * (character.isDragging ? character.speed : character.flagSpeed)
    }
    
    func exit() {}
}
