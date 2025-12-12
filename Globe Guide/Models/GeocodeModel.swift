//
//  CountryDetails.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 12.12.25.
//


//GeoCode api servisden gelen data modeli

struct GeocodeResponse: Codable {
    let results: [GeocodeResult]
}
struct GeocodeResult: Codable {
    let formatted_address: String
    let geometry: Geometry
}
struct Geometry: Codable {
    let location: Location
}
struct Location: Codable {
    let lat: Double
    let lng: Double
}
