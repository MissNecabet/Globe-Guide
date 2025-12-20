//
//  GeocodeService.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 20.12.25.
//

import Foundation
import CoreLocation

final class GoogleGeocodeService {
    static let shared = GoogleGeocodeService()
    private init() {}
    
    func geocodeCountry(countryName: String, completion: @escaping (Result<GeocodeResponse, Error>) -> Void) {
        let name = countryName.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
       
        
        NetworkManager.shared.request(APIEndpoint.geocode(countryName: name).url, completion: completion)
    }
}
