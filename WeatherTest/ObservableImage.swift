//
// Created by Timofey on 6/28/17.
// Copyright (c) 2017 Jufy. All rights reserved.
//

import Foundation
import RxSwift

protocol ObservableImage {

    func asObservable() -> Observable<UIImage>

}

protocol WeatherIcon: ObservableImage  {
    var name: String { get }
}

struct FakeWeatherIcon: WeatherIcon {
    var name: String = ""

    func asObservable() -> Observable<UIImage> {
        return Observable.just(#imageLiteral(resourceName: "FakeSun"))
    }
}
