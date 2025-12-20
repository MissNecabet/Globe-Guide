//
//  GeocodeVM.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 20.12.25.
//

import Foundation
import CoreLocation
@MainActor
final class GoogleGeocodeViewModel: ObservableObject {
    @Published var coordinate: CLLocationCoordinate2D?
    @Published var formattedAddress: String?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = GoogleGeocodeService.shared

    func loadGeocode(for countryName: String,
                     completion: @escaping (Result<Country, Error>) -> Void) {
        isLoading = true
        errorMessage = nil

        service.geocodeCountry(countryName: countryName) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let geoResponse):
                guard let first = geoResponse.results.first else {
                    self.isLoading = false
                   // completion(.failure(MyError.noCoordinates))
                    return
                }

                let coord = CLLocationCoordinate2D(
                    latitude: first.geometry.location.lat,
                    longitude: first.geometry.location.lng
                )
                self.coordinate = coord
                self.formattedAddress = first.formatted_address
// PlaceService burda caqiirilir. ona gore vm yoxdu onun
                GooglePlacesService.shared.fetchPlaces(coordinate: coord) { places in
                    let country = Country(
                        name: first.formatted_address,
                        coordinate: coord,
                        places: places
                    )
                    self.isLoading = false
                    completion(.success(country))
                }

            case .failure(let error):
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                completion(.failure(error))
            }
        }
    }
}
