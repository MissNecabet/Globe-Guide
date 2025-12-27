import UIKit
import MapKit
import CoreLocation

enum MapType: Int, CaseIterable {
    case standard, satellite, hybrid

    var icon: String {
        switch self {
        case .standard: return "map"
        case .satellite: return "globe.americas.fill"
        case .hybrid: return "square.3.layers.3d"
        }
    }

    var mkMapType: MKMapType {
        switch self {
        case .standard: return .standard
        case .satellite: return .satellite
        case .hybrid: return .hybrid
        }
    }
}
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, UISearchBarDelegate {

    var mapView: MKMapView!
    let searchContainer = UIView()
    let searchBar = UISearchBar()
    let bottomButton = UIButton(type: .system)

    let favoritesButton = UIButton(type: .system)

      let controlContainer = UIStackView()
    var mapTypeButtons: [UIButton] = []
    let zoomInButton = UIButton(type: .system)
     let zoomOutButton = UIButton(type: .system)
    let vm = GoogleGeocodeViewModel()
      let randomVM = MapViewModel()
    let geocoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAll()
    }
  

    func setupMap() {
        mapView = MKMapView(frame: view.bounds)
        view.addSubview(mapView)
    }

    func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
        mapView.addGestureRecognizer(tap)
    }

    func setupSearchBar() {
        searchContainer.backgroundColor = .white
        searchContainer.layer.cornerRadius = 10
   
       
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchContainer)

        searchBar.placeholder = "Search country"
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.addSubview(searchBar)
    }

      func setupBottomButton() {
        bottomButton.setTitle("📌 Random Country", for: .normal)
        bottomButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        bottomButton.backgroundColor = UIColor.systemBlue
        bottomButton.setTitleColor(.white, for: .normal)
        bottomButton.layer.cornerRadius = 22
        bottomButton.layer.shadowColor = UIColor.systemBlue.cgColor
        bottomButton.layer.shadowOpacity = 0.4
        bottomButton.layer.shadowOffset = CGSize(width: 0, height: 6)
        bottomButton.layer.shadowRadius = 10
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.addTarget(self, action: #selector(randomTapped), for: .touchUpInside)
        view.addSubview(bottomButton)
    }

     func setupFavoritesButton() {
        favoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        favoritesButton.tintColor = .systemGreen
        favoritesButton.backgroundColor = .white
        favoritesButton.layer.cornerRadius = 22
        favoritesButton.translatesAutoresizingMaskIntoConstraints = false
        favoritesButton.addTarget(self, action: #selector(openFavorites), for: .touchUpInside)
        view.addSubview(favoritesButton)
    }

    func setupFloatingControls() {
        controlContainer.axis = .vertical
        controlContainer.spacing = 12
        controlContainer.alignment = .center
        controlContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        controlContainer.layer.cornerRadius = 18
        controlContainer.translatesAutoresizingMaskIntoConstraints = false
        controlContainer.isLayoutMarginsRelativeArrangement = true
        controlContainer.layoutMargins = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)

        MapType.allCases.forEach { type in
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: type.icon), for: .normal)
            button.tintColor = .white
            button.tag = type.rawValue
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(mapTypeTapped(_:)), for: .touchUpInside)

            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 40),
                button.heightAnchor.constraint(equalToConstant: 40)
            ])

            mapTypeButtons.append(button)
            controlContainer.addArrangedSubview(button)
        }

                // zoom in
                zoomInButton.setImage(UIImage(systemName: "plus"), for: .normal)
                zoomInButton.tintColor = .white
                zoomInButton.translatesAutoresizingMaskIntoConstraints = false
                zoomInButton.addTarget(self, action: #selector(handleZoomIn), for: .touchUpInside)

                //zoom out
                zoomOutButton.setImage(UIImage(systemName: "minus"), for: .normal)
                zoomOutButton.tintColor = .white
                zoomOutButton.translatesAutoresizingMaskIntoConstraints = false
                zoomOutButton.addTarget(self, action: #selector(handleZoomOut), for: .touchUpInside)

        NSLayoutConstraint.activate([
            zoomInButton.widthAnchor.constraint(equalToConstant: 40),
            zoomInButton.heightAnchor.constraint(equalToConstant: 40),
            zoomOutButton.widthAnchor.constraint(equalToConstant: 40),
            zoomOutButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        controlContainer.addArrangedSubview(zoomInButton)
        controlContainer.addArrangedSubview(zoomOutButton)

        view.addSubview(controlContainer)
    }


  
    func focusOnCountry(_ country: Country) {
        mapView.removeAnnotations(mapView.annotations)

        let region = MKCoordinateRegion(
            center: country.coordinate,
            latitudinalMeters: 2_000_000,
            longitudinalMeters: 2_000_000
        )
        mapView.setRegion(region, animated: true)

        let pin = MKPointAnnotation()
        pin.coordinate = country.coordinate
        pin.title = country.name
        mapView.addAnnotation(pin)

        presentBottomSheet(country: country)
    }

    @objc func mapTapped(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)

        let point = gesture.location(in: mapView)
        let coord = mapView.convert(point, toCoordinateFrom: mapView)

        let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let countryName = placemarks?.first?.country else { return }
            self?.loadCountry(name: countryName)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        searchBar.resignFirstResponder()
        loadCountry(name: text)
    }
    func loadCountry(name: String) {
        vm.loadGeocode(for: name) { [weak self] result in
            DispatchQueue.main.async {
                if case .success(let country) = result {
                    self?.focusOnCountry(country)
                }
            }
        }
    }

    @objc func randomTapped() {
        if let name = randomVM.selectRandomCountry() {
            loadCountry(name: name)
        }
    }

   

    @objc func mapTypeTapped(_ sender: UIButton) {
        if let type = MapType(rawValue: sender.tag) {
            mapView.mapType = type.mkMapType
        }
    }

    @objc func openFavorites() {
        let sheet = FavoritesBottomSheetViewController()
        sheet.onSelect = { [weak self] fav in
            let country = Country(
                name: fav.name ?? "",
                coordinate: CLLocationCoordinate2D(
                    latitude: fav.latitude,
                    longitude: fav.longitude
                ),
                places: []
            )
            self?.focusOnCountry(country)
        }

        sheet.modalPresentationStyle = .pageSheet
        if let c = sheet.presentationController as? UISheetPresentationController {
            c.detents = [.medium()]
            c.prefersGrabberVisible = true
        }
        present(sheet, animated: true)
    }

    @objc func handleZoomIn() {
        var region = mapView.region
        region.span.latitudeDelta /= 2
        region.span.longitudeDelta /= 2
        mapView.setRegion(region, animated: true)
    }

    @objc func handleZoomOut() {
        var region = mapView.region
        region.span.latitudeDelta *= 2
        region.span.longitudeDelta *= 2
        mapView.setRegion(region, animated: true)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            searchContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchContainer.heightAnchor.constraint(equalToConstant: 44),

            searchBar.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -8),
            searchBar.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),

            favoritesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favoritesButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            favoritesButton.widthAnchor.constraint(equalToConstant: 40),
            favoritesButton.heightAnchor.constraint(equalToConstant: 40),

            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            bottomButton.heightAnchor.constraint(equalToConstant: 56),

            controlContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            controlContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func presentBottomSheet(country: Country) {
        let sheet = CountryBottomSheet(country: country)
        sheet.modalPresentationStyle = .pageSheet
        if let c = sheet.presentationController as? UISheetPresentationController {
            c.detents = [.medium(), .large()]
            c.prefersGrabberVisible = true
        }
        present(sheet, animated: true)
    }

    func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupAll(){
        view.backgroundColor = .systemBackground

        setupMap()
        setupTapGesture()
        setupSearchBar()
        setupBottomButton()
        setupFavoritesButton()
        setupFloatingControls()
        setupConstraints()
        setupKeyboardDismiss()
    }
}
