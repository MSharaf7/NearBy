//
//  ContentView.swift
//  NearBy
//
//  Created by Marwan Sharaf on 9/11/22.
//

import SwiftUI

struct LoginView: View {
    
    @State var LoginMode = true
    @State var email = ""
    @State var password = ""
    
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
                         
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        
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
                }
                .padding()
                
            }
            .navigationTitle(LoginMode ? "Log In" : "Create Account")
        }
    }

    private func handleAction() {
        if LoginMode {
            print("Should log into firebase with existing cred")
        } else {
            print("Register a new account inside of firebase auth and then sotre image in storage")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
