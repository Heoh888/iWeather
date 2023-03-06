//
//  Extension.swift
//  iWeather
//
//  Created by Алексей Ходаков on 06.03.2023.
//

import Foundation
import Combine

//MARK: - URLSession
extension URLSession {
    func publisher(for url: URL, decoder: JSONDecoder = .init()) -> AnyPublisher<WeatherModel, NetworkError> {
        dataTaskPublisher(for: url)
            .receive(on: DispatchQueue(label: "NetworkService", qos: .default, attributes: .concurrent))
            .map(\.data)
            .decode(type: WeatherModel.self, decoder: decoder)
            .mapError({ error -> NetworkError in
                switch error  {
                case is URLError:
                    return NetworkError.unreachableAddress(url: url)
                case is DecodingError:
                    return NetworkError.decodingError(type: String(describing: WeatherModel.self))
                default:
                    return NetworkError.invalidResponse
                }
            })
            .eraseToAnyPublisher()
    }
}

//MARK: - Publisher
extension Publisher {
    func pausableSink(receiveCompletion: @escaping ((Subscribers.Completion<Failure>) -> Void),
                      receiveValue: @escaping ((Output) -> Bool)) -> Pausable & Cancellable {
        let pausable = PausableSubscriber(receiveValue: receiveValue, receiveCompletion: receiveCompletion)
        self.subscribe(pausable)
        return pausable
    }
}
