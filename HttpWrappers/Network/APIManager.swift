//  APIManager.swift
//  HttpWrappers
//  Created by Mashhood Qadeer on 14/03/2021.

import Foundation
import SwiftyJSON
import SDDownloadManager
import Alamofire

typealias APICompletion = (APIResponse) -> ()
class APIManager: NSObject {
    
    static let sharedInstance = APIManager()
    private lazy var httpClient : HTTPClient = HTTPClient()
    func opertationWithRequest ( withApi api : API , completion : @escaping APICompletion ) {
        
        httpClient.postRequest( withApi: api, success: { (data) in
            
            guard let response = data else {
                completion( APIResponse.Failure("") )
                return
            }
            let json = JSON(response)
            print("Json , API : \(json),\(api.url())")
            if let errorCode = json.dictionaryValue["status"]?.int {
                if errorCode == 404 {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        if message == "Session Expired"{
                            return
                        }
                        completion(APIResponse.Failure(message))
                        return
                    }
                    completion(APIResponse.Failure(""))
                    return
                }else if (errorCode == 400) {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        completion(APIResponse.Failure(message))
                        return
                    }
                }else if let status = json.dictionaryValue["status"]?.bool  {
                    if (!status) {
                        if let message = json.dictionaryValue["message"]?.stringValue {
                            if message == "Session Expired" {
                                //Logout functionality
                                
                            }else {
                                completion(APIResponse.Failure(message))
                            }
                            return
                        }
                    }
                }else{
                    if let data = json.dictionary?["data"] as? [[String:Any]]  {
                        completion(APIResponse.Success(data as AnyObject))
                    } else {
                        completion(APIResponse.Failure("No Data Found"))
                    }
                }
            }else if let status = json.dictionaryValue["status"]?.stringValue {
                if (status == "error") {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        if message == "Session Expired" {
                            //Logout functionality
                        }else {
                            completion(APIResponse.Failure(message))
                        }
                        return
                    }
                }
            }
            
            if json.stringValue.contains("\"status\":\"error\""){
                completion(APIResponse.Failure(""))
                return
            }
            completion(.Success(api.handleResponse(parameters: json)))
            
        }) { (error) in
            print(error)
            completion(APIResponse.Failure(error.localizedDescription))
        }
    }
    
    
    func opertationWithRequestErrorPayload ( withApi api : API , completion : @escaping APICompletion ) {
        httpClient.postRequest( withApi: api, success: { (data) in
            dump( api.parameters )
            guard let response = data else {
                completion( APIResponse.Failure("") )
                return
            }
            let json = JSON(response)
            print("Json , API : \(json),\(api.url())")
            if let errorCode = json.dictionaryValue["status"]?.int {
                if errorCode == 404 {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        if message == "Session Expired"{
                            return
                        }
                        completion(APIResponse.Failure(message))
                        return
                    }
                    completion(APIResponse.Failure(""))
                    return
                }else if (errorCode == 400) {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        completion(APIResponse.Failure(message))
                        return
                    }
                }else if let status = json.dictionaryValue["status"]?.bool  {
                    if (!status) {
                        if let message = json.dictionaryValue["message"]?.stringValue {
                            if message == "Session Expired" {
                                //Logout functionality
                                
                            } else {
                                
                                if let responseId = json.dictionaryValue["data"] {
                                    completion(.Success(api.handleResponse(parameters: json)))
                                    return
                                } else{
                                    completion(APIResponse.Failure(message))
                                }
                                
                            }
                            return
                        }
                    }
                }else{
                    if let email = json.dictionaryValue["message"]?["email"][0].stringValue {
                        if !email.isEmpty{
                            completion(APIResponse.Failure(email))
                            return
                        }
                    }
                    if let password = json.dictionaryValue["message"]?["password"][0].stringValue {
                        
                        if !password.isEmpty{
                            completion(APIResponse.Failure(password))
                            return
                        }
                    }
                }
            }else if let status = json.dictionaryValue["status"]?.stringValue {
                if (status == "error") {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        if message == "Session Expired" {
                            //Logout functionality
                        }else {
                            completion(APIResponse.Failure(message))
                        }
                        return
                    }
                }
            }
            
            if json.stringValue.contains("\"status\":\"error\""){
                completion(APIResponse.Failure(""))
                return
            }
            completion(.Success(api.handleResponse(parameters: json)))
            
        }) { (error) in
            print(error)
            completion(APIResponse.Failure(error.localizedDescription))
        }
    }
    
    
    
    func jsonDecoder<T : Decodable>(structure: T.Type,jsonData: APIResponse) -> Any{
        let responseData = try? JSONSerialization.data(withJSONObject: jsonData, options: [])
        let jsonDecoder = JSONDecoder()
        let data = try? jsonDecoder.decode(structure.self, from: responseData!)
        return data!
    }
    
    func opertationWithRequestWithFileUploading ( withApi api : API, image :  UIImage, fileNamePrefix: String , videoURL: String = "", completion : @escaping APICompletion ) {
    
        
        httpClient.UploadFiles(withApi: api,image: image, videoURL: videoURL, fileNamePrefix: fileNamePrefix, success: { (data) in
            
            
            guard let response = data else {
                completion(APIResponse.Failure(""))
                return
            }
            let json = JSON(response)
            if let errorCode = json.dictionaryValue["status"]?.int {
                if errorCode == 404 {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        if message == "Session Expired"{
                            return
                        }
                        completion(APIResponse.Failure(message))
                        return
                    }
                    completion(APIResponse.Failure(""))
                    return
                }else if (errorCode == 400) {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        completion(APIResponse.Failure(message))
                        return
                    }
                }else if let status = json.dictionaryValue["status"]?.bool  {
                    if (!status) {
                        if let message = json.dictionaryValue["message"]?.stringValue {
                            if message == "Session Expired" {
                            //Logout functionality
                            }else {
                                completion(APIResponse.Failure(message))
                            }
                            return
                        }
                    }
                }else{
                    if let email = json.dictionaryValue["message"]?["email"][0].stringValue {
                        if !email.isEmpty{
                            completion(APIResponse.Failure(email))
                            return
                        }
                    }
                    if let password = json.dictionaryValue["message"]?["password"][0].stringValue {

                        if !password.isEmpty{
                            completion(APIResponse.Failure(password))
                            return
                        }
                    }
                }
            }else if let status = json.dictionaryValue["status"]?.bool {
                if (status) {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        completion(APIResponse.Failure(message))
                        return
                    }
                }
            }

            if json.stringValue.contains("\"status\":\"error\""){
                completion(APIResponse.Failure(""))
                return
            }
            completion(.Success(api.handleResponse(parameters: json)))

        }) { (error) in
            print(error)
            completion(APIResponse.Failure(error.localizedDescription))
        }
    }
    
    func opertationWithRequestWithMultiFileUploading ( withApi api : API, image :  UIImage, fileNamePrefix: String , videoURL: String = "", fileListNamePrefix: String,  fileURL : [URL], completion : @escaping APICompletion ) {
        
        dump(api.parameters)
        httpClient.UploadMultiFiles (withApi: api, image: image, videoURL: videoURL, fileNamePrefix: fileNamePrefix, fileListNamePrefix: fileListNamePrefix,  fileURL : fileURL, success: { (data) in
            
            
            guard let response = data else {
                completion(APIResponse.Failure(""))
                return
            }
            let json = JSON(response)
            if let errorCode = json.dictionaryValue["status"]?.int {
                if errorCode == 404 {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        if message == "Session Expired"{
                            return
                        }
                        completion(APIResponse.Failure(message))
                        return
                    }
                    completion(APIResponse.Failure(""))
                    return
                }else if (errorCode == 400) {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        completion(APIResponse.Failure(message))
                        return
                    }
                }else if let status = json.dictionaryValue["status"]?.bool  {
                    if (!status) {
                        if let message = json.dictionaryValue["message"]?.stringValue {
                            if message == "Session Expired" {
                            //Logout functionality
                            }else {
                                completion(APIResponse.Failure(message))
                            }
                            return
                        }
                    }
                }else{
                    if let email = json.dictionaryValue["message"]?["email"][0].stringValue {
                        if !email.isEmpty{
                            completion(APIResponse.Failure(email))
                            return
                        }
                    }
                    if let password = json.dictionaryValue["message"]?["password"][0].stringValue {

                        if !password.isEmpty{
                            completion(APIResponse.Failure(password))
                            return
                        }
                    }
                }
            }else if let status = json.dictionaryValue["status"]?.bool {
                if (status) {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        completion(APIResponse.Failure(message))
                        return
                    }
                }
            }

            if json.stringValue.contains("\"status\":\"error\""){
                completion(APIResponse.Failure(""))
                return
            }
            completion(.Success(api.handleResponse(parameters: json)))

        }) { (error) in
            print(error)
            completion(APIResponse.Failure(error.localizedDescription))
        }
    }
    
    func opertationWithRequestWithMultiFileOnly ( withApi api : API, fileListNamePrefix: String,  fileURL : [URL], completion : @escaping APICompletion ) {
        dump(api.parameters)
        httpClient.UploadMultiFilesOnly (withApi: api,  fileListNamePrefix: fileListNamePrefix,  fileURL : fileURL, success: { (data) in
            
            
            guard let response = data else {
                completion(APIResponse.Failure(""))
                return
            }
            let json = JSON(response)
            if let errorCode = json.dictionaryValue["status"]?.int {
                if errorCode == 404 {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        if message == "Session Expired"{
                            return
                        }
                        completion(APIResponse.Failure(message))
                        return
                    }
                    completion(APIResponse.Failure(""))
                    return
                }else if (errorCode == 400) {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        completion(APIResponse.Failure(message))
                        return
                    }
                }else if let status = json.dictionaryValue["status"]?.bool  {
                    if (!status) {
                        if let message = json.dictionaryValue["message"]?.stringValue {
                            if message == "Session Expired" {
                            //Logout functionality
                            }else {
                                completion(APIResponse.Failure(message))
                            }
                            return
                        }
                    }
                }else{
                    if let email = json.dictionaryValue["message"]?["email"][0].stringValue {
                        if !email.isEmpty{
                            completion(APIResponse.Failure(email))
                            return
                        }
                    }
                    if let password = json.dictionaryValue["message"]?["password"][0].stringValue {

                        if !password.isEmpty{
                            completion(APIResponse.Failure(password))
                            return
                        }
                    }
                }
            }else if let status = json.dictionaryValue["status"]?.bool {
                if (status) {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        completion(APIResponse.Failure(message))
                        return
                    }
                }
            }

            if json.stringValue.contains("\"status\":\"error\""){
                completion(APIResponse.Failure(""))
                return
            }
            completion(.Success(api.handleResponse(parameters: json)))

        }) { (error) in
            print(error)
            completion(APIResponse.Failure(error.localizedDescription))
        }
    }
    
    
    func uploadDocumentFile( withApi api : API, file : URL  , fileNamePrefix: String , completion : @escaping APICompletion ) {

        dump( api.parameters )
        
        guard file.startAccessingSecurityScopedResource() else {
            print("Security Error")
            return
        }
        
        httpClient.UploadFileByURI(withApi: api, fileURL: file, fileNamePrefix: fileNamePrefix, success: { (data) in
            guard let response = data else {
                completion(APIResponse.Failure(""))
                return
            }
            let json = JSON(response)
            defer { file.stopAccessingSecurityScopedResource() }
            if let errorCode = json.dictionaryValue["status"]?.int {
                if errorCode == 404 {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        if message == "Session Expired"{
                            //Logout functionality
                            return
                        }

                        completion(APIResponse.Failure(message))
                        return
                    }
                    completion(APIResponse.Failure(""))
                    return
                }else if (errorCode == 400) {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        completion(APIResponse.Failure(message))
                        return
                    }
                }else if let status = json.dictionaryValue["status"]?.bool  {
                    if (!status) {
                        if let message = json.dictionaryValue["message"]?.stringValue {
                            if message == "Session Expired" {
                                //Logout functionality

                            }else {
                                completion(APIResponse.Failure(message))
                            }
                            return
                        }
                    }
                }else{
                    if let email = json.dictionaryValue["message"]?["email"][0].stringValue {
                        if !email.isEmpty{
                            completion(APIResponse.Failure(email))
                            return
                        }
                    }
                    if let password = json.dictionaryValue["message"]?["password"][0].stringValue {

                        if !password.isEmpty{
                            completion(APIResponse.Failure(password))
                            return
                        }
                    }
                }
            }else if let status = json.dictionaryValue["status"]?.bool {
                if (status) {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        completion(APIResponse.Failure(message))
                        return
                    }
                }
            }
            
            if json.stringValue.contains("\"status\":\"error\""){
                completion(APIResponse.Failure(""))
                return
            }
            completion(.Success( api.handleResponse(parameters: json)))

        }) { (error) in
            print(error)
            completion(APIResponse.Failure(error.localizedDescription))
        }
    }
    
    
    func UploadDocumentFiles( withApi api : API, file : [URL]  , completion : @escaping APICompletion ) {

//        for fileItem in file {
//            guard fileItem.startAccessingSecurityScopedResource() else {
//                print("Security Error")
//                completion(APIResponse.Failure("File could not be uploaded due to security"))
//                print("The File Error: \(fileItem.absoluteURL)")
//                return
//            }
//        }
        
        httpClient.UploadFileByURIs(withApi: api, fileURL: file, fileNamePrefix: "", success: { (data) in
            guard let response = data else {
                completion(APIResponse.Failure(""))
                return
            }
            let json = JSON(response)
            
            for fileItem in file {
                defer { fileItem.stopAccessingSecurityScopedResource() }
            }
            
            if let errorCode = json.dictionaryValue["status"]?.int {
                if errorCode == 404 {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        if message == "Session Expired"{
                            //Logout functionality
                            return
                        }

                        completion(APIResponse.Failure(message))
                        return
                    }
                    completion(APIResponse.Failure(""))
                    return
                }else if (errorCode == 400) {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        completion(APIResponse.Failure(message))
                        return
                    }
                }else if let status = json.dictionaryValue["status"]?.bool  {
                    if (!status) {
                        if let message = json.dictionaryValue["message"]?.stringValue {
                            if message == "Session Expired" {
                                //Logout functionality

                            }else {
                                completion(APIResponse.Failure(message))
                            }
                            return
                        }
                    }
                }else{
                    if let email = json.dictionaryValue["message"]?["email"][0].stringValue {
                        if !email.isEmpty{
                            completion(APIResponse.Failure(email))
                            return
                        }
                    }
                    if let password = json.dictionaryValue["message"]?["password"][0].stringValue {

                        if !password.isEmpty{
                            completion(APIResponse.Failure(password))
                            return
                        }
                    }
                }
            }else if let status = json.dictionaryValue["status"]?.bool {
                if (status) {
                    if let message = json.dictionaryValue["message"]?.stringValue {
                        completion(APIResponse.Failure(message))
                        return
                    }
                }
            }
            
            if json.stringValue.contains("\"status\":\"error\""){
                completion(APIResponse.Failure(""))
                return
            }
            completion(.Success( api.handleResponse(parameters: json)))

        }) { (error) in
            print(error)
            completion(APIResponse.Failure(error.localizedDescription))
        }
    }
    
    func opertationWithRequestWithMultipleImagesFileUploading(withApi api : API, image:[UIImage] , completion : @escaping APICompletion )  {
         dump(api.parameters)
            httpClient.UploadMultipleImages( withApi: api, images: image,  success: { (data) in
                guard let response = data else {
                    completion(APIResponse.Failure(""))
                    return
                }
                let json = JSON(response)
                               
                if let errorCode = json.dictionaryValue["status"]?.int {
                    if  errorCode == 400 {
                        if let message = json.dictionaryValue["errorMessage"]?.stringValue {
                            
                            if message == "Session Expired"{
                                return
                            }
                            
                            completion(APIResponse.Failure(message))
                            return
                        }
                        completion(APIResponse.Failure(""))
                        return
                    }
                    if errorCode == 401{
                        //User Session Has been expired
                    }
                }
                
                completion(.Success(api.handleResponse(parameters: json)))
                
            }) { (error) in
                print(error)
                completion(APIResponse.Failure(error.localizedDescription))
            }
     }
     
}


