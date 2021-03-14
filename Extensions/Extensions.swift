//  Extensions.swift
//  HttpWrappers
//  Created by Mashhood Qadeer on 14/03/2021.

import Foundation
import UIKit

protocol StringType { var get: String { get } }
extension String: StringType { var get: String { return self } }
extension Optional where Wrapped: StringType {
    func unwrap() -> String {
        return self?.get ?? ""
    }
}

extension String {

    func RemoveSpace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    var parseJSONString: AnyObject? {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)

        if let jsonData = data {
            do{
                if let json = try (JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary){
                        return json
                }else{
                let json = try (JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray)
                        return json
                }
                
            }catch{
                print("Error")
            }
            
        } else {
            return nil
        }
        
        return nil
}
    
    var parseJSONStringArray: AnyObject? {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let json:NSArray
        
        if let jsonData = data {
            do{
                json  = try  JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)  as! NSArray
                
                return json
            }catch{
                print("Error")
            }
        } else {
            return nil
        }
        return nil
    }
}

extension UIImage{
    public func compressedData(quality: CGFloat = 0.6) -> Data? {
        return self.jpegData(compressionQuality: quality)
    }
}
