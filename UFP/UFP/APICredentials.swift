//
//  APICredentials.swift
//  UFP
//
//  Created by Rafael Almeida on 16/03/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import Foundation

class APICredentials {

    static var sharedInstance = APICredentials()
    fileprivate init() {}

    var apiToken: String?
    var userNumber: String?

}
