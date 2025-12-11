//
//  CountryService.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 11.12.25.
//

import Foundation
import CoreLocation

class CountryService {
    
    func getAllCountries(completion: @escaping (Result<[Country], Error>) -> Void) {
        let url = "https://restcountries.com/v3.1/all?fields=name,capital,latlng,flags,region,population"
        
        NetworkManager.shared.request(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let apiCountries = try JSONDecoder().decode([CountryAPIModel].self, from: data)
                    let countries = apiCountries.compactMap { api -> Country? in
                        guard api.latlng.count == 2 else { return nil }
                        return Country(
                            name: api.name.common,
                            capital: api.capital?.first ?? "No capital",
                            coordinate: CLLocationCoordinate2D(latitude: api.latlng[0], longitude: api.latlng[1]),
                            flagUrl: api.flags.png,
                            population: api.population ?? 0,
                            region: api.region ?? "Unknown",
                            subregion: api.subregion ?? "Unknown"
                        )
                    }
                    completion(.success(countries))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
