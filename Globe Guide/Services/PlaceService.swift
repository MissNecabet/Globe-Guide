//
//  Places.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 20.12.25.
//
import CoreLocation

final class GooglePlacesService {

    static let shared = GooglePlacesService()
    private init() {}

    func fetchPlaces(coordinate: CLLocationCoordinate2D,
                     completion: @escaping ([Place]) -> Void) {

        NetworkManager.shared.request(APIEndpoint.places(coordinate: coordinate).url) { (result: Result<PlaceResponse, Error>) in
            switch result {
            case .success(let response):
                let places = response.results.map {
                    Place(name: $0.name,
                          photoReference: $0.photos?.first?.photo_reference,
                          address: $0.vicinity)
                }
                completion(places)
            case .failure(_):
                completion([])
            }
        }
    }
}
