//
//  StrokeView.swift
//  enChanting
//
//  Created by Eric Prasetya Sentosa on 20/04/23.
//

import SwiftUI
import PencilKit

struct StrokeView: View {
    @ObservedObject var viewModel: ViewModel
    var stroke: PKStroke
    @Binding var strokeFill: Color
    @Binding var isHighlighted: Bool
    var index: Int
    var body: some View {
        ZStack{
            PKStrokeShape(stroke: stroke)
                .fill(strokeFill)
            PKStrokeShape(stroke: stroke)
                .stroke(viewModel.strokeColor, lineWidth: 5)
                .shadow(color: .green, radius: isHighlighted ? 25 : 0)
                .background (
                    GeometryReader { proxy -> Color in
                        viewModel.update(frame: proxy.frame(in: .global), for: index)
                        return Color.clear
                    }
                )
        }
    }
}
