//  SocketManager.swift
//  HttpWrappers
//  Created by Mashhood Qadeer on 15/03/2021.

import Foundation
import UIKit
import SocketIO

typealias GetSocketCompletion = ([[String : Any]]) -> ()
typealias GetGenericCompletion = ([String : Any]) -> ()
typealias SendSocketCompletion = () -> ()

class IOSocket: NSObject {
    
    //API End Points
    var new_message_receive = "new_message_receive"
    var new_message_send = "new_message_send"
    
    
    let manager = SocketManager(socketURL: URL(string: APIConstants.SocketURL )!, config: [.log(true), .compress])
    
    var socket : SocketIOClient?
    
    static let sharedInstance = IOSocket()
    
    override init() {}
    
    func ListenToSocket(on SocketName: String, with completion: @escaping GetGenericCompletion){
        socket?.on(SocketName) {data, ack in
            let rsp_dt = data.first as? [String : Any] ?? [:]
            completion(rsp_dt)
        }
    }
    
    func ListenToSocketWithArrResponse(on SocketName: String, with completion: @escaping GetSocketCompletion){
        socket?.on(SocketName) {data, ack in
            let rsp_dt = data as? [[String : Any]] ?? []
            completion(rsp_dt)
        }
    }
    
    func connectToSocket(on SocketName: String, withParm parm : [String : Any] ,having completion: @escaping SendSocketCompletion){
        socket?.emit(SocketName, parm)
        completion()
    }
    
    func GetMessages(completion: @escaping GetSocketCompletion) {
        socket?.on(new_message_receive) {data, ack in
            let rsp_dt = data as! [[String : Any]]
            completion(rsp_dt)
        }
    }
    
    func Send( withParm parm : [String : AnyObject] , completion: @escaping SendSocketCompletion )  {
        socket?.emit(new_message_send, parm)
        completion()
    }
    
    func disconnect(){
        socket?.disconnect()
    }
    
    func connect(){
        socket = self.manager.defaultSocket
        socket?.connect()
    }
    
}


