//
//  iPostApp.swift
//  iPost
//
//  Created by Albin Hashani on 9/26/23.
//

import SwiftUI

@main
struct iPostApp: App {
    
    @StateObject private var dataController = DataController()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
