//
//  ViewModel.swift
//  WWDC2023
//
//  Created by Eric Prasetya Sentosa on 17/04/23.
//


import SwiftUI

class ViewModel: ObservableObject {
    // MARK: - Gesture properties
    @Published var currentToy: CircleColored?
    @Published var currentPosition = initialPosition
    @Published var highlightedId: Int?
    @Published var draggableToyOpacity: CGFloat = 1.0
    @Published var isGameOver = false
    private(set) var attempts = 0
    
    // MARK: - Coordinates
    private static let initialPosition = CGPoint(
        x: UIScreen.main.bounds.midX + 200, y: UIScreen.main.bounds.midY - 150
    )
    
    var frames: [Int: CGRect] = [:]
    
    // MARK: - Objects in the screen
    private var toys = Array(CircleColored.all.shuffled().prefix(upTo: 3))
    var toyContainers = CircleColored.all
    
    // MARK: - Updates in the screen
    func update(frame: CGRect, for id: Int) {
        frames[id] = frame
    }
    
    // MARK: - game lifecycle
    func setupGame() {
        currentToy = toys.popLast()
    }
    
    func nextRound() {
        currentToy = toys.popLast()
        
        if currentToy == nil {
            gameOver()
        } else {
            prepareObjects()
        }
    }
    
    func gameOver() {
        isGameOver = true
    }
    
    func prepareObjects() {
        withAnimation{
            toyContainers.shuffle()
        }
        
        withAnimation(.none) {
            resetPosition()
            withAnimation {
                draggableToyOpacity = 1.0
            }
        }
    }
    
    func generateNewGame() {
        toys = Array(CircleColored.all.shuffled().prefix(upTo: 3))
        attempts = 0
        nextRound()
    }
    
    func update(dragPosition: CGPoint) {
        currentPosition = dragPosition
        for(id, frame) in frames where frame.contains(dragPosition) {
            highlightedId = id
            print("you are touching \(id)")
            return
        }
        highlightedId = nil
    }
    
    func confirmDrop() {
        defer { highlightedId = nil }
        
        guard let highlightedId = highlightedId else {
            resetPosition()
            return
        }
        
        if highlightedId == currentToy?.id {
            guard let frame = frames[highlightedId] else {
                return
            }
            currentPosition = CGPoint(x: frame.midX, y: frame.midY)
            draggableToyOpacity = 0
            nextRound()
        } else {
            resetPosition()
        }
        
        attempts += 1
    }
    
    func resetPosition() {
        currentPosition = ViewModel.initialPosition
    }
    
    func isHighlighted(id: Int) -> Bool {
        highlightedId == id
    }
    
    
    var chats = Chat.all
    var chatIndex = 0
    
    let firstColorPositionInit = CGPoint(x: UIScreen.main.bounds.midX + 200, y: UIScreen.main.bounds.midY - 150)
    @Published var firstColorPosition = CGPoint(x: UIScreen.main.bounds.midX + 200, y: UIScreen.main.bounds.midY - 150)
    
    let secondColorPositionInit = CGPoint(x: UIScreen.main.bounds.midX + 200, y: UIScreen.main.bounds.midY - 50)
    @Published var secondColorPosition = CGPoint(x: UIScreen.main.bounds.midX + 200, y: UIScreen.main.bounds.midY - 50)
    
    let batikFabricPositionInit = CGPoint(x: UIScreen.main.bounds.midX - 200, y: UIScreen.main.bounds.midY)
    @Published var batikFabricPosition = CGPoint(x: UIScreen.main.bounds.midX - 200, y: UIScreen.main.bounds.midY)
    
    let basinPositionInit = CGPoint(x: UIScreen.main.bounds.midX + 200, y: UIScreen.main.bounds.midY)
    
//    @Published var chatIndex = 0
    @Published var strokeColor: Color = .black
    @Published var currentChat = Chat.all.first
    @Published var isTimerShown = false
    @Published var showNextButton = true
    @Published var fabricScale: CGFloat = 1
//    func getStarted() {
//        currentChat = chats[chatIndex]
//    }

    func nextChat() {
        chatIndex += 1
        currentChat = chats[chatIndex]
    }
    
    
    
}
