//
//  MTWDM_Final_PersonajesApp.swift
//  MTWDM-Final-Personajes
//
//  Created by Manuel Rodríguez on 02/12/23.
//

import SwiftUI

@main
struct MTWDM_Final_PersonajesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
