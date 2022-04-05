//
//  ViewController.swift
//  StoreFinder
//
//  Created by 정유진 on 2022/04/04.
//

import UIKit

class ViewController: UIViewController, MTMapViewDelegate {
    
    var mapView: MTMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapView = MTMapView(frame: self.view.bounds)
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard
            self.view.addSubview(mapView)
        }
    }


}

