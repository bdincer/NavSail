//
//  ViewController.swift
//  NavSail
//
//  Created by Bora Dincer on 4/14/18.
//  Copyright © 2018 Bora Dincer. All rights reserved.
//

import UIKit
import MapKit 
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate,  MKMapViewDelegate {

    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!

    @IBOutlet weak var heading: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var courseLbl: UILabel!
    @IBOutlet weak var speedLbl: UILabel!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let userLocation = mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance(userLocation.location!.coordinate, 10000, 10000)
        mapView.setRegion(region, animated: true)
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        startLocation = nil
        mapView.showsUserLocation = true
        mapView.delegate = self
    
        
     
    }
    @IBAction func localWeather(_ sender: Any) {
        
        performSegue(withIdentifier: "goToCurrentWeather", sender: self)
    }
    @IBAction func dropPinPressed(_ sender: Any) {
        let userLocation = mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance(userLocation.location!.coordinate, 2000, 2000)
        mapView.setRegion(region, animated: true)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WeatherVC
        let userLocation = mapView.userLocation
        destinationVC.lat =  userLocation.location!.coordinate.latitude
        destinationVC.long =  userLocation.location!.coordinate.longitude
        print("segue\(userLocation.location!.coordinate.longitude)")
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        mapView.centerCoordinate = userLocation.location!.coordinate
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("error happened\(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        if let direction = locationManager.heading?.magneticHeading {
            //print("heading: \(direction)")
            heading.text = "\(String(format: "%.2f", direction))"
        }
        else {
            heading.text = "N/A"
        }
        
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        let doubleMetric = latestLocation.speed
        let convert = doubleMetric * 1.94384
        
       
        //print ("Test" + String(format: "%.4f", latestLocation.coordinate.latitude))
        if convert > 0 {
            speedLbl.text =  "0.0"
            courseLbl.text = "N/A"
        }else{
            speedLbl.text = "\(String(format: "%.2f", convert)) kts"
            courseLbl.text =  "\(String(format: "%.2f", latestLocation.course))°"
         
        }
       
        
        if startLocation == nil {
            startLocation = latestLocation
        }

        
    }
    
    
    
}

