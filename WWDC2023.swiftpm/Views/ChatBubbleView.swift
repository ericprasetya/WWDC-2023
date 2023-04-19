//
//  ChatBubbleView.swift
//  WWDC2023
//
//  Created by Eric Prasetya Sentosa on 18/04/23.
//

import SwiftUI

struct ChatBubbleView: View {
    @Binding var height: CGFloat
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color(hex: "#FFECDB"))
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .stroke(Color(hex: "#BB8663"), lineWidth: 8)
        }
        .frame(height: height - 20)
    }
}

