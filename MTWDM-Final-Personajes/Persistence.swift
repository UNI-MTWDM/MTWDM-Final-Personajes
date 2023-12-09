//
//  Persistence.swift
//  MTWDM-Final-Personajes
//
//  Created by Manuel Rodríguez on 02/12/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let user = User(context: viewContext)
        user.userName = "fabian.munoz"
        user.password = "12345"
        user.name = "Fabián Muñoz"
        
        let user2 = User(context: viewContext)
        user2.userName = "jose.zuniga"
        user2.password = "12345"
        user2.name = "José Luis"
        
        let character3 = Character(context: viewContext)
        character3.name = "Rick Sanchez"
        character3.status =  "Alive"
        character3.species =  "Human"
        character3.gender =  "Male"
        character3.image =  "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
             
        let character4 = Character(context: viewContext)
        character4.id = UUID()
               character4.name =  "Morty Smith"
               character4.status =  "Alive"
               character4.species =  "Human"
               character4.gender =  "Male"
               character4.image =  "https://rickandmortyapi.com/api/character/avatar/2.jpeg"
             
        let character5 = Character(context: viewContext)
        character5.id = UUID()
               character5.name =  "Summer Smith"
               character5.status =  "Alive"
               character5.species =  "Human"
               character5.gender =  "Female"
               character5.image =  "https://rickandmortyapi.com/api/character/avatar/3.jpeg"

        let character6 = Character(context: viewContext)
        character6.id = UUID()
               character6.name =  "Beth Smith"
               character6.status =  "Alive"
               character6.species =  "Human"
               character6.gender =  "Female"
               character6.image =  "https://rickandmortyapi.com/api/character/avatar/4.jpeg"
             
        let character7 = Character(context: viewContext)
        character7.id = UUID()
               character7.name =  "Jerry Smith"
               character7.status =  "Alive"
               character7.species =  "Human"
               character7.gender =  "Male"
               character7.image =  "https://rickandmortyapi.com/api/character/avatar/5.jpeg"
             
        let character8 = Character(context: viewContext)
        character8.id = UUID()
               character8.name =  "Abadango Cluster Princess"
               character8.status =  "Alive"
               character8.species =  "Alien"
               character8.gender =  "Female"
               character8.image =  "https://rickandmortyapi.com/api/character/avatar/6.jpeg"
             
        let character9 = Character(context: viewContext)
        character9.id = UUID()
               character9.name =  "Abradolf Lincler"
               character9.status =  "unknown"
               character9.species =  "Human"
               character9.gender =  "Male"
               character9.image =  "https://rickandmortyapi.com/api/character/avatar/7.jpeg"
             
             
        let character10 = Character(context: viewContext)
        character10.id = UUID()
               character10.name =  "Adjudicator Rick"
               character10.status =  "Dead"
               character10.species =  "Human"
               character10.gender =  "Male"
               character10.image =  "https://rickandmortyapi.com/api/character/avatar/8.jpeg"
        
        
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MTWDM_Final_Personajes")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
