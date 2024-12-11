//
//  World.swift
//  RumbleHearts
//
//  Created by Seunghun on 12/11/24.
//

import SwiftGodot

@Godot
final class World: Node2D {
    // MARK: - Signals
    
    #signal("didEnterWorld", arguments: ["width": Double.self, "height": Double.self])
    var didEnterWorld: GenericSignal<Double, Double> { GenericSignal<Double, Double> (target: self, signalName: "didEnterWorld") }
    
    // MARK: - Properties
     
    @Export var width: Double = 400
    @Export var height: Double = 700
    
    // MARK: - Lifecycle
    
    override func _ready() {
        emit(signal: Self.didEnterWorld, width, height)
        if let partyScene = GD.load(path: "res://Scenes/Party.tscn") as? PackedScene,
           let party = partyScene.instantiate() {
            addChild(node: party)
        }
    }
}
