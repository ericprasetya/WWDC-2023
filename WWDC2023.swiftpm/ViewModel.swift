//
//  ViewModel.swift
//  WWDC2023
//
//  Created by Eric Prasetya Sentosa on 17/04/23.
//


import SwiftUI

class ViewModel: ObservableObject {
    // MARK: - Gesture properties
    @Published var draggableCantingOpacity: CGFloat = 1.0
    @Published var strokeColor: Color = .black
    @Published var fabricScale: CGFloat = 1
    
    
    // MARK: - Validation properties
    @Published var isTimerShown = false
    @Published var showNextButton = true
    @Published var strokeIsFour = false
    
    // MARK: - Objects in the screen
    @Published var currentChat = Chat.all.first
    var chats = Chat.all
    var chatIndex = 0
    
    // MARK: - Updates in the screen
    func update(frame: CGRect, for id: Int) {
        frames[id] = frame
    }
    
    // MARK: - Objects Coordinates
    var cantingColorPositionInit = CGPoint(x: UIScreen.main.bounds.midX + 200, y: UIScreen.main.bounds.midY)
    @Published var cantingColorPosition = CGPoint(x: UIScreen.main.bounds.midX + 200, y: UIScreen.main.bounds.midY)
    
    var batikFabricPositionInit = CGPoint(x: UIScreen.main.bounds.midX - 200, y: UIScreen.main.bounds.midY)
    @Published var batikFabricPosition = CGPoint(x: UIScreen.main.bounds.midX - 200, y: UIScreen.main.bounds.midY)
    
    var basinPositionInit = CGPoint(x: UIScreen.main.bounds.midX + 200, y: UIScreen.main.bounds.midY)
    
    var frames: [Int: CGRect] = [:]
    
    func initCantingPosition() {
         cantingColorPositionInit = CGPoint(x: UIScreen.main.bounds.midX + 200, y: UIScreen.main.bounds.midY)
        cantingColorPosition = cantingColorPositionInit
    }
    
    func initBasinPosition() {
         basinPositionInit = CGPoint(x: UIScreen.main.bounds.midX + 200, y: UIScreen.main.bounds.midY)
        
    }
    
    func initBatikFabricPosition() {
         batikFabricPositionInit = CGPoint(x: UIScreen.main.bounds.midX - 200, y: UIScreen.main.bounds.midY)
        batikFabricPosition = batikFabricPositionInit
    }
    
    func nextChat() {
        if chatIndex < 8 {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)) {
                chatIndex += 1
                currentChat = chats[chatIndex]                
            }
        }
    }
    
}
