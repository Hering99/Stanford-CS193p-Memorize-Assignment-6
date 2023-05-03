//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Lukas Hering on 02.06.22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    //copied
    //@StateObject var themeStore = ThemeStore(named: "default")
    
    var body: some Scene {
        WindowGroup {
            ThemeSelector().environmentObject(ThemeStore(named: "default"))
        }
    }
}
