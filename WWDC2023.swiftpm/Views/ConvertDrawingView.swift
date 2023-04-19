//
//  ConvertDrawingView.swift
//  enChanting
//
//  Created by Eric Prasetya Sentosa on 20/04/23.
//

import SwiftUI
import PencilKit

struct ConvertDrawingView: View {
    @ObservedObject var viewModel: ViewModel
    var drawing: PKDrawing
    @Binding var strokeFill: Color
    @Binding var isHighlighted: Bool
    @State private var xOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<drawing.strokes.count, id: \.self) { index in
                let stroke = drawing.strokes[index]
                StrokeView(viewModel: viewModel, stroke: stroke, strokeFill: $strokeFill, isHighlighted: $isHighlighted, index: index)
            }
        }
    }
}

