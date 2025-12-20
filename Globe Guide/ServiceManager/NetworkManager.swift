
import Foundation
import Alamofire
import CoreLocation

enum APIEndpoint {
    case places(coordinate: CLLocationCoordinate2D)  // Turistlik yerlər
    case geocode(countryName: String)                 // Ölkə koordinatları
    case countryDetail(countryName: String)          // Ölkə məlumatı
   
    var url: String {
        switch self {
            
        case .places(let coordinate):
            let apiKey = "AIzaSyBqcaWVneG5hCdXGRettKGOZzIqDNTftLk"
            return "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=50000&type=tourist_attraction&key=\(apiKey)"
            
        case .geocode(let countryName):
            let apiKey = "AIzaSyBqcaWVneG5hCdXGRettKGOZzIqDNTftLk"
            let cleanedName = countryName
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .capitalized
            return "https://maps.googleapis.com/maps/api/geocode/json?address=\(cleanedName)&key=\(apiKey)"
            
        case .countryDetail(let countryName):
            let name = countryName
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .capitalized
            return "https://restcountries.com/v3.1/name/\(name)"
        }
    }
}


final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
 
    
    func request<T: Decodable>(_ url: String,
                               completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
