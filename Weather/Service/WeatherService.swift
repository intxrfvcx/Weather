//
//  WeatherService.swift
//  Weather
//
//  Created by interface on 24.06.2021.
//

import Foundation
import CoreLocation

public final class WeatherService: NSObject{
    private let locationManager = CLLocationManager()
    private let API_KEY = "87e3b790c9a9f883d2fcd89a23e16eb7"
    private var completionHandler: ((Weather) -> Void)?
    
    public override init(){
        super.init()
        locationManager.delegate = self
    }
    
    public func loadWeatherData( _ complitionHandler: ((Weather) -> Void)?){
        self.completionHandler = complitionHandler
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    public func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D){
        
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&lang=ru&appid=\(API_KEY)&units=metric".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        
        // GET
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url){ data, response, error in
            guard error == nil, let data = data else {return}
            if let responce = try? JSONDecoder().decode(APIResponce.self, from: data){
                self.completionHandler?(Weather(responce: responce))
            }
        }.resume()
    }
}

extension WeatherService: CLLocationManagerDelegate {
    public func locationManager (_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]){
        guard let location = location.first else { return }
        makeDataRequest(forCoordinates: location.coordinate)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Что то пошло не так: \(error.localizedDescription)")
    }
}

struct APIResponce: Decodable {
    let name: String
    let main: APIMain
    let weather: [APIWeatehr]
}


struct APIMain: Decodable {
    let temp: Double
}


struct APIWeatehr: Decodable {
    let description: String
    let iconName: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case iconName = "main"
    }
}
