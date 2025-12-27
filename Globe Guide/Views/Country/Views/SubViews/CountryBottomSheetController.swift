//
//  CountryBottomSheet.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 12.12.25.
//
import UIKit

class CountryPlacesViewController: UIViewController {

    private let country: Country
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()

    // yalnız şəkli olan place-lər
    private var imagePlaces: [Place] = []

    init(country: Country) {
        self.country = country
        self.imagePlaces = country.places.filter { $0.photoReference != nil }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAll()
    }
    private func setupAll(){
        view.backgroundColor = .systemBackground
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
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }


    private func setupContent() {

        let titleLabel = UILabel()
        titleLabel.text = country.name
        titleLabel.font = .boldSystemFont(ofSize: 22)
        contentView.addArrangedSubview(titleLabel)

        for (index, place) in imagePlaces.enumerated() {

            let card = UIView()
            card.backgroundColor = .secondarySystemBackground
            card.layer.cornerRadius = 12
            card.heightAnchor.constraint(equalToConstant: 100).isActive = true

            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.spacing = 12
            hStack.alignment = .center
            hStack.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview(hStack)

            NSLayoutConstraint.activate([
                hStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 10),
                hStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -10),
                hStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10),
                hStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -10)
            ])

          
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            imageView.isUserInteractionEnabled = true
            imageView.tag = index

            let ref = place.photoReference!
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

            let tap = UITapGestureRecognizer(target: self, action: #selector(openImage(_:)))
            imageView.addGestureRecognizer(tap)
            
            let nameLabel = UILabel()
            nameLabel.text = place.name
            nameLabel.numberOfLines = 2

            let heart = UIButton(type: .system)
            let isFav = FavoritesCoreDataManager.shared.isFavorite(place: place)

            heart.setImage(
                UIImage(systemName: isFav ? "heart.fill" : "heart"),
                for: .normal
            )
            heart.tintColor = isFav ? .systemGreen : .systemGray

            heart.addAction(UIAction { _ in
                let favNow = FavoritesCoreDataManager.shared.isFavorite(place: place)
                if favNow {
                    FavoritesCoreDataManager.shared.remove(place: place)
                } else {
                    FavoritesCoreDataManager.shared.add(place: place, country: self.country)
                }

                heart.setImage(
                    UIImage(systemName: favNow ? "heart" : "heart.fill"),
                    for: .normal
                )
                heart.tintColor = favNow ? .systemGray : .systemGreen
            }, for: .touchUpInside)

            hStack.addArrangedSubview(imageView)
            hStack.addArrangedSubview(nameLabel)

          
            let spacer = UIView()
            spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
            hStack.addArrangedSubview(spacer)

        heart.setContentHuggingPriority(.required, for: .horizontal)
            hStack.addArrangedSubview(heart)

            contentView.addArrangedSubview(card)
        }
    }

    @objc private func openImage(_ gesture: UITapGestureRecognizer) {
        guard let imageView = gesture.view else { return }

        let vc = PlaceImageViewerController(
            places: imagePlaces,
            country: country,
            startIndex: imageView.tag
        )
        present(vc, animated: true)
    }
}
