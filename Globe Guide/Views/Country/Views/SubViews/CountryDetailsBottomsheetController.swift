//
//  Untitled.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 27.12.25.
//

import UIKit
import Combine

final class CountryDetailsViewController: UIViewController {

    private let countryName: String
    private let vm = CountryViewModel()
    private var cancellables = Set<AnyCancellable>()

    private let stack = UIStackView()

    init(countryName: String) {
        self.countryName = countryName
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAll()
      
    }
    private func setupAll(){
        setupUI()
        bind()
        vm.getCountry(name: countryName)
    }

    private func setupUI() {
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func bind() {
        vm.$countryInfo
            .compactMap { $0 }
            .sink { [weak self] info in
                self?.render(info)
            }
            .store(in: &cancellables)
    }

    private func render(_ info: CountryInfo) {

        func add(_ title: String, _ value: String?) {
            guard let value else { return }
            let label = UILabel()
            label.numberOfLines = 0
            label.text = "\(title): \(value)"
            stack.addArrangedSubview(label)
        }

        add("Capital", info.capital?.joined(separator: ", "))
        add("Region", info.region)
        add("Subregion", info.subregion)
        add("Population", info.population.map(String.init))
        add("Languages", info.languages?.values.joined(separator: ", "))
        add("Currencies", info.currencies?.values.joined(separator: ", "))
    }
}
