//
// Created by Timofey on 7/20/17.
// Copyright (c) 2017 Jufy. All rights reserved.
//

import Foundation

class UnknownError: LocalizedError {

    var localizedDescription: String {
        return NSLocalizedString("UnknownError", comment: "Error that is displayed when no meaningful error can be processed")
    }

    var errorDescription: String? {
        return localizedDescription
    }

}
