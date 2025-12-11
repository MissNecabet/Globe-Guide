//
//  NetworkManager.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 11.12.25.
//

import Alamofire
import Foundation
import CoreLocation
import Alamofire
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func request(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        AF.request(url).validate().responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
