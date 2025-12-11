import UIKit
import MapKit

class Map: UIView, MKMapViewDelegate {

    let MK = MKMapView() 

    override init(frame: CGRect) {
        super.init(frame: frame)
            
        setupMap()
        setupGestures()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupMap()
        setupGestures()
    }

    private func setupMap() {
        MK.frame = self.bounds
    
        MK.delegate = self
        MK.mapType = .hybrid
        self.addSubview(MK)
    }

    func setRegion(coordinate: CLLocationCoordinate2D, zoom: Double = 100) {
        let region = MKCoordinateRegion(center: coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom))
        MK.setRegion(region, animated: true)
    }

    func addMarker(coordinate: CLLocationCoordinate2D, title: String?) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        MK.addAnnotation(annotation)
    }
    
    // xeriteni el ile idare etmek
   
    private func setupGestures() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        self.addGestureRecognizer(pinchGesture)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGesture)
    }
   

    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        guard let view = gesture.view else { return }
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        gesture.setTranslation(.zero, in: self.superview)
    }
}

