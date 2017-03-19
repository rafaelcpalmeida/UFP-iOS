//
//  APIController.swift
//  UFP
//
//  Created by Rafael Almeida on 16/03/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIController {
    private let baseURL = "https://746e6c50.ngrok.io/api/v1/"
    
    public func attemptLogin(userNumber: String, userPassword: String, completionHandler: @escaping (JSON, Error?) -> ()) {
        let params: Parameters = ["username": userNumber, "password": userPassword]
        
        makeRequest(url: "login", method: .post, params: params, completionHandler: completionHandler)
    }
    
    private func makeRequest(url: String, method: HTTPMethod, params: Parameters, completionHandler: @escaping (JSON, Error?) -> ()) {
        Alamofire.request(baseURL + url, method: method, parameters: params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                completionHandler(JSON(value), nil)
            case .failure(let error):
                completionHandler(JSON.null, error)
            }
        }
    }
}
