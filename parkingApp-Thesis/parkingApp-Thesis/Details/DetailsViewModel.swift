//
//  DetailsViewModel.swift
//  maps
//
//  Created by vladut on 2/27/22.
//

import Foundation
import Combine
import MapKit

class DetailsViewModel: ObservableObject {
    
    private var repository: DetailsRepository
    @Published var addressFromCoordinates: String = ""
    @Published var isLoading = false
    
    init(repository: DetailsRepository = DetailsRepositoryImpl()) {
        self.repository = repository
    }
    
    func getAddressesFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        isLoading = true
        repository.getAddresses(latitude: latitude, longitude: longitude) { result in
            switch result {
                case .success(let address):
                    self.addressFromCoordinates = address
                    self.isLoading = false
                    print(address)
                case .failure(let error):
                    print("An error occurred: \(error)")
                    self.isLoading = false
            }
        }
    }
}
