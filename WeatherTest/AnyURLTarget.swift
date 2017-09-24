//
// Created by Timofey on 7/4/17.
// Copyright (c) 2017 Jufy. All rights reserved.
//

import Foundation
import Moya

struct AnyURLTarget: TargetType {

    let url: URL

    var baseURL: URL {
        guard
            let scheme = url.scheme,
            let host = url.host,
            let finalUrl = URL(string: "\(scheme)://\(host)") else {
            fatalError()
        }

        return finalUrl
    }

    var path: String {
        return url.path
    }

    var parameterEncoding: ParameterEncoding {
        return URLEncoding()
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var sampleData: Data {
        fatalError()
    }
    
    var task: Task {
        return .request
    }

}
