//
//  WeatherDetailsVC.swift
//  WeatherApp
//
//  Created by Amit Dharmik on 02/02/19.
//  Copyright © 2019 com.yogitechnolabs.Weather. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherDetailsVC: UIViewController,OpenWeatherDelegate,
CLLocationManagerDelegate {

    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblweather: UILabel!
    @IBOutlet weak var lblTem: UILabel!
    @IBOutlet weak var lblCloudCover: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    
    @IBOutlet weak var viewLoading: UIView!
    let locationManager = CLLocationManager()
    var weather: OpenWeather!
    
    //----default value testing
    var latitude: Double = 23.0225
    var longitude: Double = 72.5714

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoading.layer.cornerRadius = 12
        weather = OpenWeather(delegate: self)
        self.navigationItem.setHidesBackButton(true, animated:true);

        print("lat = \(latitude) and Long = \(longitude)")
        weather.getWeatherByCoordinates(latitude: latitude,
                                        longitude: longitude)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //---------------------------------------
    // MARK:- OpenWeatherDelegate
    // MARK:-
    //---------------------------------------
    func GetWeather(weather: Weather){
        print("lat = \(latitude) and Long = \(longitude)")
        DispatchQueue.main.async() {
            print(weather.city)
            self.viewLoading.isHidden = true
            self.lblCity.text = weather.city
            self.lblweather.text = weather.weatherDescription
            self.lblTem.text = "\(Int(round(weather.tempCelsius)))°"
            self.navigationItem.setHidesBackButton(false, animated:true);

        }
    }
    func ShowError(error: NSError){
        print(error.description)
    }
    @IBAction func DissmissThisVC(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
