//  APIRoutes.swift
//  HttpWrappers
//  Created by Mashhood Qadeer on 14/03/2021.

import Foundation
import Alamofire
import SwiftyJSON

typealias OptionalDictionary = [String : Any]?
typealias OptionalDictionaryWithDicParam = [String : [String:Any]]?
typealias OptionalSwiftJSONParameters = [String : JSON]?

infix operator =>
infix operator =|
infix operator =<
infix operator =/

func =>(key : String, json : OptionalSwiftJSONParameters) -> String?{
    return json?[key]?.stringValue
}

func =<(key : String, json : OptionalSwiftJSONParameters) -> Double?{
    return json?[key]?.double
}

func =|(key : String, json : OptionalSwiftJSONParameters) -> [JSON]?{
    return json?[key]?.arrayValue
}

func =/(key : String, json : OptionalSwiftJSONParameters) -> Int?{
    return json?[key]?.intValue
}

prefix operator ¿
prefix func ¿(value : String?) -> String {
    return value.unwrap()
}

protocol Router {
    var route : String { get }
    var baseURL : String { get }
    var parameters : OptionalDictionary { get }
    var method : Alamofire.HTTPMethod { get }
}

enum API {
    
    static func mapKeysAndValues(_ tempKeys : [String],_ tempValues : [Any]) -> [String : String]{
        
        var params = [String : String]()
        for (key,value) in zip(tempKeys,tempValues) {
            if let itemValue = value as? String {
                params[key] = itemValue
            }else if let itemValue = value as? [[String:String]] {
                if(itemValue.count == 0 ){
                    
                }else{
                    for (index,itemArray) in itemValue.enumerated() {
                        if let theJSONData = try? JSONSerialization.data(withJSONObject: itemArray,options: .prettyPrinted),let theJSONText = String(data: theJSONData,encoding: String.Encoding.ascii) {
                            print("JSON string = \n\(theJSONText)")
                            params["\(key)[\(index)]"] = theJSONText
                        }
                    }
                    if let theJSONData = try? JSONSerialization.data(withJSONObject: itemValue,options: .prettyPrinted),let theJSONText = String(data: theJSONData,encoding: String.Encoding.ascii) {
                        print("JSON string = \n\(theJSONText)")
                        params[key] = theJSONText
                    }
                }
            }
        }
        return params
    }
    
    static func mapKeysAndValuesDic(_ tempKeys : [String],_ tempValues : [Any]) -> [String:[String:Any]]{
        var params = [String : [String:Any]]()
        for (key,value) in zip(tempKeys,tempValues) {
            if let itemValue = value as? [String:Any] {
                params[key] = itemValue
            }
        }
        return params
    }
    
    case users( limit : String)
    
}

enum EventFollow:String {
    case Follow = "follow"
    case UnFollow = "unfollow"
}

extension API : Router{
    
    var route : String {
        
        switch self {
        case .users(limit : let limit):
            return APIPaths.users
        }
        
    }
    
    var baseURL : String {  return APIConstants.BasePath }
    var parameters : OptionalDictionary {
        var pm = formatParameters()
        return pm
    }
    
    func url() -> String {
        return (baseURL + route).RemoveSpace()
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .users(limit : let limit):
            return .get
        }
    }
}

extension API {
    func formatParameters() -> OptionalDictionary {
        switch self {
        case .users(limit : let limit):
            return API.mapKeysAndValues( APIParameterConstants.Users.user, [limit])
        }
    }
}

enum ReportType:String {
    case CHAT = "chat"
    case USER = "user"
}

enum AddType :String{
    case DAY = "day"
    case DATE = "date"
}
