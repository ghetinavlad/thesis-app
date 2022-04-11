//
//  SplashScreen.swift
//  maps
//
//  Created by vladut on 3/5/22.
//

import SwiftUI

struct SplashScreen<Content: View, Title: View, Logo: View>: View {
    
    var contentView: Content
    var titleView: Title
    var logoView: Logo
    var imageSize: CGSize
    
    init(imageSize: CGSize, @ViewBuilder contentView: @escaping () -> Content,
         @ViewBuilder titleView: @escaping () -> Title,
         @ViewBuilder logoView: @escaping () -> Logo) {
        self.contentView = contentView()
        self.titleView = titleView()
        self.logoView = logoView()
        self.imageSize = imageSize
    }
    
    @State var textAnimation = false
    @State var imageAnimation = false
    @State var endAnimation = false
    @State var isActive = false
    var hasLoggedInBefore = UserDefaults.standard.bool(forKey: "hasLoggedIn")
    
    @Namespace var animation
    
    var body: some View {
        NavigationView{
        VStack {
            if endAnimation {
                logoView
              
                    .frame(width: imageSize.width, height: imageSize.height)
            }
            titleView
                .offset(y: textAnimation ? 0 : 110)
            NavigationLink(destination: self.hasLoggedInBefore ? AnyView(MapView()) : AnyView(IntroView()), isActive: $isActive, label: {EmptyView() })
        }
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 248 / 255, green: 245 / 255, blue: 237 / 255).ignoresSafeArea())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring()) {
                    textAnimation.toggle()
                }
                withAnimation(Animation.interactiveSpring(response: 0.8, dampingFraction: 1, blendDuration: 1)) {
                    endAnimation.toggle()
                    }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                isActive = true
                }   
            }
                }
            }
        }
    }

/*struct SplashScreen_Previews: PreviewProvider {
 static var previews: some View {
 SplashScreen()
 }
 }*/
