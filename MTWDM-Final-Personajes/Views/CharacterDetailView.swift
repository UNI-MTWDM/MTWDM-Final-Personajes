//
//  CharacterDetailView.swift
//  MTWDM-Final-Personajes
//
//  Created by Manuel Rodríguez on 09/12/23.
//

import Foundation
import SwiftUI


struct CharacterDetailView: View {
    @State var character: Character
    @State var isSheetPresented = false
    
    @State private var id: UUID?
    @State private var name: String?
    @State private var gender: String?
    @State private var status: String?
    @State private var species: String?
    @State private var image: String?

    init(
        id: UUID?,
        name: String?,
        gender: String?,
        status: String?,
        species: String?,
        image: String?,
          character: Character)
    {
        self._character = State(initialValue: character)
        self.isSheetPresented = false
        
        self._id = State(initialValue: id)
        self._name = State(initialValue: name)
        self._gender = State(initialValue: gender)
        self._status = State(initialValue: status)
        self._species = State(initialValue: species)
        self._image = State(initialValue: image)
    }
    var body: some View {
        VStack(alignment: .leading) {
            
            if let url = URL(string: character.image ?? ""){
                AsyncImage(url: url) { phase in
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
            VStack(alignment: .leading, spacing: 10) {
                Text("Name: \(name ?? "")")
                    .font(.subheadline)
                Text("Genero: \(gender ?? "")")
                    .font(.subheadline)
                
                Text("Status: \(character.status ?? "")")
                    .font(.subheadline)
                Text("Species: \(character.species ?? "")")
                    .font(.subheadline)
                Text("Gender: \(character.gender ?? "")")
                    .font(.subheadline)
            }
            .padding()
            
            Spacer()
        } //VStack
        .navigationTitle(character.name ?? "")
        .toolbar {
            ToolbarItem{
                Button("Edit") {
                    isSheetPresented.toggle()
                }
                .sheet(isPresented: $isSheetPresented) {
                    // Modal despliega form para edición
                    EditCharacterView(id: $id, name: $name, gender: $gender, status: $status, species: $species, image: $image,
                                      personaje: $character, isSheetPresented: $isSheetPresented)
                }
            }
        }//toolbar
    }
}
