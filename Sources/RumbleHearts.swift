//
//  RumbleHearts.swift
//  RumbleHearts
//
//  Created by Seunghun on 12/9/24.
//

import SwiftGodot
import GDExtension

#initSwiftExtension(
    cdecl: "swift_entry_point",
    types: [
        World.self,
        Ground.self,
        Party.self,
        Flag.self,
        Character.self,
        Joystick.self,
    ]
)
