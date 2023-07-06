//
//  ViewController.swift
//  WeatherApp
//
//  Created by willhcodes on 6/28/23.
//

import Foundation

struct NetworkData: Decodable {
    let main: Main
    let coord: Coord
    let sys: Sys
    let name: String
}

struct Main: Decodable {
    let temp: Double
}

struct Coord: Decodable {
    let lon: Double
    let lat: Double
}

struct Sys: Decodable {
    let country: String
}
