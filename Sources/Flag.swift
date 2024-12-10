//
//  Flag.swift
//  RumbleHeartsSwift
//
//  Created by Seunghun on 12/10/24.
//

import SwiftGodot

@Godot
class Flag: CharacterBody2D {
    // MARK: - Signals
    
    #signal("flagDidMove", arguments: ["position": Vector2.self])
    var flagDidMove: GenericSignal<Vector2> { GenericSignal<Vector2> (target: self, signalName: "flagDidMove") }
    
    // MARK: -  Dependencies
    
    @SceneTree(path: "Camera2D") var camera: Camera2D?
    
    // MARK: - Properties
    
    @Export var speed: Double = 100
    
    // MARK: - Lifecycle
    
    override func _ready() {
        camera?.positionSmoothingSpeed = 3 + speed / 100
    }
    
    override func _physicsProcess(delta: Double) {
        let horizontal = Input.getAxis(negativeAction: "ui_left", positiveAction: "ui_right")
        let vertical = Input.getAxis(negativeAction: "ui_up", positiveAction: "ui_down")
        velocity = Vector2(x: Float(horizontal), y: Float(vertical)).normalized() * speed
        guard velocity.length() > .zero else { return }
        emit(signal: Self.flagDidMove, globalPosition)
        moveAndSlide()
    }
}
