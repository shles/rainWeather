//
// Created by Артмеий Шлесберг on 25/09/2017.
// Copyright (c) 2017 Jufy. All rights reserved.
//

import Foundation
import ObjectMapper

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