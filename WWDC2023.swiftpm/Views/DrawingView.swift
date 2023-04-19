//
//  DrawingView.swift
//  enChanting
//
//  Created by Eric Prasetya Sentosa on 20/04/23.
//

import SwiftUI
import PencilKit

struct DrawingView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var isDraw: Bool
    @Binding var type: PKInkingTool.InkType
    @Binding var color: Color
    @Binding var strokeCount: Int
    @ObservedObject var viewModel: ViewModel
    //updating ink type
    var ink : PKInkingTool{
        PKInkingTool(type, color: UIColor(color), width: 10)
    }
    let eraser = PKEraserTool(.vector)
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.tool = isDraw ? ink : eraser
        canvas.backgroundColor = .clear
        canvas.delegate = context.coordinator
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // updating tool when ever main view updates
        uiView.tool = isDraw ? ink : eraser
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        let parent: DrawingView
        
        init(_ parent: DrawingView) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.strokeCount = canvasView.drawing.strokes.count
            print("Number of strokes: \(parent.strokeCount)")
            if parent.strokeCount == 4 {
                parent.viewModel.strokeIsFour = true
            } else {
                parent.viewModel.strokeIsFour = false
            }
        }
    }

}
