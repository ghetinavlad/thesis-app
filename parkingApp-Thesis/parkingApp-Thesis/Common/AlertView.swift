//
//  AlertView.swift
//  parkingApp-Thesis
//
//  Created by vladut on 4/9/22.
//

import SwiftUI

extension View {
    func alertLink <Destination: View>(isPresented: Binding<Bool>, destination: @escaping () -> Destination) -> some View {
        self.modifier(AlertViewModifier(isPresented: isPresented, destination: destination))
    }
}

struct AlertViewModifier<Destination>: ViewModifier where Destination: View {
    @Binding var isPresented: Bool
    var destination: () -> Destination
    
    func body(content: Self.Content) -> some View {
        AlertTransitionLink(isPresented: self.$isPresented, destination: self.destination, content: { content })
    }
}

struct AlertTransitionLink<Content, Destination>: View where Content: View, Destination: View {
    @Binding var isPresented: Bool
    var content: () -> Content
    var destination: () -> Destination
    init(isPresented: Binding<Bool>, @ViewBuilder destination: @escaping () -> Destination, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.destination = destination
        self._isPresented = isPresented
    }
    
    var body: some View {
        ZStack {
            self.content()
                .blur(radius: self.isPresented ? 20 : 0, opaque: false)
            if self.isPresented {
                self.destination()
            }
        }
    }
}
