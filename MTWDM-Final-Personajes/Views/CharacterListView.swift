//
//  CharacterListView.swift
//  MTWDM-TodoList-CoreData
//
//  Created by Fabian Muñoz Tavares on 08/12/23.
//

import Foundation
import SwiftUI

struct CharacterListView : View {
    @State var name: String
    @State private var isSheetPresented = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Character.id, ascending: true)], animation: .default)
    private var characters: FetchedResults<Character>

    var body: some View {
        NavigationView {
            VStack {
                List{
                    ForEach(characters) { item in
                        //item -> $0 ||
                        NavigationLink(destination: 
                                        CharacterDetailView(id: item.id, name: item.name, gender: item.gender, status: item.status, species: item.species, image: item.image, character: item)
                        ) {
                            CharacterCardView(character: item)
                        }
                    }.onDelete(perform: { indexSet in
                        deleteItems(offsets: indexSet)
                    })
                }.toolbar {
                   ToolbarItem(placement: .navigationBarTrailing){
                        EditButton()
                    }
                    ToolbarItem{
                        Button("Add"){
                            isSheetPresented.toggle()
                        }.sheet(isPresented: $isSheetPresented){
                            // Modal despliega form para nuevo personaje
                            NewCharacterView(isSheetPresented: $isSheetPresented)
                        }
                    }
                }.navigationTitle("Characters")
                    .navigationBarBackButtonHidden(true) //Oculta el botón back hacia login
            }
        } //NavigationView
    } //body
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { characters[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
} //struct view

//Row view
struct CharacterCardView: View {
    let character: Character

    @State private var name: String?
    @State private var gender: String?
    @State private var image: String?

    init(character: Character) {
        self.character = character
        
        self._name = State(initialValue: character.name)
        self._gender = State(initialValue: character.gender)
        self._image = State(initialValue: character.image)
    }
    
    var body: some View {
        HStack {
            
            if let url = URL(string: character.image ?? ""){
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            VStack(alignment: .leading) {
                Text("\(character.name ?? "")")
                    .font(.subheadline)
                Text("Gender: \(character.gender ?? "")")
                    .font(.subheadline)
            }
            .padding(.leading, 10)
        }
    }
}

//Detail view





#Preview {
    CharacterListView(name: "Admin").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
