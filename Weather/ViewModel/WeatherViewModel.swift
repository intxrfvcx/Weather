//
//  WeatherViewModel.swift
//  Weather
//
//  Created by interface on 20.08.2021.
//

import Foundation


private let defaultIcon = "β"
private let iconMap = [
    "Drizzle": "π¦",
    "Thunderstorm": "β",
    "Rain": "π§",
    "Snow": "βοΈ",
    "Clear": "βοΈ",
    "Clouds": "π€"
]

public class WeatherViewModel: ObservableObject {
    @Published var cityName: String =  "City Name"
    @Published var temperature: String = "--"
    @Published var weatherDiscription: String = "--"
    @Published var weatherIcon: String = defaultIcon
    
    public let weatherService: WeatherService
    
    public init(weatherService: WeatherService){
        self.weatherService = weatherService
    }
    
    public func refresh(){
        weatherService.loadWeatherData {weather in
            DispatchQueue.main.async {
                self.cityName = weather.city
                self.temperature = "\(weather.temperature)ΒΊC"
                self.weatherDiscription = weather.description.capitalized
                self.weatherIcon = iconMap[weather.iconName] ?? defaultIcon
            }
        }
    }
}

