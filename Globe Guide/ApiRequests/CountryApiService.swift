import Foundation
import CoreLocation
import Alamofire

class GoogleAPIService {
    static let shared = GoogleAPIService()
    private init() {}
    
    private let apiKey = "AIzaSyBqcaWVneG5hCdXGRettKGOZzIqDNTftLk"
    
    func geocodeAPIService(countryName: String, completion: @escaping (Result<Country, Error>) -> Void) {
        let countryName = countryName.trimmingCharacters(in: .whitespacesAndNewlines)
                        .lowercased()
        
        let url = "https://maps.googleapis.com/maps/api/geocode/json?address=\(countryName)&key=\(apiKey)"
        
        AF.request(url)
          .responseDecodable(of: GeocodeResponse.self) { response in
            switch response.result {
            case .success(let geocodeResponse):
                // rresultun bos olub olmamasini yoxluyur
                guard let result = geocodeResponse.results.first else { return }
                let coordinate = CLLocationCoordinate2D(latitude: result.geometry.location.lat,longitude: result.geometry.location.lng)
                
                // Turistlik yerləri alırıq
                self.fetchPlaces(coordinate: coordinate) { places in
                    let country = Country(name: result.formatted_address,
                                          coordinate: coordinate,
                                          places: places)
                    completion(.success(country))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPlaces(coordinate: CLLocationCoordinate2D, completion: @escaping ([Place]) -> Void) {
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=50000&type=tourist_attraction&key=\(apiKey)"
        
        AF.request(url).responseDecodable(of: PlaceResponse.self) { response in
            switch response.result {
            case .success(let placeResponse):
                let places = placeResponse.results.map {
                    Place(name: $0.name,
                          photoLink: $0.photos?.first?.photo_reference,
                          address: $0.vicinity)
                }
                completion(places)
            case .failure(_):
                completion([])
            }
        }
    }
}


