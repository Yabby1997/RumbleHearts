//
//  Party.swift
//  RumbleHeartsSwift
//
//  Created by Seunghun on 12/10/24.
//

import SwiftGodot

@Godot
class Party: Node2D {
    // MARK: - Dependencies
    
    @SceneTree(path: "Flag") var flag: Flag?
    
    // MARK: - Properties
    
    private let characterPackedScene: PackedScene? = GD.load(path: "res://Scenes/Character.tscn")
    var characters: [Character] = []
    
    // MARK: - Lifecycle
    
    override func _ready() {
        flag?.flagDidMove.connect(onFlagDidMove)
        for _ in 0..<3 {
            guard let character = characterPackedScene?.instantiate() as? Character else { continue }
            character.speed = Double.random(in: 100...140)
            character.characterDidChangeSpeed.connect(onCharacterDidChangeSpeed)
            addChild(node: character)
            characters.append(character)
        }
        updateFlagSpeed()
    }
    
    // MARK: - Private methods
    
    private func updateFlagSpeed() {
        let flagSpeed = characters.compactMap { $0.speed }.min() ?? 100
        flag?.speed = flagSpeed
        characters.forEach { $0.flagSpeed = flagSpeed }
    }
    
    // MARK: - Signal callbakcs
    
    func onCharacterDidChangeSpeed(newSpeed: Double) {
        updateFlagSpeed()
    }
    
    func onFlagDidMove(to position: Vector2) {
        characters.enumerated().forEach { $1.move(position: Vector2(x: position.x + Float(15 * $0), y: position.y)) }
    }
}
