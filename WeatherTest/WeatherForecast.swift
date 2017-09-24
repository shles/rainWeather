//
//  WeatherForecast.swift
//  WeatherTest
//
//  Created by Артмеий Шлесберг on 24/09/2017.
//  Copyright © 2017 Jufy. All rights reserved.
//

import Foundation


protocol WeatherForecast {
    var time: Date { get }
    var temperature: String { get }
    var icon: ObservableImage { get }
}

struct FakeForecast: WeatherForecast {
    
    var temperature: String = "+19"

    var icon: ObservableImage = FakeWeatherIcon()

    var time: Date = Date()
    
}
