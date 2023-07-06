//
//  ViewController.swift
//  WeatherApp
//
//  Created by willhcodes on 6/28/23.
//

import UIKit
import CoreLocation

protocol NetworkManagerDelegate {
    func weatherModel(model: NetworkModel)
}

struct NetworkManager {
    
    var delegate: NetworkManagerDelegate?
    
    
    let url: String = "https://api.openweathermap.org/data/2.5/weather?appid=\(APIKeyManager().apiKey)&units=imperial"
    
    
    
    func fetchRequest(latitude:  CLLocationDegrees, longitude:  CLLocationDegrees) {
        let urlString = ("\(url)&lat=\(latitude)&lon=\(longitude)")
        fetch(input: urlString)
    }
    
    
    func fetchRequest(cityName: String) {
        let urlString = "\(url)&q=\(cityName)"
        fetch(input: urlString)
    }
    
    
    
    func fetch(input url: String) {
        print ("\(url)")

        var state: String = ""
        
        let session = URLSession(configuration: .default)
        let decoder = JSONDecoder()
        
        if let url = URL(string: url) {
            let task = session.dataTask(with: url, completionHandler: { (data, response, error ) in
                
                if error != nil {
                    return
                }
                
                if let safeData = data {
                    
                    do {
                        
                        
                        let decodedData = try decoder.decode(NetworkData.self, from: safeData)
                        
                        stateGrabber(latitude: decodedData.coord.lat,
                                     longitude: decodedData.coord.lon,
                                     completion: { result in
                            state = result
                            
                            
                            let weatherModel = NetworkModel(temperature: decodedData.main.temp,
                                                            lat: decodedData.coord.lat,
                                                            lon: decodedData.coord.lon,
                                                            cityName: decodedData.name,
                                                            countryName: decodedData.sys.country,
                                                            stateSymbolAbbr: state)
                            
                            self.delegate?.weatherModel(model: weatherModel)
                        })
                        
                    } catch {
                        
                        print (error)
                        
                    }
                }
            })
            task.resume()
            
        }
        
        
    }
    
    
    func stateGrabber(latitude: Double, longitude: Double, completion: @escaping(String) -> Void) {
        
            let geocoder = CLGeocoder()
            
            let location = CLLocation(latitude: latitude, longitude: longitude)
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Reverse geocoding failed: \(error.localizedDescription)")
                    completion("")
                    return
                }
                if let placemark = placemarks?.first {
                    
                    if let state = placemark.administrativeArea {
                        completion(state)
                    }
                }
            }
    }
    
    
    
    
}

