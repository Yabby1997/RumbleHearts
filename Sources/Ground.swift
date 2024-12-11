//
//  Ground.swift
//  RumbleHearts
//
//  Created by Seunghun on 12/11/24.
//

import SwiftGodot

@Godot
final class Ground: TileMapLayer {
    // MARK: - Dependencies
    
    @SceneTree(path: "../GroundObject") var groundObject: TileMapLayer?
    
    // MARK: - Lifecycle
    
    override func _useTileDataRuntimeUpdate(coords: Vector2i) -> Bool {
        groundObject?.getUsedCellsById(sourceId: 0).contains(coords) == true
    }
    
    override func _tileDataRuntimeUpdate(coords: Vector2i, tileData: TileData?) {
        tileData?.setNavigationPolygon(layerId: 0, navigationPolygon: nil)
    }
}
