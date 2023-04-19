//
//  DraggableCanting.swift
//  WWDC2023
//
//  Created by Eric Prasetya Sentosa on 19/04/23.
//

import SwiftUI

struct DraggableCanting<Draggable: Gesture>: View {
    @Binding var color: Color
    private let size: CGFloat = 70
    let position: CGPoint
    let gesture: Draggable
    var body: some View {
        ZStack{
            Image("canting")
                .resizable()
                .scaledToFit()
                .frame(width: size)
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
                .offset(x: -18, y: -25)
        }
        .position(position)
        .gesture(gesture)
    }
}
