import UIKit
import MapKit

class MapViewController: UIViewController, UISearchBarDelegate {

    var customMap: Map!
    var searchBar: UISearchBar!
    let randomButton = UIButton(type: .system)

    let viewModel = MapViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomMap()
           setupSearchBarElements()
           setupRandomButtonElements()
           setupConstraintsForButtonAndSearch()
           
        // search bar set edilidkden sonra false teyin edilir , eks halda error
           randomButton.isEnabled = false
           searchBar.isUserInteractionEnabled = false
           
         
           loadCountries()
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
        randomButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14 )
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
            randomButton.widthAnchor.constraint(equalToConstant: 70),
        
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
          
            searchBar.leadingAnchor.constraint(equalTo: randomButton.trailingAnchor, constant: 5)
        ])
    }
    
   
    @objc func randomButtonTapped() {
        if let country = viewModel.selectRandomCountry() {
           
            customMap.setRegion(coordinate: country.coordinate, zoom: 5)
            customMap.addMarker(coordinate: country.coordinate, title: country.name)
          
            print("Selected random country:", country.name)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }

        if let country = viewModel.searchCountry(name: text) {
            customMap.setRegion(coordinate: country.coordinate, zoom: 5)
            customMap.addMarker(coordinate: country.coordinate, title: country.name)

            print("Found country:", country.name)
        } else {
            print("Country not found")
        }

        // Keyboardu baqlayir
        searchBar.resignFirstResponder()
    }

}
extension MapViewController {
    func loadCountries() {
       

        viewModel.loadCountries { success in
               if success {
                   DispatchQueue.main.async {
                       self.randomButton.isEnabled = true
                       self.searchBar.isUserInteractionEnabled = true
                   }
               }
           }
    }
}
