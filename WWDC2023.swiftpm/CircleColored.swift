//
//  CircleColored.swift
//  WWDC2023
//
//  Created by Eric Prasetya Sentosa on 17/04/23.
//

import SwiftUI

struct CircleColored {
    let id: Int
    let color: Color
}

extension CircleColored {
    static let all = [
        CircleColored(id: 1, color: .red),
        CircleColored(id: 2, color: .blue),
        CircleColored(id: 3, color: .green),
        CircleColored(id: 4, color: .black),
        CircleColored(id: 5, color: .orange),
        CircleColored(id: 6, color: .purple)
    ]
}
