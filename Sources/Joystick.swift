//
//  Joystick.swift
//  RumbleHearts
//
//  Created by Seunghun on 12/14/24.
//

import Foundation
import SwiftGodot

@Godot
final class Joystick: Control {
    // MARK: - Signals
    
    #signal("joystickDidStartInteracting")
    var joystickDidStartInteracting: SignalWithNoArguments { .init("joystickDidStartInteracting") }
    
    #signal("joystickDidInteracted", arguments: ["vector": Vector2.self])
    var joystickDidInteracted: GenericSignal<Vector2> { GenericSignal<Vector2> (target: self, signalName: "joystickDidInteracted") }
    
    #signal("joystickDidStopInteracting")
    var joystickDidStopInteracting: SignalWithNoArguments { .init("joystickDidStopInteracting") }
    
    // MARK: - Dependencies
    
    @SceneTree(path: "Ring") var ring: Sprite2D?
    @SceneTree(path: "Knob") var knob: Sprite2D?
    
    // MARK: - Properties
    
    private var isInteracting = false
    private var radius: Float? {
        guard let ring, let width = ring.texture?.getSize().x else { return nil }
        return width * ring.globalScale.x / 2.0
    }
    
    // MARK: - Lifecycles
    
    override func _process(delta: Double) {
        guard let ring, let knob, let radius else { return }
        let angle = ring.globalPosition.angleToPoint(to: getGlobalMousePosition())
        
        if isInteracting {
            if getGlobalPosition().distanceTo(getGlobalMousePosition()) < Double(radius) {
                knob.globalPosition = getGlobalMousePosition()
            } else {
                knob.globalPosition = .init(
                    x: ring.globalPosition.x + cos(Float(angle)) * radius,
                    y: ring.globalPosition.y + sin(Float(angle)) * radius
                )
            }
            emit(signal: Self.joystickDidInteracted, Vector2(x: cos(Float(angle)), y: sin(Float(angle))))
        } else {
            knob.globalPosition = knob.globalPosition.slerp(to: ring.globalPosition, weight: delta * 50)
        }
    }
    
    override func _unhandledInput(event: InputEvent?) {
        guard let ring, let knob,
              let event, let radius, let mouseEvent = event as? InputEventMouseButton, mouseEvent.buttonIndex == MouseButton.left else {
            return
        }
    
        if event.isPressed(), getGlobalPosition().distanceTo(mouseEvent.globalPosition) < Double(radius) {
            let angle = ring.globalPosition.angleToPoint(to: getGlobalMousePosition())
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
