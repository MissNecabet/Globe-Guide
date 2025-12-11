//
//  MapModel.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 11.12.25.
//

import Foundation
import CoreLocation

import Foundation
import CoreLocation

struct CountryAPIModel: Codable {
    let name: Name
    let capital: [String]?
    let latlng: [Double]
    let flags: Flag
    let region: String?
    let population: Int?
    let subregion: String?
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
    let population: Int
    let region: String
    let subregion: String
}
