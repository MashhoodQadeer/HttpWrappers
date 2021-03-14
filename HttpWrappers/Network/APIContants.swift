//  APIContants.swift
//  HttpWrappers
//  Created by Mashhood Qadeer on 14/03/2021.

import Foundation

func print(_ items: Any...) {
    #if DEBUG
    Swift.print(items[0])
    #endif
}

internal struct Build{
    static let isProduction = 0
}

internal struct APIConstants {
    static let SocketURL = ""
    static let BasePath = "https://dummyapi.io/data/"
    static let BasePathDeepLink = "https://dummyapi.io/data/api/"
    static let imageBasePath = "https://randomuser.me/api/portraits/"
    static let AppId = "604e5fac9559b96810ca337e"
}

enum TypeEvent:String {
    case TRIP = "&type=trip"
    case LIST = "&type=list"
    case NONE = ""
    case ACCEPT = "&status=accept"
    case REJECT = "&status=reject"
    case BLOCKED = "&status=blocked"
    case PENDING = "&status=pending"
}

enum SavedType:String {
    case EVENT = "event"
    case RECOMMENDATION = "recommendation"
    case PLACE = "place"
}

enum PreferenceType:String {
    case STAY = "stay"
    case DO = "do"
    case REGION = "region"
    case CONTENT = "content"
    case EAT = "eat"
    case DRINK = "drink"
    case COUNTRY = "country"
    case CATEGORY = "category"
}

internal struct APIPaths {
    static let users = "api/user"
}

enum FollowFollowingCases:String {
    case ACCEPT = "accept"
    case PENDING = "pending"
    case REJECT = "reject"
    case BLOCKED = "blocked"
    case ACCEPTED = "accepted"
    case REJECTED = "rejected"
    case NONE = ""
}

enum LikeCase:String {
    case PLACE = "place"
    case RECOMMENDATION = "recommendation"
    case EVENT = "event"
}

enum LikeStatus:Int{
    case LIKE = 1
    case UNLIKE = 0
}

struct FormatParameterKeys {
    static let limit = "limit"
}

internal struct APIParameterConstants {
    
    struct Users {
        static let user = [FormatParameterKeys.limit]
    }
    
}


