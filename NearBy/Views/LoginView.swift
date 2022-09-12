//
//  ContentView.swift
//  NearBy
//
//  Created by Marwan Sharaf on 9/11/22.
//

import SwiftUI
import Firebase
import FirebaseStorage


class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        
        super.init()
    }
}

struct LoginView: View {
    
    @State var LoginMode = true
    @State var email = ""
    @State var password = ""
    
    @State var shouldShowImagePicker = false
    
    var body: some View {
        NavigationView{
            ScrollView {
                
                VStack(spacing:16){
                    Picker(selection: $LoginMode, label: Text("Picker Text")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if !LoginMode {
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 256, height: 256)
                                        .cornerRadius(256)
                                    
                                    
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                }
                            }
                            
                        }
                            
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)

                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.black, style: StrokeStyle(lineWidth: 0.5)))
                    
                    
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(LoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                
                                .padding(.vertical,10)
                            Spacer()
                        }
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.25), radius: 5, x: 0.0, y: 0.0)
                    }
                    
                    Text(self.loginStatusMsg).foregroundColor(.red)
                }
                .padding()
                
            }
            .navigationTitle(LoginMode ? "Log In" : "Create Account")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
        }

    }
    
    @State var image: UIImage?
    
    private func handleAction() {
        if LoginMode {
            loginUser()
            //print("Should log into firebase with existing cred")
        } else {
            createNewAccount()
            //print("Register a new account inside of firebase auth and then sotre image in storage")
        }
    }
    
    @State var loginStatusMsg = ""
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to login user:", err)
                self.loginStatusMsg = "Failed to login user: \(err)"
                return
            }
            
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            
            self.loginStatusMsg = "Successfully logged in as user: \(result?.user.uid ?? "")"
        }
    }
        
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.loginStatusMsg = "Failed to create user: \(err)"
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            self.loginStatusMsg = "Successfully created user: \(result?.user.uid ?? "")"
            
            self.userImageToStorage()
        }
    }
    
    private func userImageToStorage() {
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            let ref = FirebaseManager.shared.storage.reference(withPath: uid)
            guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
            ref.putData(imageData, metadata: nil) { metadata, err in
                if let err = err {
                    self.loginStatusMsg = "Failed to push image to Storage: \(err)"
                    return
                }

                ref.downloadURL { url, err in
                    if let err = err {
                        self.loginStatusMsg = "Failed to retrieve downloadURL: \(err)"
                        return
                    }

                    self.loginStatusMsg = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                    
                    print("Successfully stored image with url: \(url?.absoluteString ?? "")")
                }
            }
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
