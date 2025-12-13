//
//  CountryBottomSheet.swift
//  Globe Guide
//
//  Created by Najabat Sofiyeva on 12.12.25.
//
import UIKit

class CountryBottomSheet: UIViewController {
    
    private let country: Country
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
    
    let placeView = UIView()
    let countryNameLabel = UILabel()
    
    
    init(country: Country) {
        self.country = country
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupContent()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
       
        
        contentView.axis = .vertical
        contentView.spacing = 10
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
        titleLabel.numberOfLines = 0
         contentView.addArrangedSubview(titleLabel)
        
        for place in country.places {
           
            placeView.heightAnchor.constraint(equalToConstant: 120).isActive = true
             placeView.backgroundColor = .secondarySystemBackground
              placeView.layer.cornerRadius = 10
            
           countryNameLabel.text = place.name
            countryNameLabel.font = .systemFont(ofSize: 16, weight: .medium)
            countryNameLabel.translatesAutoresizingMaskIntoConstraints = false
            placeView.addSubview(countryNameLabel)
            
            NSLayoutConstraint.activate([
                countryNameLabel.centerYAnchor.constraint(equalTo: placeView.centerYAnchor),
                countryNameLabel.leadingAnchor.constraint(equalTo: placeView.leadingAnchor, constant: 10)
            ])
            
            if let photoUrl = place.photoLink {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 2
                imageView.translatesAutoresizingMaskIntoConstraints = false
                placeView.addSubview(imageView)
                
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: placeView.topAnchor),
                    imageView.bottomAnchor.constraint(equalTo: placeView.bottomAnchor),
                    imageView.trailingAnchor.constraint(equalTo: placeView.trailingAnchor),
                    imageView.widthAnchor.constraint(equalToConstant: 120)
                ])
                
                let url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photoUrl)&key=AIzaSyBqcaWVneG5hCdXGRettKGOZzIqDNTftLk"
                if let url = URL(string: url) {
                    URLSession.shared.dataTask(with: url) { data, _, _ in
                        if let data = data {
                            DispatchQueue.main.async {
                                imageView.image = UIImage(data: data)
                            }
                        }
                    }.resume()
                }
            }
            
            contentView.addArrangedSubview(placeView)
        }
    }
}
