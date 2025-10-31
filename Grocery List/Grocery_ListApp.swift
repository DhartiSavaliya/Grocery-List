//
//  Grocery_ListApp.swift
//  Grocery List
//
//  Created by Dharti Savaliya on 10/31/25.
//

import SwiftUI
import SwiftData

@main
struct Grocery_ListApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Item.self)
        }
    }
}
