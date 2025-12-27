//
//  PlaceImageViewerController.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 27.12.25.
//

import UIKit

final class PlaceImageViewerController: UIViewController {

    private let places: [Place]
    private let country: Country
    private var currentIndex: Int

    init(places: [Place], country: Country, startIndex: Int) {
        self.places = places
        self.country = country
        self.currentIndex = startIndex
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAll()
    }
    private func setupAll(){
        setupUI()
        loadCurrentPlace()
    }

    private func setupUI() {

        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
// bu view uzerine basanda dismiss edir.
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        backgroundView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(dismissSelf)
            )
        )

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        nameLabel.textAlignment = .center
        view.addSubview(nameLabel)

        let heartButton = UIButton(type: .system)
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        heartButton.tintColor = .systemGreen
        view.addSubview(heartButton)

       
        let leftButton = UIButton(type: .system)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.setTitle("<", for: .normal)
        leftButton.titleLabel?.font = .systemFont(ofSize: 36, weight: .bold)
        leftButton.tintColor = .white
        view.addSubview(leftButton)

        let rightButton = UIButton(type: .system)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.setTitle(">", for: .normal)
        rightButton.titleLabel?.font = .systemFont(ofSize: 36, weight: .bold)
        rightButton.tintColor = .white
        view.addSubview(rightButton)

        let googleButton = UIButton(type: .system)
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        googleButton.setTitle("Search on Google", for: .normal)
        googleButton.tintColor = .white
        view.addSubview(googleButton)

   
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

            leftButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),

            rightButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            heartButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 12),
            heartButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12),
            heartButton.widthAnchor.constraint(equalToConstant: 32),
            heartButton.heightAnchor.constraint(equalToConstant: 32),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            googleButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        leftButton.addTarget(self, action: #selector(prevButton), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(nextButton), for: .touchUpInside)
        heartButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(searchOnGoogle), for: .touchUpInside)

        self.imageView = imageView
        self.nameLabel = nameLabel
        self.heartButton = heartButton
    }

    private weak var imageView: UIImageView?
    private weak var nameLabel: UILabel?
    private weak var heartButton: UIButton?

    private func loadCurrentPlace() {
        let place = places[currentIndex]
        nameLabel?.text = place.name
    
        let isFav = FavoritesCoreDataManager.shared.isFavorite(place: place)
        heartButton?.setImage(
            UIImage(systemName: isFav ? "heart.fill" : "heart"),
            for: .normal
        )

        if let ref = place.photoReference {
            let urlString =
            "https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photoreference=\(ref)&key=AIzaSyBqcaWVneG5hCdXGRettKGOZzIqDNTftLk"
    
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data {
                        DispatchQueue.main.async {
                            self.imageView?.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
        }
    }

    @objc private func prevButton() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        loadCurrentPlace()
    }

    @objc private func nextButton() {
        guard currentIndex < places.count - 1 else { return }
        currentIndex += 1
        loadCurrentPlace()
    }

    @objc private func toggleFavorite() {
        let place = places[currentIndex]
        let isFav = FavoritesCoreDataManager.shared.isFavorite(place: place)

        if isFav {
            FavoritesCoreDataManager.shared.remove(place: place)
        } else {
            FavoritesCoreDataManager.shared.add(place: place, country: country)
        }
        loadCurrentPlace()
    }


    @objc private func searchOnGoogle() {
        let query = places[currentIndex].name
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        UIApplication.shared.open(URL(string: "https://www.google.com/search?q=\(query)")!)
    }

    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
}

//private func loadCurrentPlace() {
//    let place = places[currentIndex]
//    nameLabel.text = place.name
//
//    let isFav = FavoritesCoreDataManager.shared.isFavorite(place: place)
//    heartButton.setImage(
//        UIImage(systemName: isFav ? "heart.fill" : "heart"),
//        for: .normal
//    )
//
//    imageView.image = UIImage(systemName: "photo")
//
//    if let ref = place.photoReference {
//        let urlString =
//        "https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photoreference=\(ref)&key=AIzaSyBqcaWVneG5hCdXGRettKGOZzIqDNTftLk"
//
//        if let url = URL(string: urlString) {
//            URLSession.shared.dataTask(with: url) { data, _, _ in
//                if let data {
//                    DispatchQueue.main.async {
//                        self.imageView.image = UIImage(data: data)
//                    }
//                }
//            }.resume()
//        }
//    }
//}
//
//// MARK: - Actions
//@objc private func prevImage() {
//    guard currentIndex > 0 else { return }
//    currentIndex -= 1
//    loadCurrentPlace()
//}
//
//@objc private func nextImage() {
//    guard currentIndex < places.count - 1 else { return }
//    currentIndex += 1
//    loadCurrentPlace()
//}
//
//@objc private func toggleFavorite() {
//    let place = places[currentIndex]
//    let isFav = FavoritesCoreDataManager.shared.isFavorite(place: place)
//
//    if isFav {
//        FavoritesCoreDataManager.shared.remove(place: place)
//    } else {
//        FavoritesCoreDataManager.shared.add(place: place, country: country)
//    }
//    loadCurrentPlace()
//}
//
//@objc private func searchOnGoogle() {
//    let place = places[currentIndex]
//    let query = place.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//    if let url = URL(string: "https://www.google.com/search?q=\(query)") {
//        UIApplication.shared.open(url)
//    }
//}
//
//@objc private func dismissSelf() {
//    dismiss(animated: true)
//}
//}
