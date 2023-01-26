//
//  WebSocketManager.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/18.
//

import Foundation
import Starscream

final class WebSocketManager {
    
    private var webSocket: WebSocket?
    
    func connect() {
        let urlString = "ws://192.168.0.59:8080"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        self.webSocket = WebSocket(request: request)
        webSocket?.delegate = self
        webSocket?.connect()
    }
    
    func disConnect() {
        webSocket?.disconnect()
        webSocket?.delegate = nil
    }
    
    func sendMessage(_ message: String) {
        self.webSocket?.write(string: message)
    }
}

extension WebSocketManager: WebSocketDelegate {
    
    func websocketDidConnect(socket: Starscream.WebSocketClient) {
        print("Connected")
    }
    
    func websocketDidDisconnect(socket: Starscream.WebSocketClient, error: Error?) {
        print("DisConnected")
    }
    
    func websocketDidReceiveMessage(socket: Starscream.WebSocketClient, text: String) {
        print("Get \(text)")
    }
    
    func websocketDidReceiveData(socket: Starscream.WebSocketClient, data: Data) {
        print("Get Data")
    }
}
