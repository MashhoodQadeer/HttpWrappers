//  APIResponse.swift
//  HttpWrappers
//  Created by Mashhood Qadeer on 14/03/2021.

import Foundation
import SwiftyJSON
import ObjectMapper

extension API{
    
    func handleResponse(parameters : JSON?) -> AnyObject? {
       
        switch self {
        case .users(_):
            let data = parameters?.dictionary?["data"]?.arrayObject ?? []
            return data as AnyObject
        }
        
    }
    
}

enum APIValidation : String{
    case None
    case Success = "1"
    case ServerIssue = "500"
    case Failed = "0"
    case TokenInvalid = "401"
}

enum APIResponse {
    case Success(AnyObject?)
    case Failure(String?)
}

func decode<T: Decodable>(_ dataJS: JSON?) -> T?{
    if let data = dataJS?.rawString()?.data(using: .utf8){
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch {
            print(error as Any)
            return nil
        }
    } else{
        return nil
    }
}
