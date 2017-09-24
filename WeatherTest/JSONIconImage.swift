//
// Created by Timofey on 7/4/17.
// Copyright (c) 2017 Jufy. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import RxSwift

class JSONIconImage: ImmutableMappable, ObservableType, WeatherIcon{

    typealias E = UIImage
    func subscribe<O:ObserverType>(_ observer: O) -> Disposable where O.E == E {
        return RxMoyaProvider<AnyURLTarget>()
            .request(.init(url: url))
            .mapImage()
            .map{ image in
                guard let image = image else { throw UnknownError() } //create another error for that
                return image
            }
            .catchError{ _ in .empty() } //FIXME: This is a hack and image loading error handling shouldn't be done here. It should be possible to recover from JSONImage failure. Remove catch error and do proper error handling with Recoverable.
            .subscribe(observer)
    }

    private var url: URL {
        return URL(string: "http://openweathermap.org/img/w/\(name).png")!
    }
    let name: String

    required init(map: Map) throws {
        name = (try? map.value("icon") as String) ??  "http://lorempixel.com/300/300/cats/"
    }
    
    init(name: String) {
        self.name = name
    }
    
    func mapping(map: Map) {
        
    }

}


