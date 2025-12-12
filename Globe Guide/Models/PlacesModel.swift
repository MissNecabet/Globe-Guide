//
//  PlacesModel.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 13.12.25.
//


struct PlaceResponse: Codable {
    let results: [PlaceResult]
}
struct PlaceResult: Codable {
    let name: String
    let vicinity: String
    let photos: [PlacePhoto]?
}
struct PlacePhoto: Codable {
    let photo_reference: String
}
