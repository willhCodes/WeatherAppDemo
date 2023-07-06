//
//  APIKeyManager.swift
//  WeatherApp
//
//  Created by willhcodes on 6/28/23.
//


import Foundation

struct APIKeyManager {
    var apiKey: String {
        guard let plistPath = Bundle.main.path(forResource: "Secret", ofType: "plist"),
              let plistData = FileManager.default.contents(atPath: plistPath),
              let plistDictionary = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any],
              let apiKey = plistDictionary["API Key"] as? String else {
            fatalError("API Key not found in plist file")
            
        }
        return apiKey
    }
}
