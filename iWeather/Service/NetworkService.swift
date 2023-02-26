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

enum NetworkError: LocalizedError {
    case unreachableAddress(url: URL)
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .unreachableAddress(let url):
            return"\(url.absoluteString) is unreachable"
        case .invalidResponse:
            return "Response with mistake" }
    }
}

class NetworkService: NetworkServiceProtocol {
    // MARK: - Private properties
    private let decoder = JSONDecoder()
    private let queue = DispatchQueue(label: "NetworkService", qos: .default, attributes: .concurrent)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public functions
    func getWeatherData(location: CLLocation) -> AnyPublisher<WeatherModel, NetworkError>  {
        URLSession.shared
            .dataTaskPublisher(for: urlСonfiguration(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            .receive(on: queue)
            .map(\.data)
            .decode(type: WeatherModel.self, decoder: decoder)
            .mapError({ error -> NetworkError in
                switch error  {
                case is URLError:
                    return NetworkError.unreachableAddress(url: URL(string: "https://api.open-meteo.com/")!)
                default:
                    return NetworkError.invalidResponse
                }
            })
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private functions
    private func urlСonfiguration(latitude: Double, longitude: Double) -> URL {
        URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current_weather=true")!
    }
}
