//
//  MapViewModel.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 02.12.25.
//

import Foundation
import MapKit

struct Country {
    let name: String
    let capital: String
    let coordinate: CLLocationCoordinate2D
    let flagUrl: String
}

class MapViewModel {
    var countries: [Country] = []
    var selectedCountry: Country?
    
    init() {
        loadCountries()
    }
    
    func loadCountries() {
        // Pulsuz API və ya lokal JSON istifadə edə bilərsən
        countries = [
            Country(name: "France", capital: "Paris", coordinate: CLLocationCoordinate2D(latitude: 46.2276, longitude: 2.2137), flagUrl: ""),
            Country(name: "Japan", capital: "Tokyo", coordinate: CLLocationCoordinate2D(latitude: 36.2048, longitude: 138.2529), flagUrl: "")
        ]
    }
    
    func selectRandomCountry() -> Country? {
        guard !countries.isEmpty else { return nil }
        let country = countries.randomElement()!
        selectedCountry = country
        return country
    }
    
    func searchCountry(name: String) -> Country? {
        if let country = countries.first(where: { $0.name.lowercased() == name.lowercased() }) {
            selectedCountry = country
            return country
        }
        return nil
    }
}
