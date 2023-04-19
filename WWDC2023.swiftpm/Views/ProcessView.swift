//
//  ProcessView.swift
//  WWDC2023
//
//  Created by Eric Prasetya Sentosa on 17/04/23.
//

import SwiftUI
import PencilKit

struct ProcessView: View {
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
                                            viewModel.showNextButton = true
                                        }
                                    }
                            }
                            
                            Image(viewModel.isTimerShown ? "cauldron-fabric" : "cauldron")
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

