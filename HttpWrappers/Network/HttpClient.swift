//  HttpClient.swift
//  HttpWrappers
//  Created by Mashhood Qadeer on 14/03/2021.

import Foundation
import Alamofire
import SwiftyJSON

typealias HttpClientSuccess = (AnyObject?) -> ()
typealias HttpClientFailure = (NSError) -> ()

    class HTTPClient {
    func postRequestWithJsonString(withEndPoint url : String  , withBody body : [String:Any] , apiMethod : HTTPMethod , success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure )  {
            var headers: HTTPHeaders = self.GetHeaders()
            let apiURL = APIConstants.BasePath + url
            Alamofire.request(apiURL, method: .post, parameters: body, encoding: URLEncoding.default , headers: headers).responseString { (response: DataResponse< String>) in
                    switch(response.result) {
                    case .success(_):
                       if let data = response.result.value{
                          success(data.parseJSONString as AnyObject?)
                        }
                    case .failure(_):
                        failure(response.result.error! as NSError)
                        
                    }
                }
            }
        
    func postRequest(withApi api : API  , success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure )  {

        let params = api.parameters
        let method = api.method
        
        var headers: HTTPHeaders = self.GetHeaders()
        Alamofire.request(api.url(), method: method,parameters: params, encoding: URLEncoding.default , headers: headers).responseString { ( response:DataResponse<String> ) in
            switch(response.result) {
            case .success(_):
               if let data = response.result.value{
                  success(data.parseJSONString as AnyObject?)
                }
            case .failure(_):
                failure(response.result.error! as NSError)
            }
        }
    }
        
        func postRequestWithMUXAuth(withApi api : API  , success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure )  {
            let params = api.parameters
            let method = api.method
            var headers: HTTPHeaders = self.GetHeaders()
            
            Alamofire.request(api.url(), method: method,parameters: params, encoding: JSONEncoding.default , headers: headers).responseString { (response:DataResponse<String>) in
                switch(response.result) {
                case .success(_):
                   if let data = response.result.value{
                      success(data.parseJSONString as AnyObject?)
                    }
                case .failure(_):
                    failure(response.result.error! as NSError)
                    
                }
            }
        }
        
        func UploadFiles(withApi api:API, image : UIImage , videoURL: String = "", fileNamePrefix: String ,success : @escaping HttpClientSuccess, failure: @escaping HttpClientFailure)
        {
            var headers: HTTPHeaders  = self.GetHeaders()
            var fileName: String = String(Date().timeIntervalSince1970) + ".png"
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                if videoURL == ""{
                    let dt = image.compressedData()!
                    multipartFormData.append( dt, withName: fileNamePrefix, fileName: fileName, mimeType: "image/png")
            }else{
                let video = URL(string: videoURL)
                multipartFormData.append(video!, withName: "file", fileName: String(Date().timeIntervalSince1970)+"." + video!.pathExtension, mimeType:  "video/mp4")
            }
            if api.parameters != nil {
            for (key, value) in api.parameters!{
                let stringValue = value as? String ?? ""
                multipartFormData.append( Data(stringValue.utf8)  , withName: key)
            }
            }

        }, usingThreshold: UInt64.init(), to: api.url(), method: .post,headers: headers
        ) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseString(completionHandler: { (response:DataResponse<String>)  in
                    switch(response.result) {
                    case .success(_):
                        if let data = response.result.value{
                            success(data.parseJSONString as AnyObject?)
                        }
                    case .failure(_):
                        failure(response.result.error! as NSError)
                    }
                })
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                failure(error as NSError)
            }
           }
        }
        
        func UploadMultiFiles(withApi api:API, image : UIImage , videoURL: String = "", fileNamePrefix: String , fileListNamePrefix: String,  fileURL : [URL] ,success : @escaping HttpClientSuccess, failure: @escaping HttpClientFailure)
        {
            var headers: HTTPHeaders  = self.GetHeaders()
            var fileName: String = String(Date().timeIntervalSince1970) + ".png"
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                if videoURL == ""{
                    let dt = image.compressedData()!
                    multipartFormData.append( dt, withName: fileNamePrefix, fileName: fileName, mimeType: "image/png")
            }else{
                let video = URL(string: videoURL)
                multipartFormData.append(video!, withName: "file", fileName: String(Date().timeIntervalSince1970)+"." + video!.pathExtension, mimeType:  "video/mp4")
            }
                
            //For the Files List
                if( fileURL != nil  ){
                    
                    var index : Int = 0
                    for uri in fileURL {
                        multipartFormData.append( uri, withName: "\(fileListNamePrefix)[\(index)]", fileName: String(Date().timeIntervalSince1970) + "." + uri.pathExtension, mimeType:  uri.pathExtension )
                        index = index + 1
                    }

                }
            //End of Files List
                
            if api.parameters != nil {
            for (key, value) in api.parameters!{
                let stringValue = value as? String ?? ""
                multipartFormData.append( Data(stringValue.utf8)  , withName: key)
            }
            }

        }, usingThreshold: UInt64.init(), to: api.url(), method: .post,headers: headers
        ) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseString(completionHandler: { (response:DataResponse<String>)  in
                    switch(response.result) {
                    case .success(_):
                        if let data = response.result.value{
                            success(data.parseJSONString as AnyObject?)
                        }
                    case .failure(_):
                        failure(response.result.error! as NSError)
                    }
                })
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                failure(error as NSError)
            }
           }
        }
        
        func UploadMultiFilesOnly(withApi api:API, fileListNamePrefix: String,  fileURL : [URL] ,success : @escaping HttpClientSuccess, failure: @escaping HttpClientFailure)
        {
            var headers: HTTPHeaders  = self.GetHeaders()
            var fileName: String = String(Date().timeIntervalSince1970) + ".png"
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
            //For the Files List
                if( fileURL != nil  ){
                    
                    var index : Int = 0
                    for uri in fileURL {
                        multipartFormData.append( uri, withName: "\(fileListNamePrefix)[\(index)]", fileName: String(Date().timeIntervalSince1970) + "." + uri.pathExtension, mimeType:  uri.pathExtension )
                        index = index + 1
                    }

                }
            //End of Files List
                
            if api.parameters != nil {
            for (key, value) in api.parameters!{
                let stringValue = value as? String ?? ""
//                multipartFormData.append(stringValue.data(using: String.Encoding.utf8)!, withName: key)
                multipartFormData.append( Data(stringValue.utf8)  , withName: key)
            }
            }

        }, usingThreshold: UInt64.init(), to: api.url(), method: .post,headers: headers
        ) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseString(completionHandler: { (response:DataResponse<String>)  in
                    switch(response.result) {
                    case .success(_):
                        if let data = response.result.value{
                            success(data.parseJSONString as AnyObject?)
                        }
                    case .failure(_):
                        failure(response.result.error! as NSError)
                    }
                })
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                failure(error as NSError)
            }
           }
        }
        
        //Headers
        func GetHeaders() -> HTTPHeaders {
            var httpHeaders: HTTPHeaders = HTTPHeaders()
            var headers: HTTPHeaders{
                var  value: [String : String] =   [:]
                value["app-id"] = APIConstants.AppId
                return value
            }
            return headers
        }
        
        
        func UploadFileByURI(withApi api:API,  fileURL : URL , fileNamePrefix: String ,success : @escaping HttpClientSuccess, failure: @escaping HttpClientFailure)
        {
            var headers: HTTPHeaders  = self.GetHeaders()
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
            if( fileURL != nil  ){
                multipartFormData.append(fileURL, withName: fileNamePrefix, fileName: String(Date().timeIntervalSince1970) + "." + fileURL.pathExtension, mimeType:  fileURL.pathExtension )
            }
                
            if api.parameters != nil {
            for (key, value) in api.parameters!{
                let stringValue = value as? String ?? ""
                multipartFormData.append(stringValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            }

        }, usingThreshold: UInt64.init(), to: api.url(), method: .post,headers: headers
        ) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseString(completionHandler: { (response:DataResponse<String>)  in
                    switch(response.result) {
                    case .success(_):
                        if let data = response.result.value{
                            success(data.parseJSONString as AnyObject?)
                        }
                    case .failure(_):
                        failure(response.result.error! as NSError)
                    }
                })
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                failure(error as NSError)
            }
           }
        }
        
        
        func UploadFileByURIs(withApi api:API,  fileURL : [URL] , fileNamePrefix: String ,success : @escaping HttpClientSuccess, failure: @escaping HttpClientFailure)
        {
            var headers: HTTPHeaders  = self.GetHeaders()
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
            if( fileURL != nil  ){
                
                var index : Int = 0
                for uri in fileURL {
                    multipartFormData.append( uri, withName: "files[\(index)]", fileName: String(Date().timeIntervalSince1970) + "." + uri.pathExtension, mimeType:  uri.pathExtension )
                    index = index + 1
                }

            }
                
            if api.parameters != nil {
            for (key, value) in api.parameters!{
                let stringValue = value as? String ?? ""
                multipartFormData.append(stringValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            }

        }, usingThreshold: UInt64.init(), to: api.url(), method: .post,headers: headers
        ) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseString(completionHandler: { (response:DataResponse<String>)  in
                    switch(response.result) {
                    case .success(_):
                        if let data = response.result.value{
                            success(data.parseJSONString as AnyObject?)
                        }
                    case .failure(_):
                        failure(response.result.error! as NSError)
                    }
                })
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                failure(error as NSError)
            }
           }
     }
     
        func UploadMultipleImages(withApi api:API, images:[UIImage], success : @escaping HttpClientSuccess, failure: @escaping HttpClientFailure)
        {

            var headers: HTTPHeaders  = self.GetHeaders()
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                var i = 0
                for image in images {
                    let imageData = image.compressedData()
                    multipartFormData.append(imageData ?? Data(), withName: "files[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                    i += 1
                }
                if api.parameters != nil {
                    var stringValue = ""
                    for (key, value) in api.parameters!{
                        if let intValue = value as? Int {
                            stringValue = String(intValue)
                        } else {
                            stringValue = value as? String ?? ""
                        }
                        multipartFormData.append(stringValue.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
            }, to: api.url(), headers: headers,

                encodingCompletion: { encodingResult in
                    
                    switch encodingResult{
                    case .success(let upload, _, _ ):
                        
                        print(upload)
                        print(encodingResult)
                        
                        upload.uploadProgress(closure: { (Progress) in
                            print("Upload Progress: \(Progress.fractionCompleted)")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UploadProgress"), object: nil, userInfo: ["progress": Progress.fractionCompleted])

                        })
                        upload.responseString(completionHandler: { (response:DataResponse<String>)  in
                            switch(response.result) {
                            case .success(_):
                                if let data = response.result.value{
                                    success(data.parseJSONString as AnyObject?)
                                }
                            case .failure(_):
                                failure(response.result.error! as NSError)
                            }
                        })
                    case .failure(let error):
                        print("Error in upload: \(error.localizedDescription)")
                        failure(error as NSError)
                    }
                    
            })
        }
     
        
        
        
}


