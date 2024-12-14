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
    @SceneTree(path: "../../../UserInterface/Joystick") var joystick: Joystick?
    
    // MARK: - Properties
    
    @Export var speed: Double = 100
    private var vector: Vector2 = .zero
    
    // MARK: - Lifecycle
    
    override func _ready() {
        camera?.positionSmoothingSpeed = 3 + speed / 100
        setupJoystick()
    }
    
    override func _process(delta: Double) {
        let horizontal = Input.getAxis(negativeAction: "ui_left", positiveAction: "ui_right")
        let vertical = Input.getAxis(negativeAction: "ui_up", positiveAction: "ui_down")
        vector = Vector2(x: Float(horizontal), y: Float(vertical)).normalized()
    }
    
    override func _physicsProcess(delta: Double) {
        velocity = vector * speed
        guard velocity.length() > .zero else { return }
        emit(signal: Self.flagDidMove, globalPosition)
        moveAndSlide()
    }
    
    // MARK: - Setups
    
    private func setupJoystick() {
        guard let joystick else { return }
        joystick.joystickDidInteracted.connect(joystickDidInteracted)
    }
    
    private func joystickDidInteracted(vector: Vector2) {
        self.vector = vector
    }
}
