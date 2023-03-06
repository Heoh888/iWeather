//
//  WeatherViewModel.swift
//  iWeather
//
//  Created by Алексей Ходаков on 21.02.2023.
//

import Foundation
import Combine
import CoreLocation

class WeatherViewModel: ObservableObject {
    
    // MARK: - Public properties
    @Published var temperature: String = ""
    @Published var city: String = ""
    @Published var time = ""
    
    
    // MARK: - Private properties
    private var locationService = LocationService()
    private var location: CLLocation?
    private var geocoder = CLGeocoder()
    private var cancellables = Set<AnyCancellable>()
    private let service: NetworkServiceProtocol!
    private let timerBackpressure = Timer.publish(every: 30, on: .main, in: .common) .autoconnect()
    private let formatter: DateFormatter = {
        let  dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
    
    // MARK: - Initialisation
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
        getLocation()
        setUpTimer()
    }
    
    // MARK: - Private functions
    private func getLocation() {
        let subscription = locationService
            .location
            .pausableSink(receiveCompletion: { print("Pausable subscription completed: \($0)") },
                          receiveValue: { value -> Bool in
                print("Receive value: \(value) % \(String(describing: self.location))")
                if self.location?.coordinate.latitude == value.coordinate.latitude &&
                    self.location?.coordinate.longitude == value.coordinate.longitude {
                    return false
                }
                self.getWeatherData(location: value)
                self.getNameCity(location: value)
                self.location = value
                return true
            })
        
        timerBackpressure
            .sink { _ in
                guard subscription.paused else { return }
                subscription.resume()
            }
            .store(in: &cancellables)
    }
    
    private func getWeatherData(location: CLLocation) {
        service.getWeatherData(location: location)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { print($0) },
                  receiveValue: { self.temperature = String(format: "%.0f", $0.currentWeather.temperature) })
            .store(in: &cancellables)
    }
    
    private func getNameCity(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemarks = placemarks?.last {
                self.city = placemarks.locality ?? ""
            }
        }
    }
    
    private func setUpTimer() {
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] time in
                guard let self = self else { return }
                self.time = self.formatter.string(from: time)
            }
            .store(in: &cancellables)
    }
}
