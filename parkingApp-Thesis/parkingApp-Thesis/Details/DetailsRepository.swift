//
//  DetailsRepository.swift
//  maps
//
//  Created by vladut on 2/27/22.
//

import Foundation
import Network
import MapKit

protocol DetailsRepository {
    func getAddresses(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping ((Result<String, Error>) -> Void))
}

final class DetailsRepositoryImpl: DetailsRepository {
    func getAddresses(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping ((Result<String, Error>) -> Void)) {
        let geocoder = CLGeocoder.init()
        geocoder.reverseGeocodeLocation(CLLocation.init(latitude: latitude, longitude:longitude)) { (places, error) in
            guard error == nil else {
                completion(.failure(error!))
                        return
                    }
            if let place = places{
                let convertedAddress =  String(place[0].thoroughfare ?? "") + " " +  String(place[0].subThoroughfare ?? "")
                completion(.success(convertedAddress))
            }
            else {
                self.getAddresses(latitude: latitude, longitude: longitude, completion: completion)
            }
        }
    }
}

/*
 func pinALandPlaceMark(completion: @escaping (Result<MKAnnotation, Error>) -> Void) {
 let latitude: CLLocationDegrees =  generateRandomWorldLatitude()
 let longitude: CLLocationDegrees = generateRandomWorldLongitude()
 let randomCoordinate = CLLocation(latitude: latitude, longitude: longitude)
 geocoder.reverseGeocodeLocation(randomCoordinate) { (placemarks, error) in
 guard error == nil else {
 completion(nil,error)
 return error
 }
 if let placemark = placemarks.first, let _ = placemark.country {
 let randomPinLocation = MKPointAnnotation()
 randomPinLocation.coordinate = randomCoordinate.coordinate
 completionHandler(randomPinLocation,nil)
 } else {
 pinALandPlaceMark(completion:completion)
 }
 }
 }
 */
