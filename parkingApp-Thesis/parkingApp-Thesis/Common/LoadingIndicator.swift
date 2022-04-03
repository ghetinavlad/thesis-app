//
//  LoadingIndicator.swift
//  parkingApp-Thesis
//
//  Created by vladut on 3/19/22.
//

import Foundation
import SwiftUI

struct LoadingIndicator: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<LoadingIndicator>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .black
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<LoadingIndicator>) {
        
    }
}
