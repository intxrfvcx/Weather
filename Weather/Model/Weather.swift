//
//  Weather.swift
//  Weather
//
//  Created by interface on 24.06.2021.
//

import Foundation

public struct Weather {
    let city: String
    let temperature: String
    let description: String
    let iconName: String
    
    init(responce: APIResponce) {
        city = responce.name
        temperature = "\(Int(responce.main.temp))"
        description = responce.weather.first?.description ?? ""
        iconName = responce.weather.first?.iconName ?? ""
        print(responce)
    }
}
