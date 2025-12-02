import UIKit
import MapKit

class MapViewController: UIViewController, UISearchBarDelegate {

    var customMap: Map!
    var searchBar: UISearchBar!
    let randomButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCustomMap()
        setupSearchBarElements()
        setupRandomButtonElements()
        setupConstraintsForButtonAndSearch()
    }

   
    func setupCustomMap() {
        customMap = Map(frame: view.bounds)
        view.addSubview(customMap)
        let paris = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
        customMap.addMarker(coordinate: paris, title: "Paris")
        customMap.setRegion(coordinate: paris, zoom: 5)
    }

    func setupSearchBarElements() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search for a country"
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.layer.cornerRadius = 18
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.layer.borderWidth = 0
        searchBar.searchTextField.leftView?.tintColor = .gray
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
    }
 
    func setupRandomButtonElements() {
        randomButton.setTitle("Random", for: .normal)
        randomButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        randomButton.backgroundColor = .systemBlue
        randomButton.setTitleColor(.white, for: .normal)
        randomButton.layer.cornerRadius = 10
        randomButton.addTarget(self, action: #selector(randomButtonTapped), for: .touchUpInside)
        randomButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(randomButton)
    }

    func setupConstraintsForButtonAndSearch() {
        NSLayoutConstraint.activate([
            randomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            randomButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            randomButton.heightAnchor.constraint(equalToConstant: 40),
        
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
          
            searchBar.leadingAnchor.constraint(equalTo: randomButton.trailingAnchor, constant: 5)
        ])
    }

    @objc func randomButtonTapped() {
        print("Random button tapped")
    }
}

