//
//  Joystick.swift
//  RumbleHearts
//
//  Created by Seunghun on 12/14/24.
//

import Foundation
import SwiftGodot

@Godot
final class Joystick: Area2D {
    // MARK: - Signals
    
    #signal("joystickDidStartInteracting")
    var joystickDidStartInteracting: SignalWithNoArguments { .init("joystickDidStartInteracting") }
    
    #signal("joystickDidInteracted", arguments: ["vector": Vector2.self])
    var joystickDidInteracted: GenericSignal<Vector2> { GenericSignal<Vector2> (target: self, signalName: "joystickDidInteracted") }
    
    #signal("joystickDidStopInteracting")
    var joystickDidStopInteracting: SignalWithNoArguments { .init("joystickDidStopInteracting") }
    
    // MARK: - Dependencies
    
    @SceneTree(path: "ControllableArea") var controllableArea: CollisionShape2D?
    @SceneTree(path: "Knob") var knob: Sprite2D?
    
    // MARK: - Properties
    
    private var isInteracting = false
    private var radius: Double? {
        guard let controllableArea, let circle = controllableArea.shape as? CircleShape2D else { return nil }
        return circle.radius * Double(controllableArea.globalScale.x)
    }
    
    // MARK: - Lifecycles
    
    override func _process(delta: Double) {
        guard let controllableArea, let knob, let radius else { return }
        let angle = controllableArea.globalPosition.angleToPoint(to: getGlobalMousePosition())
        
        if isInteracting {
            if globalPosition.distanceTo(getGlobalMousePosition()) < radius {
                knob.globalPosition = getGlobalMousePosition()
            } else {
                knob.globalPosition = .init(
                    x: controllableArea.globalPosition.x + cos(Float(angle)) * Float(radius),
                    y: controllableArea.globalPosition.y + sin(Float(angle)) * Float(radius)
                )
            }
            emit(signal: Self.joystickDidInteracted, Vector2(x: cos(Float(angle)), y: sin(Float(angle))))
        } else {
            knob.globalPosition = knob.globalPosition.slerp(to: controllableArea.globalPosition, weight: delta * 50)
        }
    }
    
    override func _unhandledInput(event: InputEvent?) {
        guard let controllableArea, let knob,
              let event, let radius, let mouseEvent = event as? InputEventMouseButton, mouseEvent.buttonIndex == MouseButton.left else {
            return
        }
    
        if event.isPressed(), globalPosition.distanceTo(mouseEvent.globalPosition) < radius {
            let angle = controllableArea.globalPosition.angleToPoint(to: getGlobalMousePosition())
            isInteracting = true
            knob.globalPosition = mouseEvent.globalPosition
            emit(signal: Self.joystickDidStartInteracting)
            emit(signal: Self.joystickDidInteracted, Vector2(x: cos(Float(angle)), y: sin(Float(angle))))
        } else if !event.isPressed(), isInteracting {
            isInteracting = false
            emit(signal: Self.joystickDidStopInteracting)
        }
    }
}
