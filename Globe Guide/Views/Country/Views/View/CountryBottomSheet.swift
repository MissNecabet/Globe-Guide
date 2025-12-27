//
//  Untitled.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 27.12.25.
//
enum CountryTab {
    case places
    case details
}

import UIKit

final class CountryBottomSheet: UIViewController {

    private var selectedTab: CountryTab = .places {
        didSet { switchTab() }
    }

    private let country: Country
    private let tabStack = UIStackView()
    private let placesButton = UIButton(type: .system)
    private let detailsButton = UIButton(type: .system)
    private let containerView = UIView()

    private lazy var placesVC = CountryPlacesViewController(country: country)
    private lazy var detailsVC = CountryDetailsViewController(countryName: country.name)

    init(country: Country) {
        self.country = country
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAll()
    }
    private func setupAll(){
        view.backgroundColor = .systemBackground
        setupTabs()
        setupContainer()
        switchTab()
    }
    private func setupTabs() {

        tabStack.axis = .horizontal
        tabStack.spacing = 24
        tabStack.translatesAutoresizingMaskIntoConstraints = false

        placesButton.setTitle("Places", for: .normal)
        detailsButton.setTitle("Details", for: .normal)

        placesButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        detailsButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)

        placesButton.addTarget(self, action: #selector(openPlaces), for: .touchUpInside)
        detailsButton.addTarget(self, action: #selector(openDetails), for: .touchUpInside)

        tabStack.addArrangedSubview(placesButton)
        tabStack.addArrangedSubview(detailsButton)

        view.addSubview(tabStack)

        NSLayoutConstraint.activate([
            tabStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            tabStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupContainer() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: tabStack.bottomAnchor, constant: 12),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func switchTab() {
// bootom sheet acilanda 2 tab var
        placesButton.tintColor = selectedTab == .places ? .label : .secondaryLabel
        detailsButton.tintColor = selectedTab == .details ? .label : .secondaryLabel

        children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }

        let vc = selectedTab == .places ? placesVC : detailsVC

        addChild(vc)
        vc.view.frame = containerView.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }

    @objc private func openPlaces() {
        selectedTab = .places
    }

    @objc private func openDetails() {
        selectedTab = .details
    }
}
