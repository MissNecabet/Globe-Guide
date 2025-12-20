import UIKit
import MapKit

class Map: UIView {

    let mapView = MKMapView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMap()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupMap()
    }

    private func setupMap() {
        mapView.frame = bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(mapView)
    }

    func addMarker(coordinate: CLLocationCoordinate2D, title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }

    func setRegion(coordinate: CLLocationCoordinate2D, zoom: Double) {
        let span = MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom)
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: true)
    }
}
