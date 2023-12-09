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
                        NavigationLink(destination: CharacterDetailView(character: item)) {
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
                Text(character.name ?? "")
                    .font(.headline)
                Text("Gender: \(character.gender ?? "")")
                    .font(.subheadline)
            }
            .padding(.leading, 10)
        }
    }
}

//Detail view
struct CharacterDetailView: View {
    @State var character: Character
    //@Binding var character: Character
    @State var isSheetPresented = false
    @State private var refreshFlag = false
    //@State var contador : Int
    
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
                    EditCharacterView(character: $character, isSheetPresented: $isSheetPresented)
                }
            }
        }//toolbar
    }
}

struct EditCharacterView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var editedCharacter: Character
    @State private var urlString: String = ""
    
    @Binding var character: Character
    @Binding var isSheetPresented: Bool
    
    init(character: Binding<Character>, isSheetPresented:Binding<Bool>) {
        self._isSheetPresented = isSheetPresented
        self._character = character
        self._editedCharacter = State(initialValue: character.wrappedValue)
        
        if let url = editedCharacter.image {
            self._urlString = State(initialValue: url)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Character Details")) {
                    
                    AsyncImage(url: URL(string: urlString)) { phase in
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
                        get: { urlString },
                        set: { urlString = $0 }
                    ))
                    TextField("Name", text: Binding(
                        get: { editedCharacter.name ?? "" },
                        set: { editedCharacter.name = $0 }
                    ))
                    TextField("Status", text: Binding(
                        get: { editedCharacter.status ?? "" },
                        set: { editedCharacter.status = $0 }
                    ))
                    TextField("Species", text: Binding(
                        get: { editedCharacter.species ?? "" },
                        set: { editedCharacter.species = $0 }
                    ))
                    TextField("Gender", text: Binding(
                        get: { editedCharacter.gender ?? "" },
                        set: { editedCharacter.gender = $0 }
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
            try viewContext.save()
        } catch {
            // Handle the error appropriately
            print("Error saving changes: \(error)")
        }
    }
}

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

#Preview {
    CharacterListView(name: "Admin").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
