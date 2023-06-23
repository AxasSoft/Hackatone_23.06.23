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

    private func setupUI() {
        makeShadowBehindMap()
        setupLocation()
    }

    private func setupLocation() {
        DispatchQueue.global().async { [self] in
            if CLLocationManager.locationServicesEnabled() {
                location.requestWhenInUseAuthorization()
                location.requestAlwaysAuthorization()

                location.delegate = self
                location.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            }

            if let userLocation = location.location?.coordinate {
                //FIXME: set user location, not hardcode
                let viewRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45.012657, longitude: 39.048542), latitudinalMeters: 1000, longitudinalMeters: 1000)
                //let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.setRegion(viewRegion, animated: false)
                mapView.showsUserLocation = true
                mapView.delegate = self

                mapView.pointOfInterestFilter = .init(including: [.gasStation])

                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = "Gas Station"
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

                        dump(mapItem.url)

                        mapView.addAnnotation(annotation)
                    }
                    mapView.setRegion(response.boundingRegion, animated: true)
                }
            }

            DispatchQueue.main.async { [self] in
                location.startUpdatingLocation()
            }
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

        annotationView?.image = UIImage(named: "arrowGreen")

        return annotationView
    }
}
