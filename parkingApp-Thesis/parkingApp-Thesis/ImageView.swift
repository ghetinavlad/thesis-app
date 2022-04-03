//
//  ImageView.swift
//  parkingApp-Thesis
//
//  Created by vladut on 4/3/22.
//

import SwiftUI
import Combine
import FirebaseStorage

struct ImageView: View {
    @ObservedObject var imageLoader:DataLoader
    @State var image:UIImage = UIImage()
    
    init(imageURL: String) {
        imageLoader = DataLoader(urlString:imageURL)
    }

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .frame(width: UIScreen.main.bounds.width / 1.1, height: UIScreen.main.bounds.height / 3.5)
                .cornerRadius(10)
                .shadow(color: Color.darkShadow, radius: 3, x: 3, y: 3)
                .shadow(color: Color.lightShadow, radius: 3, x: -3, y: -2)
        }.onReceive(imageLoader.didChange) { data in
            self.image = UIImage(data: data) ?? UIImage()
        }
    }
}

class DataLoader: ObservableObject {
    @Published var didChange = PassthroughSubject<Data, Never>()
    @Published var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        getDataFromURL(urlString: urlString)
    }
    
    func getDataFromURL(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }.resume()
    }
}
