//
//  Weather.swift
//  iWeather
//
//  Created by Алексей Ходаков on 21.02.2023.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let latitude, longitude, generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone, timezoneAbbreviation: String
    let elevation: Int
    let currentWeather: CurrentWeather

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case currentWeather = "current_weather"
    }
}

// MARK: - CurrentWeather
struct CurrentWeather: Codable {
    let temperature, windspeed: Double
    let winddirection, weathercode: Int
    let time: String
}
