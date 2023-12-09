//
//  NewCharacterView.swift
//  MTWDM-Final-Personajes
//
//  Created by Manuel Rodríguez on 09/12/23.
//

import Foundation
import SwiftUI
import CoreData

struct NewCharacterView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var name: String = ""
    @State private var status: String = ""
    @State private var gender: String = ""
    @State private var image: String = "https://rickandmortyapi.com/api/character/avatar/9.jpeg"
    @State private var species: String = ""
    
    @Binding var isSheetPresented: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Character Details")) {
                    
                    AsyncImage(url: URL(string: image)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .empty:
                            ProgressView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(10)
                    
                    TextField("URL", text: Binding(
                        get: { image },
                        set: { image = $0 }
                    ))
                    TextField("Name", text: Binding(
                        get: { name },
                        set: { name = $0 }
                    ))
                    TextField("Status", text: Binding(
                        get: { status },
                        set: { status = $0 }
                    ))
                    TextField("Species", text: Binding(
                        get: { species },
                        set: { species = $0 }
                    ))
                    TextField("Gender", text: Binding(
                        get: { gender },
                        set: { gender = $0 }
                    ))
                }
                Section {
                    Button(action: {
                        addCharacter()
                        isSheetPresented = false
                    }){
                        Text("Save changes")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("New Character")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isSheetPresented = false
                    }
                }
            }
        }
    }
    private func addCharacter() {
        withAnimation {
            let personaje = Character(context: viewContext)
            personaje.id = UUID()
            personaje.name = name
            personaje.status = status
            personaje.species = species
            personaje.gender = gender
            personaje.image = image

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
