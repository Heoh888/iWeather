//
//  ContentView.swift
//  iWeather
//
//  Created by Алексей Ходаков on 21.02.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            WeatherView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
