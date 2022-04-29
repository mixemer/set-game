//
//  Set_GameApp.swift
//  Set Game
//
//  Created by mixemer on 3/23/22.
//

import SwiftUI

@main
struct Set_GameApp: App {
    let game = SetGameViewModal()
    
    var body: some Scene {
        WindowGroup {
            ContentView(game: game)
        }
    }
}
