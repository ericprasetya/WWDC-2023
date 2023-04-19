//
//  DrawingSceneView.swift
//  WWDC2023
//
//  Created by Eric Prasetya Sentosa on 17/04/23.
//

import SwiftUI
import PencilKit

struct DrawingSceneView: View {
    @ObservedObject var viewModel: ViewModel
    // for canvas drawing
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var inkColor: Color = .black
    @State var inkType: PKInkingTool.InkType = .pen
    @State var strokeCount = 0
    
    // for batik colloring
    @State var colorPicker: Color = .yellow
    @State var isHighlighted = false
    @State var strokeFill: Color = .clear
    
    // for timer
    @State private var timeRemaining = 5
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Namespace var basin
    
    var drag: some Gesture {

        DragGesture()
        .onChanged({ state in
            viewModel.cantingColorPosition = state.location
            
            for(_, frame) in viewModel.frames where frame.contains(state.location) {
                isHighlighted = true
                return
            }
            isHighlighted = false
        })
        .onEnded({ state in
            viewModel.cantingColorPosition = state.location
            
            for(_, frame) in viewModel.frames where frame.contains(state.location) {
                strokeFill = colorPicker
                isHighlighted = false
                viewModel.cantingColorPosition = viewModel.cantingColorPositionInit
                return
            }
            
        })
    }
    
    var body: some View{
        HStack (spacing: 150) {
            if viewModel.chatIndex > 4 {
                
                ZStack{
                    BatikFabric(viewModel: viewModel, canvas: canvas, strokeFill: $strokeFill, isHighlighted: $isHighlighted)
                        .scaleEffect(viewModel.fabricScale)
                        .position(viewModel.batikFabricPosition)
                        .gesture(
                            DragGesture()
                                .onChanged({ state in
                                    viewModel.batikFabricPosition = state.location
                                    if abs(viewModel.basinPositionInit.x - viewModel.batikFabricPosition.x) < 150 && abs(viewModel.basinPositionInit.y -  viewModel.batikFabricPosition.y) < 150 {
                                        withAnimation {
                                            viewModel.fabricScale = 0.3
                                        }
                                    }
                                    else {
                                        withAnimation {
                                            viewModel.fabricScale = 1
                                        }
                                    }
                                })
                                .onEnded({ state in
                                    if abs(viewModel.basinPositionInit.x - viewModel.batikFabricPosition.x) < 150 && abs(viewModel.basinPositionInit.y -  viewModel.batikFabricPosition.y) < 150 {
                                        withAnimation {
                                            viewModel.fabricScale = 0
                                            viewModel.nextChat()
                                        }
                                        viewModel.isTimerShown.toggle()
                                    }
                                })
                        )
                    
                    if viewModel.chatIndex < 7  {
                        ZStack {
                            if viewModel.isTimerShown {
                                Text(timeRemaining == 0 ? "FINISH" : "\(timeRemaining)")
                                    .font(.largeTitle)
                                    .bold()
                                    .offset(x: -200)
                                    .onReceive(timer) { time in
                                        if timeRemaining > 0 {
                                            timeRemaining -= 1
                                        }
                                        if timeRemaining == 0{
                                            //                                        viewModel.isTimerShown.toggle()
                                            viewModel.showNextButton = true
                                        }
                                    }
                            }
                            
                            Image(viewModel.isTimerShown ? "basin-fabric" : "basin")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300)
                                .position(viewModel.basinPositionInit)
                                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5), value: viewModel.isTimerShown)
                        }
                    }
                    
                }
            } else {
                ZStack{
                    ZStack{
                        Image(viewModel.chatIndex == 4 ? "batik-colored" : "batik-plain")
                            .resizable()
                            .scaledToFit()
                            .opacity(0.3)
                        if viewModel.chatIndex == 3 {
                            DrawingView(canvas: $canvas, isDraw: $isDraw, type: $inkType, color: $inkColor, strokeCount: $strokeCount, viewModel: viewModel)
                        } else if viewModel.chatIndex == 4 {
                            ConvertDrawingView(viewModel: viewModel, drawing: canvas.drawing, strokeFill: $strokeFill, isHighlighted: $isHighlighted)
                        }
                    }
                    .background(.white)
                    .border(.black)
                    .frame(width: 400, height: 400)
                    .padding(.trailing, viewModel.chatIndex == 4 ? 300 : 0)
                    
                    if viewModel.chatIndex == 4 {
                        VStack(alignment: .leading) {
                            ColorPicker(selection: $colorPicker) {
                                Text("Pick Color")
                                    .bold()
                                    .font(.title3)
                            }
                            .padding(.bottom, 20)
                            Text("Drag Canting to the canvas")
                                .bold()
                                .font(.title3)
                        }
                        .frame(width: 200)
                        .offset(x: 200, y: -100)
                            
                        DraggableCanting(
                            color: $colorPicker,
                            position: viewModel.cantingColorPosition,
                            gesture: drag
                        )
                        .opacity(viewModel.draggableCantingOpacity)
                        .zIndex(2)
                    }
                }
                if viewModel.chatIndex == 3 {
                    VStack(alignment: .center, spacing: 50) {
                        Text("Select Your Tool then Draw in Canvas\nUse Apple Pencil For Best Experience")
                        Button {
                            isDraw = true
                        } label: {
                            Label {
                                Text("Canting")
                                    .foregroundColor(.black)
                            } icon: {
                                Image("canting")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70)
                            }
                        }
                        
                        Button {
                            isDraw = false
                        } label: {
                            Label {
                                Text("Eraser")
                                    .foregroundColor(.black)
                            } icon: {
                                Image(systemName: "eraser.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                            }
                        }
                        
                        VStack{
                            Text("Draw follow the batik pattern!")
                                .font(.subheadline)
                                .bold()
                            Text("Stroke count: \(strokeCount)")
                                .font(.subheadline)
                            if viewModel.strokeIsFour == false {
                                Text("Your total stroke is not four!")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            } else {
                                Text("You may continue!")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
            }
        }
        .onAppear{
            viewModel.initBatikFabricPosition()
            viewModel.initBasinPosition()
            viewModel.initCantingPosition()
        }
    }
}

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

struct PKStrokeShape: Shape {
    var stroke: PKStroke

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        var previousPoint: PKStrokePoint?
        for point in stroke.path {
            if let previous = previousPoint {
                let midPoint = CGPoint(x: (previous.location.x + point.location.x) / 2,
                                       y: (previous.location.y + point.location.y) / 2)
                path.addQuadCurve(to: midPoint, control: previous.location)
            } else {
                path.move(to: point.location)
            }
            previousPoint = point
        }
        path.closeSubpath()
        
        return path
    }
}

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

