//
//  MapController.swift
//  hackathon
//
//
import UIKit
import MapKit
import CoreLocation

final class MapController: UIViewController {

    @IBOutlet weak private var mapView: MKMapView!

    private var location = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    //MARK: setupUI
    private func setupUI() {
        makeShadowBehindMap()
        mapView.delegate = self

        setLocation(latitude: 44.5414503, longitude: 38.075067, zoom: 2500) //mark on tolstiy mis
        //setLocation(latitude: 44.635395, longitude: 38.000555, zoom: 3500)  //mark on vinogradniy

    }

    //MARK: showLocation
    private func setLocation(latitude: CGFloat, longitude: CGFloat, zoom: Double) {
        DispatchQueue.global().async { [self] in
            if CLLocationManager.locationServicesEnabled() {
                location.requestWhenInUseAuthorization()
                location.requestAlwaysAuthorization()

                location.delegate = self
                location.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            }

            let viewRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), latitudinalMeters: zoom, longitudinalMeters: zoom)

            mapView.setRegion(viewRegion, animated: false)
            mapView.showsUserLocation = true
            //mapView.mapType = .satellite
            mapView.pointOfInterestFilter = .init(including: [.gasStation])

            //showUserLocation()

            DispatchQueue.main.async { [self] in
                location.startUpdatingLocation()
            }
        }
    }

    //MARK: show user location
    private func showUserLocation() {
        if let userLocation = location.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(viewRegion, animated: false)
            mapView.showsUserLocation = true
            mapView.mapType = .satellite

            DispatchQueue.main.async { [self] in
                location.startUpdatingLocation()
            }
        }
    }

    //MARK: make a search request
    private func makeSearchRequest(message: String) {

        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = message
        searchRequest.region = mapView.region
        searchRequest.resultTypes = [.pointOfInterest, .address]

        let search = MKLocalSearch(request: searchRequest)

        search.start { [self] response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "No error specified").")
                return
            }
            // Create annotation for every map item
            for mapItem in response.mapItems {

                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate

                annotation.title = mapItem.name
                annotation.subtitle = mapItem.phoneNumber

                mapView.addAnnotation(annotation)
            }
            mapView.setRegion(response.boundingRegion, animated: true)
        }
    }

    //MARK: make shadow around map
    private func makeShadowBehindMap() {
        let radius: CGFloat = mapView.frame.width / 2 //change it to .height if you need spread for height
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2.1 * radius, height: mapView.frame.height))

        mapView.layer.cornerRadius = 2
        mapView.layer.shadowColor = UIColor.black.cgColor
        mapView.layer.shadowOffset = CGSize(width: 0.1, height: 0.1)  //Here you control x and y
        mapView.layer.shadowOpacity = 0.3
        mapView.layer.shadowRadius = 7.0    // blur
        mapView.layer.masksToBounds =  false
        mapView.layer.shadowPath = shadowPath.cgPath
    }

}

//MARK: - CLLocationManagerDelegate
extension MapController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}

//MARK: - MKMapViewDelegate
extension MapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

        //annotationView?.image = UIImage(named: "logo")

        return annotationView
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2
            return renderer

        } else if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 3
            return renderer

        } else if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 2
            return renderer
        }

        return MKOverlayRenderer()
    }
}
