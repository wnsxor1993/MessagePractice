//
//  SocketIOManager.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/16.
//

import Foundation
import SocketIO

final class SocketIOManager {
    
    private var manager: SocketManager = .init(socketURL: URL(string: "ws://192.168.0.59:9091")!, config: [.log(true), .compress])
    private var socket: SocketIOClient?
    
    init() {
        self.configureSocket()
    }
    
    func connectSocket() {
        // 설정 주소와 포트로 소켓 연결 시도
        self.socket?.connect()
    }
    
    func disconnectSocket() {
        self.socket?.disconnect()
    }
    
    func sendMessage(with message: String) {
        self.socket?.emit("Event", with: [["userName": "zeto", "message": "\(message)"]])
    }
}

private extension SocketIOManager {
    
    func configureSocket() {
        // socket을 룸 단위로 구분 (기본 룸을 blind로 설정)
        self.socket = self.manager.socket(forNamespace: "/")
        
        guard let socket else { return }
        
        // 이름이 ""로 emit된 이벤트 수신
        socket.on("Event") { dataArray, ack in
            
        }
    }
}
