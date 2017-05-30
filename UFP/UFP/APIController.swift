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

    open func attemptLogin(_ userNumber: String, userPassword: String, completionHandler: @escaping (JSON, Error?) -> ()) {
        let params: Parameters = ["username": userNumber, "password": userPassword]
        
        makeRequest("login", method: .post, params: params, completionHandler: completionHandler)
    }

    open func getUserSchedule(_ token: String, completionHandler: @escaping (JSON, Error?) -> ()) {
        let params: Parameters = ["token": token]
        
        makeRequest("schedule", method: .get, params: params, completionHandler: completionHandler)
    }
    
    open func getUserExams(_ token: String, completionHandler: @escaping (JSON, Error?) -> ()) {
        let params: Parameters = ["token": token]
        
        makeRequest("exams", method: .get, params: params, completionHandler: completionHandler)
    }
    
    open func getUserPaymentDetails(_ token: String, completionHandler: @escaping (JSON, Error?) -> ()) {
        let params: Parameters = ["token": token]
        
        makeRequest("atm", method: .get, params: params, completionHandler: completionHandler)
    }
    
    open func getUserAssiduityDetails(_ token: String, completionHandler: @escaping (JSON, Error?) -> ()) {
        let params: Parameters = ["token": token]
        
        makeRequest("assiduity", method: .get, params: params, completionHandler: completionHandler)
    }
    
    open func getUserFinalGrades(_ token: String, completionHandler: @escaping (JSON, Error?) -> ()) {
        let params: Parameters = ["token": token]
        
        makeRequest("grades/final", method: .get, params: params, completionHandler: completionHandler)
    }
    
    open func getUserPartialGrades(_ token: String, completionHandler: @escaping (JSON, Error?) -> ()) {
        let params: Parameters = ["token": token]
        
        makeRequest("grades/detailed", method: .get, params: params, completionHandler: completionHandler)
    }
    
    open func getQueueStatus(completionHandler: @escaping (JSON, Error?) -> ()) {
        let params: Parameters = [:]
        
        makeRequest("queue", method: .get, params: params, completionHandler: completionHandler)
    }

    fileprivate func getBaseURL() -> String {
        if let path = Bundle.main.path(forResource: "Preferences", ofType: "plist") {
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                return dic["APIBaseURL"] as! String
            }
        }
        
        return ""
    }
    
    fileprivate func makeRequest(_ url: String, method: HTTPMethod, params: Parameters, completionHandler: @escaping (JSON, Error?) -> ()) {
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
