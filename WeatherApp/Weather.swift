//
//  Weather.swift
//  WeatherApp
//
//  Created by Amit Dharmik on 02/02/19.
//  Copyright © 2019 com.yogitechnolabs.Weather. All rights reserved.
//


import Foundation

class Weather {
    
    let dateAndTime: NSDate
    
    let city: String
    let country: String
    let longitude: Double
    let latitude: Double
    
    let weatherID: Int
    let mainWeather: String
    let weatherDescription: String
    let weatherIconID: String
   
    private let temp: Double
    var tempCelsius: Double {
        get {
            return temp - 273.15
        }
    }
    var tempFahrenheit: Double {
        get {
            return (temp - 273.15) * 1.8 + 32
        }
    }
    let sunrise: NSDate
    let sunset: NSDate
    
    init(weatherData: [String: AnyObject]) {
        dateAndTime = NSDate(timeIntervalSince1970: weatherData["dt"] as! TimeInterval)
        city = weatherData["name"] as! String
        
        let coordDict = weatherData["coord"] as! [String: AnyObject]
        longitude = coordDict["lon"] as! Double
        latitude = coordDict["lat"] as! Double
        
        let weatherDict = weatherData["weather"]![0] as! [String: AnyObject]
        weatherID = weatherDict["id"] as! Int
        mainWeather = weatherDict["main"] as! String
        weatherDescription = weatherDict["description"] as! String
        weatherIconID = weatherDict["icon"] as! String
        let mainDict = weatherData["main"] as! [String: AnyObject]
        temp = mainDict["temp"] as! Double
        let sysDict = weatherData["sys"] as! [String: AnyObject]
        country = sysDict["country"] as! String
        sunrise = NSDate(timeIntervalSince1970: sysDict["sunrise"] as! TimeInterval)
        sunset = NSDate(timeIntervalSince1970:sysDict["sunset"] as! TimeInterval)
    }
}
