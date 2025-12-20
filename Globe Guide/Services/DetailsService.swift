//
//  DetailsService.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 20.12.25.
//

import Foundation
import Alamofire

final class CountryService {

    static let shared = CountryService()
    private init() {}

    func fetchCountryInfo(countryName: String, completion: @escaping (Result<CountryInfo, Error>) -> Void) {

        let name = countryName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
      //  let urlString = "https://restcountries.com/v3.1/name/\(name)"

        NetworkManager.shared.request(APIEndpoint.countryDetail(countryName: name).url) { (result: Result<[DetailsResponse], Error>) in
            switch result {
            case .success(let countries):
                guard let country = countries.first else {
                    completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                    return
                }

                let currencies = country.currencies?.compactMapValues { $0.name }
                let info = CountryInfo(
                    currencies: currencies,
                    capital: country.capital,
                    region: country.region,
                    subregion: country.subregion,
                    languages: country.languages,
                    borders: country.borders,
                    flag: country.flag,
                    population: country.population,
                    flagAlt: country.flags?.alt
                )

                completion(.success(info))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
