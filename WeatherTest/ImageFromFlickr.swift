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

class SearchResultsFromAPI: ObservableType {
    typealias E = [FlickrSearchResult]

    private let searchText: String

    func subscribe<O:ObserverType>(_ observer: O) -> Disposable where O.E == E {
        return RxMoyaProvider<FlickrSearchTarget>()
        .request(FlickrSearchTarget(with: searchText ))
        .map { response in
            guard (200...299).contains(response.statusCode) else { throw UnknownError() }

            return try Mapper<JSONFlickrSearchResult>()
                .mapArray(JSONObject: (((response.mapJSON(failsOnEmptyData: true) as! [String: Any])["photos"] as! [String: Any])["photo"]))
        }
        .subscribe(observer)
        
    }

    init(with text: String) {
        searchText = text
    }
}

class FlickrSearchTarget: TargetType {
    
    
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

    /// The target's base `URL`.
    var baseURL: URL = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search")!

    var parameters: [String: Any]? {
        return [
            "api_key"  : "731b6251256d60f600098671a785791a",
            "text" : text,
            "format" : "json",
            "nojsoncallback": 1
        ]
    }

    private var text: String
    init(with text: String) {
        self.text = text
    }
}

protocol FlickrSearchResult {

    var id: String { get }
    var secret: String { get }
    var server: String { get }
    var farm: String { get }

}

class JSONFlickrSearchResult: FlickrSearchResult, ImmutableMappable {

    let id: String
    let secret: String
    let server: String
    let farm: String

    required init(map: Map) throws {
        id = try map.value("id") as String
        secret = try map.value("secret") as String
        server = try map.value("server") as String
        farm = "\(try map.value("farm") as Int)"
    }
}
