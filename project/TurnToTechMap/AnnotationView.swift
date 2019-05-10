//
//  AnnotationView.swift
//  TurnToTechMap
//
//  Created by Cristian Molina on 9/17/18.
//  Copyright © 2018 Cristian Molina. All rights reserved.
//

//import Foundation

import MapKit


class AnnotationView : MKAnnotationView
{
    
    override var annotation: MKAnnotation?
    {
        willSet
        {
            guard let annotationViewMarker = newValue as? Annotation
            else
            {
                return
            }
            canShowCallout =  true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .infoLight)
          //   markerTintColor = artwork.markerTintColor
            
//            if let imageName = annotationViewMarker.imageName {
//                glyphImage = UIImage(named: imageName)
//            } else {
//                glyphImage = nil
//            }
            
            if let imageName = annotationViewMarker.imageName {
                let img = UIImage(named: imageName)
                let neewImg = ImageResizer.resizeImage(image: img!, targetSize: CGSize(width: 30.0, height: 30.0))
                image = neewImg
                

            }
        
        }
        
    }

    
    
}
