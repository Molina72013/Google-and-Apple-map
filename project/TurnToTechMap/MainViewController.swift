//
//  MainViewController.swift
//  TurnToTechMap
//
//  Created by Cristian Molina on 9/19/18.
//  Copyright © 2018 Cristian Molina. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    weak var FirstVC : AppleMapViewController?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appleLogo = ImageResizer.resizeImage(image: UIImage(named: "apple")!, targetSize: CGSize(width: 25.0, height: 25.0))
        
        let googleLogo = ImageResizer.resizeImage(image: UIImage(named: "google")!, targetSize: CGSize(width: 25.0, height: 25.0))
        
        let firstButton = UIBarButtonItem(image: appleLogo, style: .plain, target: self, action: #selector(firstTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let secondButton = UIBarButtonItem(image: googleLogo, style: .plain, target: self, action: #selector(secondTapped))
        
        
        
        
        
        toolbarItems = [firstButton, flexSpace, secondButton]
//        navigationController?.setToolbarHidden(false, animated: false)
        

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setToolbarHidden(false, animated: false)

        
        
    }

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //
    @objc func firstTapped()
    {


        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainView")
        
        FirstVC = controller as? AppleMapViewController
        
        self.navigationController?.pushViewController(FirstVC!, animated: true)



    }
    
    @objc func secondTapped()
    {
        
       // let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "GoogleMap")
        
        
        self.navigationController?.pushViewController(controller!, animated: true)
        
        
    }

}
