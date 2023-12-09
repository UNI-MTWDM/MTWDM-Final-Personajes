//
//  LoginView.swift
//  MTWDM-TodoList-CoreData
//
//  Created by Fabian Muñoz Tavares on 03/12/23.
//

import Foundation
import SwiftUI
import CoreData

struct LoginView: View {
    @State private var userName = "fabian.munoz"
    @State private var password = "12345"
    @State private var isAlertPresented = false
    @State private var isLoginSuccessful = false
    @State private var name: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: User.entity(), sortDescriptors: [])
    private var users: FetchedResults<User>
    
    var body: some View {
        NavigationView{
            
            ZStack {
                if let url = URL(string: "https://m.media-amazon.com/images/I/91MteSqsrJL._AC_UF894,1000_QL80_.jpg")
                {
                    RemoteImageView(url: url)
                        .padding(.bottom, 20)
                }
                
                VStack {
                    Spacer()
                    
                    TextField("Username", text: $userName)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .foregroundColor(.white)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .foregroundColor(.white)
                    
                    
                    //Navega a lista de personajes si las credenciales son correctas
                    NavigationLink(destination: CharacterListView(name: name), isActive: $isLoginSuccessful, label: {
                        Button(action: {
                            if validateUser(userName: userName, password: password){
                                print("Login succeeded")
                                isLoginSuccessful = true
                            }
                            else {
                                print("Invalid credentials")
                                isAlertPresented = true
                            }
                        }) {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        } //Button
                        .padding(.horizontal, 20)
                        .alert(isPresented: $isAlertPresented) {
                            Alert(title: Text("Invalid Credentials"),
                                  message: Text("Please check your username and password."),
                                  dismissButton: .default(Text("OK")))
                        }
                    } //label
                    ) //NavigationLink
                    
                    Spacer()
                }//VStack
            }//ZStack
        }
        .padding()
    }
    private func validateUser(userName: String, password: String) -> Bool {
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userName == %@ AND password == %@", userName, password)
        
        do {
            let filteredUsers = try viewContext.fetch(fetchRequest)
            
            //Obtención del nombre de usuario
            if let user = filteredUsers.first{
                self.name = user.name ?? ""
            }
            return !filteredUsers.isEmpty
        } catch {
            print("Error validating user: \(error)")
            return false
        }
    }
}

struct RemoteImageView: View {
    let url: URL

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView() // Placeholder while loading
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

            case .failure:
                Image(systemName: "photo") // Placeholder for failure
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.red)
            @unknown default:
                EmptyView()
            }
        }
    }
}


#Preview {
    LoginView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
