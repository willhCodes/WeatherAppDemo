//
//  ViewController.swift
//  WeatherApp
//
//  Created by willhcodes on 6/28/23.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {
    
    
    @IBOutlet weak var backgroundColorView: UIView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    
    var networkManager = NetworkManager()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        networkManager.delegate = self
        searchTextField.delegate = self
        searchTextField.keyboardType = .default
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    
    @IBAction func fetchButtonPressed(_ sender: Any) {
        
        searchTextField.endEditing(true)
        
    }
    
    
}

extension ViewController: NetworkManagerDelegate {
    func weatherModel(model: NetworkModel) {
        
        DispatchQueue.main.async { [self] in
            cityNameLabel.text = model.cityString
            temperatureLabel.text = model.temperatureString
            backgroundColorView.backgroundColor = UIColor(hexCode: model.temperatureColorHexcode)
        }
    }
}




extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        if let location = locations.last { // converting .last optiondal datatype, this is requesting to print last of the array. doesnt make sense
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            networkManager.fetchRequest(latitude: lat, longitude: lon)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        if CLLocationManager.authorizationStatus() == .denied {
            print ("Error while retrieving location: Access Denied \(error.localizedDescription)")
            return
        }
        
        
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text?.replacingOccurrences(of: " ", with:"+") {
            networkManager.fetchRequest(cityName: city)
            searchTextField.text = ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
}
