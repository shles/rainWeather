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

    var baseURL: URL = URL(string:"http://samples.openweathermap.org/data/2.5/")!
    
    var task: Task {
        return .request
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding()
    }
    
    var parameters: [String: Any]? {
        return  [
            "id" :524901 ,
            "appid"  : "b1b15e88fa797225412429c1c50c122a1",

        ]
    }
    
    var method: Moya.Method = .get
    
    var sampleData: Data {
        fatalError()
    }
}
