//
// Created by Артмеий Шлесберг on 25/09/2017.
// Copyright (c) 2017 Jufy. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import RxSwift

class SearchResultsFromAPI: ObservableType {
    typealias E = [FlickrSearchResult]

    private let searchText: String

    func subscribe<O:ObserverType>(_ observer: O) -> Disposable where O.E == E {
        return RxMoyaProvider<FlickrSearchTarget>()
                .request(FlickrSearchTarget(with: searchText ))
                .map { response in
                    guard (200...299).contains(response.statusCode) else { throw UnknownError() }

                    guard let json = try? response.mapJSON(failsOnEmptyData: true),
                        let dict = (json as? [String: Any]),
                        let photos = dict["photos"] as? [String: Any]
                     else  { throw UnknownError() }
                    return try Mapper<JSONFlickrSearchResult>()
                            .mapArray(JSONObject: photos["photo"])
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
            "api_key"  : "7d19390a462f984ac72ed9bc8dd69880",
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
