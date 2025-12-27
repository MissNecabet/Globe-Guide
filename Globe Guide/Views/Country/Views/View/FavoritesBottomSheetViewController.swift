//
//  FavoritesBottomSheetViewController.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 27.12.25.
//

import UIKit

class FavoritesBottomSheetViewController: UIViewController {

    var favorites: [FavoriteCountryEntity] = []
    var onSelect: ((FavoriteCountryEntity) -> Void)?

    private let scrollView = UIScrollView()
    private let contentView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAll()
    }
    private func setupAll(){
        view.backgroundColor = .systemBackground

        favorites = FavoritesCoreDataManager.shared.fetchFavorites()
        setupScrollView()
        setupContent()
    }
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentView.axis = .vertical
        contentView.spacing = 12
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -12),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 12),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -12),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -24)
        ])
    }

    private func setupContent() {

        for item in favorites {

            let row = UIView()
            row.backgroundColor = .secondarySystemBackground
            row.layer.cornerRadius = 12
            row.heightAnchor.constraint(equalToConstant: 80).isActive = true

            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.spacing = 12
            hStack.translatesAutoresizingMaskIntoConstraints = false
            row.addSubview(hStack)

            NSLayoutConstraint.activate([
                hStack.topAnchor.constraint(equalTo: row.topAnchor, constant: 10),
                hStack.bottomAnchor.constraint(equalTo: row.bottomAnchor, constant: -10),
                hStack.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 10),
                hStack.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -10)
            ])

            let imageView = UIImageView()
            imageView.layer.cornerRadius = 8
            imageView.clipsToBounds = true
            imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true

            if let ref = item.imageUrl {
                let urlString =
                "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(ref)&key=AIzaSyBqcaWVneG5hCdXGRettKGOZzIqDNTftLk"

                if let url = URL(string: urlString) {
                    URLSession.shared.dataTask(with: url) { data, _, _ in
                        if let data = data {
                            DispatchQueue.main.async {
                                imageView.image = UIImage(data: data)
                            }
                        }
                    }.resume()
                }
            } else {
                imageView.image = UIImage(systemName: "photo")
            }

            let label = UILabel()
            label.text = item.name
            label.numberOfLines = 2

            hStack.addArrangedSubview(imageView)
            hStack.addArrangedSubview(label)

            let tap = UITapGestureRecognizer(target: self, action: #selector(selectFavorite(_:)))
            row.addGestureRecognizer(tap)
            row.tag = favorites.firstIndex(of: item) ?? 0

            contentView.addArrangedSubview(row)
        }
    }

    @objc private func selectFavorite(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        let item = favorites[view.tag]
        onSelect?(item)
        dismiss(animated: true)
    }
}
