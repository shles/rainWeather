//
//  WeatherForecastsFromAPI.swift
//  WeatherTest
//
//  Created by Артмеий Шлесберг on 24/09/2017.
//  Copyright © 2017 Jufy. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper


class WeatherForecastsFromAPI: WeatherForecasts, ObservableType {
    
    typealias E = [WeatherForecast]
    
    func subscribe<O>(_ observer: O) -> Disposable where O : ObserverType, O.E == E {
        let provider = RxMoyaProvider<WeatherForecastsTarget>()
        return provider
            .request(WeatherForecastsTarget())
            
            .map { response in
                
                guard (200...299).contains(response.statusCode) else { throw UnknownError() }

                return try Mapper<JSONWeatherForecast>()
                    .mapArray(JSONObject: (response.mapJSON(failsOnEmptyData: true) as! [String : Any])["list"]!)

            }
        .subscribe(observer)
    }
}

class WeatherForecastsTarget: TargetType {
    
    var path: String = "forecast"

    var baseURL: URL = URL(string:"http://api.openweathermap.org/data/2.5/")!
    
    var task: Task {
        return .request
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding()
    }
    
    var parameters: [String: Any]? {
        return  [
            "q" : "Moscow" ,
            "appid"  : "16a3b6f788a0136e0bc6bd18325242e4",
            "units": "metric"
        ]
    }
    
    var method: Moya.Method = .get
    
    var sampleData: Data {
        fatalError()
    }
}
