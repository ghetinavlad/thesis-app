//
//  DetailsXViewModel.swift
//  parkingApp-Thesis
//
//  Created by vladut on 4/3/22.
//

import Foundation
import FirebaseStorage

class DetailsXViewModel: ObservableObject {
    
    @Published var imageURL = ""
    
    init() {
        
    }
    
    func loadImageFromFirebase(id: String) {
            let storage = Storage.storage().reference(withPath: id)
            storage.downloadURL { (url, error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                    return
                }
                DispatchQueue.main.async {
                    print("Download success")
                    self.imageURL = "\(url!)"
                }
            }
        }
}
