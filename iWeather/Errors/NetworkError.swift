//
//  NetworkError.swift
//  iWeather
//
//  Created by Алексей Ходаков on 06.03.2023.
//

import Foundation

enum NetworkError: LocalizedError {
    case unreachableAddress(url: URL)
    case decodingError(type: String)
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .unreachableAddress(let url):
            return"\(url.absoluteString) is unreachable"
        case .decodingError(let type):
            return "\(type) Decoding error"
        case .invalidResponse:
            return "Response with mistake" }
    }
}
