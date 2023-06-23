//
//  MapController.swift
//  hackathon
//
//
import UIKit
import MapKit

final class MapController: UIViewController {
    
    @IBOutlet weak private var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        makeShadowBehindMap()
    }

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
