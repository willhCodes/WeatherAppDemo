//
//  ViewController.swift
//  WeatherApp
//
// Created by willhcodes on 6/28/23.
//

import Foundation

struct NetworkModel {
    var temperatureString: String {
        return ("\(Int(temperature)) °F")
    }
    
    var cityString: String {
        return ("\(cityName), \(stateSymbolAbbr)")
    }
    
    var temperature: Double
    
    let lat: Double
    
    let lon: Double
    
    let cityName: String
    
    let countryName: String
    
    let stateSymbolAbbr: String
    
    
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
    
}

