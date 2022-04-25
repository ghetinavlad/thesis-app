//
//  LoginView.swift
//  parkingApp-Thesis
//
//  Created by vladut on 4/14/22.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LoginView: View {
    @State var isActive = false
    
    var body: some View {
        VStack{
            VStack(spacing: 30) {
                Image("login-logo")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2.1)
                
                VStack(spacing: 5){
                    Text("Welcome")
                        .foregroundColor(Color.black)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                    Text("Please log in if you want to continue")
                        .foregroundColor(Color.black)
                        .font(.system(size: 16.5))
                        .fontWeight(.regular)
                }
            }
            Spacer()
            
            VStack {
                Button(action: {
                    handleLoginGmail()
                }, label:{
                    HStack {
                        Image("gmail")
                        Text("Sign in with Gmail")
                            .font(.system(size: 16.5))
                    }
                })
                .buttonStyle(GrowingButton9())
                
                LabelledDivider(label: "or")
                    .padding(.vertical, 10)
                
                Button(action: {
                    handleLoginGuest()
                }, label:{
                    HStack {
                        Image("guest")
                        Text("Sign in as guest")
                            .font(.system(size: 16.5))
                    }
                })
                .buttonStyle(GrowingButton9())
                NavigationLink(destination: MapView(), isActive: $isActive, label: {EmptyView() })
                
            }
            NavigationLink(destination: MapView(), isActive: $isActive, label: {EmptyView() })
            
        }
        .navigationBarHidden(true)
        .padding(.bottom, 50)
        .padding(.top, 60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
        
    }
    
    func handleLoginGmail() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) {
            [self] user, err in
            
            if let error = err {
                print(error.localizedDescription)
                return
            }
            
            guard
                let authentification = user?.authentication,
                let idToken = authentification.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentification.accessToken)
            
            Auth.auth().signIn(with: credential) { result, err in
                if let error = err {
                    print(error.localizedDescription)
                    return
                }
                
                guard let user = result?.user else {
                    return
                }
                UserDefaults.standard.set(user.displayName, forKey: "username")
                UserDefaults.standard.set(true, forKey: "isUser")
                UserDefaults.standard.set(user.email, forKey: "email")
                //print(user.email ?? "Success")
                //print(user.displayName ?? "Success")
                isActive = true
            }
            
        }
    }
    
    func handleLoginGuest() {
        UserDefaults.standard.set("Guest", forKey: "username")
        UserDefaults.standard.set(false, forKey: "isUser")
        UserDefaults.standard.set("guest@gmail.com", forKey: "email")
        isActive = true
    }
}

struct LabelledDivider: View {

    let label: String
    let horizontalPadding: CGFloat
    let color: Color

    init(label: String, horizontalPadding: CGFloat = 50, color: Color = .gray) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }

    var body: some View {
        HStack {
            line
            Text(label).foregroundColor(color)
            line
        }
    }

    var line: some View {
        VStack { Divider().background(color).frame(width: 40) }
    }
}

extension View {
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
