//
//  CountryModel.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 12.12.25.
//
import Foundation
import CoreLocation

struct Country {
    let name: String
    let coordinate: CLLocationCoordinate2D
    let places: [Place]
}
struct Place {
    let name: String
    let photoLink: String?
    let address: String
}
