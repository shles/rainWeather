//
//  JSONWeatherForecast.swift
//  WeatherTest
//
//  Created by Артмеий Шлесберг on 24/09/2017.
//  Copyright © 2017 Jufy. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class JSONWeatherForecast: WeatherForecast, ImmutableMappable {
    var time: Date
    var icon: ObservableImage
    var temperature: String
    
    
    
    required init(map: Map) throws {
        temperature = "\(Int(try map.value("main.temp") as Float))"
        let array = try map.value("weather") as [NSDictionary]
        icon = try JSONIconImage(name: array[0]["icon"] as! String )
        time = try Date(timeIntervalSince1970: TimeInterval(map.value("dt") as Int))
    }
    
}
