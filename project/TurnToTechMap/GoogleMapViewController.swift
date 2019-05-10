//
//  GoogleMap.swift
//  TurnToTechMap
//
//  Created by Cristian Molina on 9/18/18.
//  Copyright © 2018 Cristian Molina. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
protocol webPageAlert {
    func openWebPage(url: String)
}


class GoogleMapViewController: UIViewController, UISearchDisplayDelegate, GMSMapViewDelegate {
    let turntotechImg = ImageResizer.resizeImage(image: UIImage(named: "turntotech")!, targetSize: CGSize(width: 30.0, height: 30.0))
    
     @IBOutlet weak var addressTextField: UITextView!
    //
//    private var infoWindow = MapMarkerWindow()
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    //
    @IBOutlet weak var  mapView: GMSMapView!
    
    var customSC: UISegmentedControl?
    
    var currentMarker :MyMarker?
    
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?

    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView?.delegate = self
//        self.infoWindow = loadNiB()
//        mapView.isMyLocationEnabled = true
        let camera = GMSCameraPosition.camera(withLatitude: 40.7086320, longitude: -74.01465600, zoom: 6.0)
        
        mapView.animate(to: camera)
        
        navigationController?.setToolbarHidden(true, animated: false)

        //Location Manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
        setUpSegmentController()

        
    }
    func loadNiB() -> MapMarkerWindow {
       
        
        
        if let mapWin = UINib(nibName: "MapMarkerWindow", bundle: nil).instantiate(withOwner: nil, options: nil).first as? MapMarkerWindow {
            return mapWin
        }
        else {
            return MapMarkerWindow()
        }
        
        
//        let infoWindow = MapMarkerWindow.instanceFromNib()
//        return infoWindow
    }
    
    
     func setUpSegmentController() {
        let items = ["Normal", "Satelite", "Hybrid"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0

        let bottom = NSLayoutConstraint(item: self.mapView, attribute: NSLayoutAttribute.bottom, relatedBy: .equal, toItem: customSC, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 20)
        
        let leading = NSLayoutConstraint(item: customSC, attribute: NSLayoutAttribute.leading, relatedBy: .equal, toItem: self.mapView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 20)
        let trailing = NSLayoutConstraint(item: self.mapView, attribute: NSLayoutAttribute.trailing, relatedBy: .equal, toItem: customSC, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 20)
        
//        customSC.frame.size.height = 100
  
        customSC.translatesAutoresizingMaskIntoConstraints = false
        customSC.addTarget(self, action: #selector(changeMapType(sender:)), for: .valueChanged)

         self.mapView.addSubview(customSC)
         self.mapView.addConstraints([leading, trailing, bottom])
        
        
    }
    @objc func changeMapType(sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            mapView.mapType = .normal
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid
        }
        
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
       print("VC deallocated")
    }

  

}

extension GoogleMapViewController: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // 7
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        // 8
        locationManager.stopUpdatingLocation()
    }
}


extension GoogleMapViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.website))")

        mapView.clear()
        let marker = MyMarker()

        marker.address = place.formattedAddress
        
        marker.position = place.coordinate
        marker.title = place.name
        if place.formattedAddress == "40 Rector St, New York, NY 10006, USA" {
            marker.icon = turntotechImg
            marker.snippet = "Turn To Tech"
        }
        if let url = place.website {
            marker.url = "\(url)"
        } else
        {
            marker.url = "https://www.google.com"
        }
        
        marker.map = mapView
        

//        currentMarker =  marker
        
        let camera = GMSCameraPosition.camera(withTarget: place.coordinate, zoom: 20)
        mapView.animate(to: camera)
        
//        currentMarker = marker as? MyMarker
//        currentMarker?.url = "\(String(describing: place.website))"

        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        guard let marker = marker as? MyMarker else {return}
        
        let webView = WebView()
        webView.url = marker.url

        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    
    
    /*
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {



        locationMarker = marker
        infoWindow.removeFromSuperview()
        infoWindow = loadNiB()
        guard let location = locationMarker?.position else {
            print("locationMarker is nil")
            return false
        }
        
        // Pass the spot data to the info window, and set its delegate to self
//        infoWindow.delegate = self
        
        // Configure UI properties of info window
        
        infoWindow.alpha = 0.9
        infoWindow.layer.cornerRadius = 12
        infoWindow.layer.borderWidth = 2
        infoWindow.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        infoWindow.layer.borderColor = UIColor(hexString: "19E698")?.cgColor
//        infoWindow.infoButton.layer.cornerRadius = infoWindow.infoButton.frame.height / 2
        
//        let rate = markerData!["rate"]!
//        let fromTime = markerData!["fromTime"]!
//        let toTime = markerData!["toTime"]!
        
//        infoWindow.stAddressLabel.text =  "LABEL"
     //   infoWindow.cityZipLabel.text = "$\(String(format:"%.02f", (rate as? Float)!))/hr"
//        infoWindow.availibilityLabel.text = "\(convertMinutesToTime(minutes: (fromTime as? Int)!)) - \(convertMinutesToTime(minutes: (toTime as? Int)!))"
        // Offset the info window to be directly above the tapped marker
    //    infoWindow.center = mapView.projection.point(for: location)
       infoWindow.center.y = infoWindow.center.y
       
        self.mapView.addSubview(infoWindow)
        return false
    }
    */
    
//    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
//
//        let infoWindow = loadNiB()
//
//
//        infoWindow.frame = CGRect(x: 0, y: 0, width: 150, height: 70)
//        //        infoWindow.backgroundColor = UIColor.blue
//      //  infoWindow.layer.cornerRadius = 12
//
//
//        return infoWindow
//
//  }

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
       
        guard let marker = marker as? MyMarker else {return nil}
        
        
        let infoWindow = loadNiB()
        

        infoWindow.addressTextField.text = marker.address
        infoWindow.frame = CGRect(x: 0, y: 0, width: 80, height: 100)
//        infoWindow.backgroundColor = UIColor.blue
        infoWindow.layer.cornerRadius = 12
       // infoWindow.webButton.addTarget(self, action:#selector(openWebPageeee(_:)), for:.touchUpInside)

        return infoWindow
    }
//

}


