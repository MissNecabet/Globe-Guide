//
//  MapModel.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 11.12.25.
//

import Foundation
import CoreLocation


struct CountryAPIModel: Codable {
    let name: Name
    let capital: [String]?
    let latlng: [Double]
    let flags: Flag
}

struct Name: Codable {
    let common: String
}

struct Flag: Codable {
    let png: String
}


struct Country {
    let name: String
    let capital: String
    let coordinate: CLLocationCoordinate2D
    let flagUrl: String
}
