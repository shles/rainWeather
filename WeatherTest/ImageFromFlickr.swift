//
//  ImageFromFlicker.swift
//  WeatherTest
//
//  Created by Артмеий Шлесберг on 25/09/2017.
//  Copyright © 2017 Jufy. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

class ImageFromFlickr: ObservableImage, ObservableType {
    
    typealias E = UIImage

    var key = "7d19390a462f984ac72ed9bc8dd69880"

    func subscribe<O:ObserverType>(_ observer: O) -> Disposable where O.E == E {

        return SearchResultsFromAPI(with: "Moscow")
        .flatMap {
            RxMoyaProvider<FlickrImageTarget>()
            .request(FlickrImageTarget(with: $0[0]))
            .mapImage()
            .map{ image in
                guard let image = image else { throw UnknownError() } //create another error for that
                return image
            }
            .catchError{ _ in .empty() }
        }
        .subscribe(observer)
    }

}


class FlickrImageTarget: TargetType {
    /// The parameters to be encoded in the request.
    var parameters: [String : Any]? = nil

    /// The target's base `URL`.
    var baseURL: URL

    var path: String  = ""
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding()
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        fatalError()
    }
    
    var task: Task {
        return .request
    }
    
    init(with searchResult: FlickrSearchResult) {
        baseURL = URL(string: "https://farm\(searchResult.farm).staticflickr.com/\(searchResult.server)/\(searchResult.id)_\(searchResult.secret)_b.jpg")!
    }
}




