//
//  CountryViewModel.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 20.12.25.
//

import Foundation
import Combine

@MainActor
final class CountryViewModel: ObservableObject {

    @Published var countryInfo: CountryInfo?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func getCountry(name: String) {
        isLoading = true
        errorMessage = nil

        CountryService.shared.fetchCountryInfo(countryName: name ) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
            case .success(let info):
                self.countryInfo = info
                
                print("/.......olke detallari uqurla alindi........./")
                print("\(String(describing: countryInfo))")
                
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("/.......bilinmeyen xeta bas verdi ureyini sixma........../")
            }
        }
    }
}
