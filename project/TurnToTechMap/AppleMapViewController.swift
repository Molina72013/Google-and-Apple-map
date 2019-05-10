//
//  ViewController.swift
//  TurnToTechMap
//
//  Created by Cristian Molina on 9/13/18.
//  Copyright © 2018 Cristian Molina. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark, link: String)
}

class AppleMapViewController: UIViewController, UITabBarDelegate {

    let locationManager =  CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil

  
    let turnToTechPin = Annotation(title: "Turn To Tech", locationName: "Technologhy School", coordinate: CLLocationCoordinate2D(latitude: 40.7086320, longitude: -74.01465600), url: "http://turntotech.io")

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid
        }
    }
    

    @IBAction func turnToTech(_ sender: UIButton)
    {
        
 
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(turnToTechPin.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        mapView.addAnnotation(turnToTechPin)
        
        
        
        mapView.register(AnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        
        
        navigationController?.setToolbarHidden(true, animated: false)

        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkLocationAuthorization()
        

        
        
        guard  let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as? LocationSearchTable
            else {
                return
        }
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        
         
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search places"
        navigationItem.titleView = resultSearchController?.searchBar
        //
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        //
        locationSearchTable.mapView = mapView
        //
       locationSearchTable.handleMapSearchDelegate = self

        
        
        
        
        
    }
    
    //ASK FOR PERMISSION
    func checkLocationAuthorization()
    {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
        else
        {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        
        
        self.resultSearchController = nil
        self.resultSearchController?.delegate = nil

    }
    
    
    deinit{
        print("VC deallocated")
        locationManager.stopUpdatingLocation()
    }


}


extension AppleMapViewController : CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
    
    
}




extension AppleMapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark, link: String){
        // cache the pin
        selectedPin = placemark

        for anno in mapView.annotations
        {

            if anno.coordinate.latitude != turnToTechPin.coordinate.latitude && anno.coordinate.longitude != turnToTechPin.coordinate.longitude
            {
                mapView.removeAnnotation(anno)
            }
        }

        
//        mapView.removeAnnotations(mapView.annotations)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = placemark.coordinate
//        annotation.title = placemark.name
      //  let test: Annotation
//        if let city = placemark.locality,
//            let state = placemark.administrativeArea {
//            let subTitle = "\(city) \(state)"
//            let test = Annotation(title: placemark.name!, locationName: placemark.subThoroughfare!, coordinate: placemark.coordinate)
//            mapView.addAnnotation(test)
//
//        }
        
        
        
        if let stNum = placemark.subThoroughfare, let street = placemark.thoroughfare
        {
             let adress = "\(stNum) \(street)"
            if adress == "40 Rector St" && placemark.postalCode == "10006"
            {
                let test = Annotation(title: "Turn To Tech" , locationName:adress , coordinate: placemark.coordinate, url: link)
                mapView.addAnnotation(test)
            } else
            {
            
                let test = Annotation(title: placemark.name!, locationName:adress , coordinate: placemark.coordinate, url: link)
            mapView.addAnnotation(test)
            }
        } else if let name = placemark.name
        {
            let test = Annotation(title: name, locationName:name , coordinate: placemark.coordinate, url: "")
            mapView.addAnnotation(test)

        }
        print(placemark.location!)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}


extension AppleMapViewController: MKMapViewDelegate {
    //1
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
//    {
//        //2
//        guard let annotation = annotation as? Annotation
//         else
//        {
//            print("ERROR: annotation is not Artwork")
//            return nil
//        }
//
//        //3
//        let identifier = "marker"
////        if annotation.title = "Turn To Tech" {
////            identifier = ""
////        }
//
//        var view: MKMarkerAnnotationView
//        //4
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
//        {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else
//        {
//            //5
//            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        return view
//    }
    
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("It worsk when you press the add Button")
        let place = view.annotation
        
        guard let anno = place as? Annotation
        else
        {
            return
        }
      
        print(anno.url)


        let webView = WebView()
         webView.url = anno.url
        self.navigationController?.pushViewController(webView, animated: true)
    }
}

