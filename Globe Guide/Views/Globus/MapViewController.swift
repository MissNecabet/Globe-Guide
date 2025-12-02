import UIKit
import MapKit

class MapViewController: UIViewController {

    var customMap: Map!
    var searchBar: UISearchBar!
    let randomButton = UIButton(type: .system)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCustomMap()
        setupSearchBar()
        setupRandomButton()
    }

    func setupCustomMap() {
        customMap = Map(frame: view.bounds)
       // customMap.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(customMap)

      
        let paris = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
        customMap.addMarker(coordinate: paris, title: "Paris")

        customMap.setRegion(coordinate: paris, zoom: 5)
    }
}


extension MapViewController:UISearchBarDelegate{
   func setupSearchBar() {
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

        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: randomButton.trailingAnchor, constant: 10),
               searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
               searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
               searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

}

extension MapViewController{
    func setupRandomButton() {
      
        randomButton.setTitle("Random", for: .normal)
        randomButton.backgroundColor = .systemBlue
        randomButton.setTitleColor(.white, for: .normal)
        randomButton.layer.cornerRadius = 25
        randomButton.addTarget(self, action: #selector(randomButtonTapped), for: .touchUpInside)
        
        
        randomButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(randomButton)
        
        NSLayoutConstraint.activate([
            randomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            randomButton.trailingAnchor.constraint(equalTo:searchBar.leadingAnchor),
            randomButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            randomButton.widthAnchor.constraint(equalToConstant: 100),
            randomButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc func randomButtonTapped() {
        print("Random button tapped")
      
    }

}
