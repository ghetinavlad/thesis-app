//
//  ContentView.swift
//  maps
//
//  Created by vladut on 2/23/22.
//

import SwiftUI

struct ContentView: View {
    @State private var location: CGPoint = CGPoint(x: 50, y: 50)
    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                self.location = value.location
            }
    }
    var body: some View {
            //MapView()
        SplashScreen(imageSize: CGSize(width: 64, height: 64)) {
            
        } titleView: {
            Text("Parking")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color.black)
            +
            Text("Finder")
                .font(.system(size: 23))
                .fontWeight(.heavy)
                .foregroundColor(Color.red)
        } logoView: {
            Image("icon_name")
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
