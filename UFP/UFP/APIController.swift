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

    public func attemptLogin(userNumber: String, userPassword: String, completionHandler: @escaping (JSON, Error?) -> ()) {
        let params: Parameters = ["username": userNumber, "password": userPassword]
        
        makeRequest(url: "login", method: .post, params: params, completionHandler: completionHandler)
    }

    public func getUserSchedule(token: String, completionHandler: @escaping (JSON, Error?) -> ()) {
        let params: Parameters = ["token": token]
        
        makeRequest(url: "schedule", method: .get, params: params, completionHandler: completionHandler)
    }
    
    public func getUserPaymentDetails(token: String, completionHandler: @escaping (JSON, Error?) -> ()) {
        let params: Parameters = ["token": token]
        
        makeRequest(url: "atm", method: .get, params: params, completionHandler: completionHandler)
    }
    
    public func getUserAssiduityDetails(token: String, completionHandler: @escaping (JSON, Error?) -> ()) {
        let params: Parameters = ["token": token]
        
        makeRequest(url: "assiduity", method: .get, params: params, completionHandler: completionHandler)
    }

    private func getBaseURL() -> String {
        if let path = Bundle.main.path(forResource: "Preferences", ofType: "plist") {
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                return dic["APIBaseURL"] as! String
            }
        }
        
        return ""
    }
    
    private func makeRequest(url: String, method: HTTPMethod, params: Parameters, completionHandler: @escaping (JSON, Error?) -> ()) {
        if self.getBaseURL() != "" {
            Alamofire.request(self.getBaseURL() + url, method: method, parameters: params).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    completionHandler(JSON(value), nil)
                case .failure(let error):
                    completionHandler(JSON.null, error)
                }
            }
        }
    }
    
    
}
