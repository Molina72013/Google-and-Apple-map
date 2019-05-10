//
//  MapMarkerWindow.swift
//  Pods-TurnToTechMap
//
//  Created by Cristian Molina on 9/25/18.
//





import UIKit
import Foundation
import GoogleMaps

class MapMarkerWindow: UIView {
    
    @IBOutlet weak var addressTextField: UITextView!
    
    var handleWebPageAlertDelegate:webPageAlert? = nil

//    weak var delegate: MapMarkerDelegate?
    var spotData: NSDictionary?
    
    
    class func instanceFromNib() -> UIView {

        return UINib(nibName: "MapMarkerWindow", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
        
        
        
    
    }
//     class func instanceFromNib() -> UIView {
//        return UINib(nibName: "MapMarkerWindowView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView


//                let mapWin = MapMarkerWindow()
//
//
//              UINib(nibName: "MapMarkerWindow", bundle: nil).instantiate(withOwner: mapWin, options: nil)
//
//            return mapWin
        
//        let mapWin = MapMarkerWindow()
//
//        mapWin = UINib(nibName: "MapMarkerWindowView", bundle: nil).instantiate(withOwner: mapWin, options: nil).first as! UIView
//
//       // [[NSBundle mainBundle] loadNibNamed:@"MapMarkerWindowView" owner:self options:nil];
//       // [self addSubview:self.mainView];
//       // self.mainView.frame = self.bounds;
//        return mapWin
        
//    }
    

    

    
    
}
