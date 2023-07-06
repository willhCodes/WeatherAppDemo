
# WeatherApp (Demo)

A demo app that fetches weather data and displays it on the UI using either geocode or city name
## Demo

![GIF](https://github.com/willhCodes/WeatherAppDemo/blob/main/sample.gif)
## Highlights

```
    let url: String = "https://api.openweathermap.org/data/2.5/weather?appid="apiKeyGoesHere"&units=imperial"
```

Two different functions have been declared: one that takes geocode and another that takes a city name.



- Geocode
```
    func fetchRequest(latitude:  CLLocationDegrees, longitude:  CLLocationDegrees) {
        let urlString = ("\(url)&lat=\(latitude)&lon=\(longitude)")
        fetch(input: urlString)
    }
```
```

    extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        if let location = locations.last { // converting .last optiondal datatype, this is requesting to print last of the array. doesnt make sense
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            networkManager.fetchRequest(latitude: lat, longitude: lon)
            }
        
        }
    }
    
```


- City name
```
    func fetchRequest(cityName: String) {
        let urlString = "\(url)&q=\(cityName)"
        fetch(input: urlString)
    }
```
```
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text?.replacingOccurrences(of: " ", with:"+") {
            networkManager.fetchRequest(cityName: city)
            searchTextField.text = ""
        }
    }
```
- Geocode was utilized to retrieve state information for corresponding city.
```
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
```

Which is utilized during the URL session.

```
let decodedData = try decoder.decode(NetworkData.self, from: safeData)
                        
                        stateGrabber(latitude: decodedData.coord.lat,
                                     longitude: decodedData.coord.lon,
                                     completion: { result in
                            state = result
                            
                            // Placing below code inside the completion handler of 
                            // stateGrabber devoided some of the potential issues of running into nil

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
```

- Retrieving hexcode based on the temperature

```
    var temperatureColorHexcode: String {
        var hexcode: String?
        switch temperature {
        case _ where temperature > 89:
            hexcode = "F38181"
        case 76...89:
            hexcode = "FCE38A"
        case 60...75:
            hexcode = "D6F7AD"
        case  _ where temperature < 59:
            hexcode = "70A1D7"
        default:
            if hexcode == nil {
                print ("error retrieving hexcode")
            }
        }
        return hexcode ?? "#FFFFFF"
    }
```
```
extension ViewController: NetworkManagerDelegate {
    func weatherModel(model: NetworkModel) {
        
        DispatchQueue.main.async { [self] in
            backgroundColorView.backgroundColor = UIColor(hexCode: model.temperatureColorHexcode)
        }
    }
}
```

- 
