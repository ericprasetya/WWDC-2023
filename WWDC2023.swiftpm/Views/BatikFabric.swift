//
//  BatikFabric.swift
//  enChanting
//
//  Created by Eric Prasetya Sentosa on 20/04/23.
//

import SwiftUI
import PencilKit


struct BatikFabric: View {
    @ObservedObject var viewModel: ViewModel
    var canvas: PKCanvasView
    @Binding var strokeFill: Color
    @Binding var isHighlighted: Bool
    var body: some View {
        let rows = 4
        let columns = 4
        let gridItemSize = 400 / CGFloat(rows)
        VStack(spacing: 0) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<columns, id: \.self) { column in
                        ConvertDrawingView(viewModel: viewModel, drawing: canvas.drawing, strokeFill: $strokeFill, isHighlighted: $isHighlighted)
                            .frame(width: gridItemSize, height: gridItemSize)
                            .scaleEffect(0.25)
                    }
                }
            }
            .offset(x: -40, y: -40)
        }
        .background(Color(hex: "#87481C"))
        .frame(width: 400, height: 400)
        .border(Color.black)
    }
}
