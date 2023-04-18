//
//  DrawingScene.swift
//  WWDC2023
//
//  Created by Eric Prasetya Sentosa on 17/04/23.
//

import SwiftUI
import PencilKit

struct DrawingScene: View {
    @ObservedObject var viewModel: ViewModel
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var color: Color = .black
    @State var type: PKInkingTool.InkType = .pen
    @State var colorPicker = false
    @State var isHighlighted = false
    
//    let firstColorPositionInit = CGPoint(x: UIScreen.main.bounds.midX + 200, y: UIScreen.main.bounds.midY - 150)
//    @State var firstColorPosition = CGPoint(x: UIScreen.main.bounds.midX + 200, y: UIScreen.main.bounds.midY - 150)
    
//    let secondColorPositionInit = CGPoint(x: UIScreen.main.bounds.midX + 200, y: UIScreen.main.bounds.midY - 50)
//    @State var secondColorPosition = CGPoint(x: UIScreen.main.bounds.midX + 200, y: UIScreen.main.bounds.midY - 50)
    
//    let batikFabricPositionInit = CGPoint(x: UIScreen.main.bounds.midX - 200, y: UIScreen.main.bounds.midY)
//    @State var batikFabricPosition = CGPoint(x: UIScreen.main.bounds.midX - 200, y: UIScreen.main.bounds.midY)
    
//    let basinPositionInit = CGPoint(x: UIScreen.main.bounds.midX + 200, y: UIScreen.main.bounds.midY)
    
    @State var debug = ""
    @State var strokeCount = 0
    @State var strokeFill: Color = .clear
    
//    @State var fabricScale: CGFloat = 1
    
    //for timer
    @State private var timeRemaining = 5
//    @State var isTimerShown = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { state in
                viewModel.update(dragPosition: state.location)
            }
            .onEnded { state in
                viewModel.update(dragPosition: state.location)
                withAnimation {
                    viewModel.confirmDrop()
                }
            }
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
//                                        isTimerShown.toggle()
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
//                                            print(chatIndex)
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
                            
                            Image("basin")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300)
                                .position(viewModel.basinPositionInit)
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
                            DrawingView(canvas: $canvas, isDraw: $isDraw, type: $type, color: $color, strokeCount: $strokeCount)
                        } else if viewModel.chatIndex == 4 {
                            ConvertDrawingView(viewModel: viewModel, drawing: canvas.drawing, strokeFill: $strokeFill, isHighlighted: $isHighlighted)
                            Text(debug)
                        }
                    }
                    .background(.white)
                    .border(.black)
                    .frame(width: 400, height: 400)
                    .padding(.trailing, viewModel.chatIndex == 4 ? 300 : 0)
                    
                    if viewModel.chatIndex == 4 {
                        
                        DraggableCircle(
                            circle: CircleColored(id: 1, color: .yellow),
                            position: viewModel.firstColorPosition,
                            gesture:
                                DragGesture()
                                .onChanged({ state in
                                    viewModel.firstColorPosition = state.location
                                    
                                    for(_, frame) in viewModel.frames where frame.contains(state.location) {
//                                        debug = "you are touching \(id)"
                                        isHighlighted = true
                                        return
                                    }
                                    isHighlighted = false
                                })
                                .onEnded({ state in
                                    viewModel.firstColorPosition = state.location
                                    
                                    for(_, frame) in viewModel.frames where frame.contains(state.location) {
//                                        debug = "you are touching \(id)"
                                        strokeFill = .yellow
                                        isHighlighted = false
                                        viewModel.firstColorPosition = viewModel.firstColorPositionInit
                                        return
                                    }
                                    
                                })
                        )
                        .opacity(viewModel.draggableToyOpacity)
                        .zIndex(2)
                        DraggableCircle(
                            circle: CircleColored(id: 2, color: .red),
                            position: viewModel.secondColorPosition,
                            gesture:
                                DragGesture()
                                .onChanged({ state in
                                    viewModel.secondColorPosition = state.location
                                    
                                    for(_, frame) in viewModel.frames where frame.contains(state.location) {
                                        isHighlighted = true
                                        return
                                    }
                                    isHighlighted = false
                                    
                                    
                                })
                                .onEnded({ state in
                                    viewModel.secondColorPosition = state.location
                                    for(_, frame) in viewModel.frames where frame.contains(state.location) {
                                        strokeFill = .red
                                        isHighlighted = false
                                        viewModel.secondColorPosition = viewModel.secondColorPositionInit
                                        return
                                    }
                                })
                        )
                        .opacity(viewModel.draggableToyOpacity)
                        .zIndex(2)
                    }
                }
                if viewModel.chatIndex == 3 {
                    VStack(alignment: .trailing, spacing: 50) {
                        Button {
                            isDraw = true
                        } label: {
                            Label {
                                Text("Canting")
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
                            } icon: {
                                Image(systemName: "eraser")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                            }
                        }
                        
                        Text("Draw only 4 strokes!")
                            .font(.title)
                        Text("Stroke count: \(strokeCount)")
                            .font(.subheadline)
                    }
                }
            }
            
        }
    }
    
    func saveImage() {
        // getting image from canvas...
        let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
        
        //save to albums...
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

//struct ColloringView: View {
//    @Binding var canvas: PKCanvasView
//    var body: some View{
//        ZStack{
//            Image("batik-colored")
//                .resizable()
//                .scaledToFit()
//                .opacity(0.3)
//            ConvertDrawingView(drawing: canvas.drawing)
//        }
//        .background(.white)
//        .border(.black)
//        .frame(width: 400, height: 400)
//    }
//}

struct DrawingView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var isDraw: Bool
    @Binding var type: PKInkingTool.InkType
    @Binding var color: Color
    @Binding var strokeCount: Int
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
        .background(.brown)
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
/*
struct StrokeView: View {
    @Binding var strokeColor: Color
    @Binding var strokeFill: Color
    
    var body: some View {
        ZStack{
            PKStrokeShape(stroke: stroke)
                .stroke(strokeColor, lineWidth: 5)
            PKStrokeShape(stroke: stroke)
                .fill(strokeFill)
                .background (
                    GeometryReader { proxy -> Color in
                        viewModel.update(frame: proxy.frame(in: .global), for: index)
                        return Color.clear
                    }
                )
        }
    }
}
 */
struct ConvertDrawingView: View {
    @ObservedObject var viewModel: ViewModel
    var drawing: PKDrawing
    @Binding var strokeFill: Color
    @Binding var isHighlighted: Bool
    @State private var xOffset: CGFloat = 0
    
    //var shapeDict: [StrokeView] = [StrokeView(strokeColor: Color.black, strokeFill: Color.clear)]
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<drawing.strokes.count, id: \.self) { index in
                let stroke = drawing.strokes[index]
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
    }
}

//struct DrawingScene_Previews: PreviewProvider {
//    static var previews: some View {
//        DrawingScene()
//            .previewInterfaceOrientation(.landscapeRight)
//    }
//}
