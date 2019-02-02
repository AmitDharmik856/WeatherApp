//
//  OpenWeather.swift
//  WeatherApp
//
//  Created by Amit Dharmik on 02/02/19.
//  Copyright © 2019 com.yogitechnolabs.Weather. All rights reserved.
//

import Foundation

protocol OpenWeatherDelegate {
    func GetWeather(weather: Weather)
    func ShowError(error: NSError)
}


class OpenWeather {
    private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "f6f51a9725a82ba4496a46105344313f"
    private var delegate: OpenWeatherDelegate
    
    init(delegate: OpenWeatherDelegate) {
        self.delegate = delegate
    }
    
    func getWeatherByCoordinates(latitude: Double, longitude: Double) {
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&lat=\(latitude)&lon=\(longitude)")!
        print(weatherRequestURL)
        getWeather(weatherRequestURL: weatherRequestURL)
    }
    
    private func getWeather(weatherRequestURL: URL) {
        
        // This is a pretty simple networking task, so the shared session will do.
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 3
        
        let dataTask = session.dataTask(with: weatherRequestURL) { (data: Data?, response: URLResponse?, error: Error?) in

            if let networkError = error {
                // Case 1: Error
                // An error occurred while trying to get data from the server.
                self.delegate.ShowError(error: networkError as NSError)
            }
            else {
                // Case 2: Success
                // We got data from the server!
                do {
                    // Try to convert that data into a Swift dictionary
                    let weatherData = try JSONSerialization.jsonObject(
                        with: data!,
                        options: .mutableContainers) as! [String: AnyObject]
                    
                    // If we made it to this point, we've successfully converted the
                    // JSON-formatted weather data into a Swift dictionary.
                    // Let's now used that dictionary to initialize a Weather struct.
                    let weather = Weather(weatherData: weatherData)
                    
                    // Now that we have the Weather struct, let's notify the view controller,
                    // which will use it to display the weather to the user.
                    self.delegate.GetWeather(weather: weather)
                }
                catch let jsonError as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    self.delegate.ShowError(error: jsonError)
                }
            }
        }
        
        // The data task is set up...launch it!
        dataTask.resume()
    }
}

