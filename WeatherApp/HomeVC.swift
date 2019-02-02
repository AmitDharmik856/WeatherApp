//
//  HomeVC.swift
//  WeatherApp
//
//  Created by Amit Dharmik on 02/02/19.
//  Copyright © 2019 com.yogitechnolabs.Weather. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class HomeVC: UIViewController,UIGestureRecognizerDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var btnCheckWeather: UIButton!
    let locationManager = CLLocationManager()
    @IBOutlet var mapViewVar: MKMapView!
    
    var lat: Double = 23.0225
    var long: Double = 72.5714
    
    var weather: OpenWeather!
    //---------------------------------------
    // MARK:- View Life
    // MARK:-
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        getLocation()
        
        //**********************
        if (self.mapViewVar.subviews.first!.gestureRecognizers != nil){
            for gesture in self.mapViewVar.subviews.first!.gestureRecognizers!{
                if let tapGesture : UITapGestureRecognizer = gesture as? UITapGestureRecognizer{
                    self.mapViewVar.subviews.first!.removeGestureRecognizer(tapGesture)
                }
            }
        }
        
        let doubleTap = UITapGestureRecognizer(target: self, action:#selector(self.doubleTapAction(gestureReconizer:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        self.mapViewVar.addGestureRecognizer(doubleTap)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
    }
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    @objc func doubleTapAction(gestureReconizer: UITapGestureRecognizer) {
        
        let touchLocation = gestureReconizer.location(in: mapViewVar)
        let locationCoordinate = mapViewVar.convert(touchLocation,toCoordinateFrom: mapViewVar)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        
        lat = locationCoordinate.latitude
        long = locationCoordinate.longitude
        
        self.CheckWeatherForSelectedPlace()
        return
    }
    //---------------------------------------
    // MARK:- IBAction
    // MARK:-
    //---------------------------------------
    @IBAction func CheckWeatherForSelectedPlace() {

        let obj = self.storyboard?.instantiateViewController(withIdentifier: "WeatherDetailsVC") as! WeatherDetailsVC
        obj.latitude = lat
        obj.longitude = long
        self.present(obj, animated: true, completion: nil)
    }
    
    //---------------------------------------
    // MARK:- CLLocationManagerDelegate and related methods
    // MARK:-
    //---------------------------------------
    func getLocation() {
        
        guard CLLocationManager.locationServicesEnabled() else {
            showSimpleAlert(
                title: "Please turn on location services",
                message: "This app needs location services in order to report the weather " +
                    "for your current location.\n" +
                "Go to Settings → Privacy → Location Services and turn location services on."
            )
            self.btnCheckWeather.isEnabled = true
            return
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        
        self.lat = newLocation.coordinate.latitude
        self.long = newLocation.coordinate.longitude
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    
    }
    
    // MARK: - Utility methods
    // -----------------------
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style:  .default,
            handler: nil
        )
        alert.addAction(okAction)
        present(
            alert,
            animated: true,
            completion: nil
        )
    }
    
    //---------------------------------------
    //---------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
