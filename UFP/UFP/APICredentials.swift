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
    private init() {}

    var apiToken: String?


}