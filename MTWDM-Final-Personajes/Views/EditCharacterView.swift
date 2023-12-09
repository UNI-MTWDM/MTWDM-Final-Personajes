//
//  EditCharacterView.swift
//  MTWDM-Final-Personajes
//
//  Created by Manuel Rodríguez on 09/12/23.
//

import Foundation
import SwiftUI
import CoreData

struct EditCharacterView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var id: UUID?
    @Binding var name: String?
    @Binding var gender: String?
    @Binding var status: String?
    @Binding var species: String?
    @Binding var image: String?
    
    @Binding var isSheetPresented: Bool
    @Binding var personaje : Character
    
    init(id: Binding<UUID?>,
         name : Binding<String?>,
         gender: Binding<String?>,
         status: Binding<String?>,
         species: Binding<String?>,
         image: Binding<String?>, personaje : Binding<Character>, isSheetPresented:Binding<Bool>) {
        
        self._personaje = personaje
        self._isSheetPresented = isSheetPresented
        
        self._id = id
        self._name = name
        self._gender = gender
        self._status = status
        self._species = species
        self._image = image
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Character Details")) {
                    
                    if let url = image {
                        AsyncImage(url: URL(string: url)) { phase in
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
                    }
                    TextField("URL", text: Binding(
                        get: { image ?? "" },
                        set: { image = $0 }
                    ))
                    TextField("Name", text: Binding(
                        get: { name ?? "" },
                        set: { name = $0 }
                    ))
                    TextField("Status", text: Binding(
                        get: { status ?? "" },
                        set: { status = $0 }
                    ))
                    TextField("Species", text: Binding(
                        get: { species ?? "" },
                        set: { species = $0 }
                    ))
                    TextField("Gender", text: Binding(
                        get: { gender ?? "" },
                        set: { gender = $0 }
                    ))
                }
                Section {
                    Button(action: {
                        //character = editedCharacter
                        
                        saveChanges()
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
            .navigationTitle("Edit Character")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isSheetPresented = false
                    }
                }
            }
        }
    }
    private func saveChanges() {
        do {
            personaje.name = name
            personaje.status = status
            personaje.gender = gender
            personaje.species = species
            personaje.image = image
            
            try viewContext.save()
        } catch {
            // Handle the error appropriately
            print("Error saving changes: \(error)")
        }
    }
}
