//
//  Annotation.swift
//  TurnToTechMap
//
//  Created by Cristian Molina on 9/17/18.
//  Copyright © 2018 Cristian Molina. All rights reserved.
//

//import UIKit
import  MapKit

class Annotation: NSObject, MKAnnotation
{
    let title: String?
    let locationName: String
//    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    var url : String
    
    
    var imageName: String? {
        if self.title == "Turn To Tech" {
            return "turntotech"
        }
        return  "Flag"
    }
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D, url: String)
    {

        self.title = title
        self.locationName = locationName
//        self.discipline = discipline
        self.coordinate = coordinate
        self.url = url
        
        super.init() //Superclass inheritance
    }
    
    var subtitle: String?
    {
        return locationName
    }
    
    
    
    
    
}
