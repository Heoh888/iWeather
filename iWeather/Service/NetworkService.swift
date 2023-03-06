//
//  NetworkService.swift
//  iWeather
//
//  Created by Алексей Ходаков on 21.02.2023.
//

import Foundation
import Combine
import MapKit

protocol NetworkServiceProtocol {
    func getWeatherData(location: CLLocation) -> AnyPublisher<WeatherModel, NetworkError>
}

class NetworkService: NetworkServiceProtocol {
    
    private let decoder = JSONDecoder()
    private var cancellables = Set<AnyCancellable>()
    
    func getWeatherData(location: CLLocation) -> AnyPublisher<WeatherModel, NetworkError>  {
        URLSession.shared
            .publisher(for: urlСonfiguration(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
    }

    private func urlСonfiguration(latitude: Double, longitude: Double) -> URL {
        URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current_weather=true")!
    }
}
