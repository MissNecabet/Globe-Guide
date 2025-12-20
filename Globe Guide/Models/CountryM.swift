//
//  CountryModel.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 12.12.25.
//
import Foundation
import CoreLocation
// view da lazim olan model
struct Country {
    let name: String
    let coordinate: CLLocationCoordinate2D
    let places: [Place]
}
struct Place {
    let name: String
    let photoReference: String?
    let address: String
}
