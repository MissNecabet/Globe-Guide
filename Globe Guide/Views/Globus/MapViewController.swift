import UIKit
import MapKit

class MapViewController: UIViewController, UISearchBarDelegate {

    var customMap: Map!
       var searchBar: UISearchBar!
       let randomButton = UIButton(type: .system)

     
       let profileImageView = UIImageView()
       let profileLabel = UILabel()

       let viewModel = MapViewModel()

       override func viewDidLoad() {
           super.viewDidLoad()
           setupCustomMap()
           setupSearchBarElements()
           setupRandomButtonElements()
           setupProfileView()
           setupConstraintsForButtonAndSearch()
             
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
    func setupProfileView() {
        profileImageView.image = UIImage(systemName: "person.circle")
        profileImageView.tintColor = .white
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 25
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.isUserInteractionEnabled = true
        view.addSubview(profileImageView)

        profileLabel.text = "Guider"
        profileLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        profileLabel.textAlignment = .center
        profileLabel.textColor = .white
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLabel.isUserInteractionEnabled = true 
        view.addSubview(profileLabel)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(guiderTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        profileLabel.addGestureRecognizer(tapGesture)
    }

    @objc func guiderTapped() {
        let chatVC = ChatViewController()
        navigationController?.pushViewController(chatVC, animated: true)
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
          
            searchBar.leadingAnchor.constraint(equalTo: randomButton.trailingAnchor, constant: 5),
            profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),

            profileLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 4),
            profileLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor)
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
