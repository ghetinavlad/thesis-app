//
//  IntroView.swift
//  parkingApp-Thesis
//
//  Created by vladut on 3/19/22.
//

import SwiftUI

struct IntroView: View {
    @State var username = ""
    @State var isActive = false
    private let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            Image("username")
                .padding(.bottom, 20)
            Text("Welcome")
                .font(.system(size: 20))
                .foregroundColor(Color.black)
                .fontWeight(.bold)
            Text("Enter your new username")
                .foregroundColor(Color.black)
                .font(.system(size: 17))
            TextField("", text: $username)
                .placeholder(when: username.isEmpty) {
                    Text("Username").foregroundColor(.gray)
                }
                .foregroundColor(Color.black)
                .frame(width: UIScreen.main.bounds.width / 1.7, height: 20)
                .padding()
                .background(
                    ZStack {
                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .foregroundColor(.white)
                            .blur(radius: 4)
                            .offset(x: 8, y: 8)
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                Color.white
                            )
                            .padding(1)
                            .blur(radius: 2)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 10, x: 5, y: 5)
                .shadow(color: Color.white, radius: 10, x: -5, y: -5)
                .padding(.top, 30)
            Spacer()
                .frame(height: screenHeight / 3)
            Button(action:
                    {
                UserDefaults.standard.set(true, forKey: "hasLoggedIn")
                isActive = true
            }
                   , label: {
                Text("Save & Continue")
                    .foregroundColor(Color.black)
                    .fontWeight(.medium )
                    .padding()
                    .padding(.horizontal, 10)
            })
                .buttonStyle(GrowingButton2())
            NavigationLink(destination: MapView(), isActive: $isActive, label: {EmptyView() })
        }
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 248 / 255, green: 245 / 255, blue: 237 / 255).ignoresSafeArea())
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
