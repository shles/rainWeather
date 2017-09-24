//
//  WeatherForecasts.swift
//  WeatherTest
//
//  Created by Артмеий Шлесберг on 24/09/2017.
//  Copyright © 2017 Jufy. All rights reserved.
//

import Foundation
import RxSwift

protocol WeatherForecasts {
    func asObservable() -> Observable<[WeatherForecast]>
}

struct FakeForecasts: WeatherForecasts {
    func asObservable() -> Observable<[WeatherForecast]> {
        return Observable.just([
                FakeForecast(),
                FakeForecast(),
                FakeForecast(),
                FakeForecast(),
                FakeForecast(),
                FakeForecast(),
                FakeForecast(),
            ])
    }
}
