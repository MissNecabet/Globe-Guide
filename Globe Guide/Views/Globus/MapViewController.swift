import UIKit
import MapKit

class MapViewController: UIViewController, UISearchBarDelegate {
    
    var mapView: MKMapView!
    var searchBar: UISearchBar!
    let randomButton = UIButton(type: .system)
    
    let profileImageView = UIImageView()
    let profileLabel = UILabel()
    
    let viewModel = MapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupMap()
        setupSearchBar()
        setupRandomButton()
        setupProfileView()
        setupConstraints()
        
        randomButton.isEnabled = true
        searchBar.isUserInteractionEnabled = true
    }
    
    func setupMap() {
        mapView = MKMapView(frame: view.bounds)
        view.addSubview(mapView)
    }
    
    func addMarker(coordinate: CLLocationCoordinate2D, title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search for a country"
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.layer.cornerRadius = 18
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
    }
    
    func setupRandomButton() {
        randomButton.setTitle("Random", for: .normal)
        randomButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        randomButton.backgroundColor = .systemBlue
        randomButton.setTitleColor(.white, for: .normal)
        randomButton.layer.cornerRadius = 10
        randomButton.addTarget(self, action: #selector(randomTapped), for: .touchUpInside)
        randomButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(randomButton)
    }
    
    func setupProfileView() {
        profileImageView.image = UIImage(systemName: "person.circle")
        profileImageView.tintColor = .white
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.isUserInteractionEnabled = true
        view.addSubview(profileImageView)
        
        profileLabel.text = "Guider"
        profileLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        profileLabel.textColor = .white
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLabel.isUserInteractionEnabled = true
        view.addSubview(profileLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            randomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            randomButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            randomButton.heightAnchor.constraint(equalToConstant: 40),
            randomButton.widthAnchor.constraint(equalToConstant: 70),
            
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: randomButton.trailingAnchor, constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            profileLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 4),
            profileLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor)
        ])
    }
    
    @objc func randomTapped() {
        if let countryName = viewModel.selectRandomCountry() {
            fetchAndShowCountry(name: countryName)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        searchBar.resignFirstResponder()
        fetchAndShowCountry(name: text)
    }
    
    private func fetchAndShowCountry(name: String) {
        GoogleAPIService.shared.geocodeAPIService(countryName: name) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let country):
                    let region = MKCoordinateRegion(center: country.coordinate, latitudinalMeters: 2000000, longitudinalMeters: 2000000)
                    self.mapView.setRegion(region, animated: true)
                    self.addMarker(coordinate: country.coordinate, title: country.name)
                    self.presentBottomSheet(country: country)
                case .failure(let error):
                    print("Error fetching country------", error.localizedDescription)
                }
            }
        }
    }
    
    func presentBottomSheet(country: Country) {
        let sheet = CountryBottomSheet(country: country)
        sheet.modalPresentationStyle = .pageSheet
        if let sheetController = sheet.presentationController as? UISheetPresentationController {
            sheetController.detents = [.medium(), .large()]
            sheetController.prefersScrollingExpandsWhenScrolledToEdge = true
            sheetController.prefersGrabberVisible = true
        }
        present(sheet, animated: true)
    }
}
