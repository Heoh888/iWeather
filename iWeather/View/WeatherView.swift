//
//  WeatherView.swift
//  iWeather
//
//  Created by Алексей Ходаков on 21.02.2023.
//

import SwiftUI

struct WeatherView: View {
    
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.city)
            Text(viewModel.temperature + "°")
            Text(viewModel.time)
        }
    }
}
struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
