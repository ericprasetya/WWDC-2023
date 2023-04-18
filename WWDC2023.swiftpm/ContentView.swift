import SwiftUI
import PencilKit

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State var offsetX: CGFloat = 400
    @State var offsetY: CGFloat = 300
    
    @State var chatTitle = "Hi! Welcome to enCanting"
    @State var chat = "This is an interactive app that helps you to understand the creation process of Batik from Indonesia"
    @State var chatBubbleHeight: CGFloat = 300
    @State var chatBubbleOffsetY: CGFloat = -150
    
    @State var fillColor = false
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
            
            //ornament behind + logo
            VStack{
                HStack{
                    Image("ornament-left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350)
                        .offset(x: -offsetX, y: -offsetY)
                    Spacer()
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350)
                        
                    
                    Spacer()
                    Image("ornament-right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350)
                        .offset(x: offsetX, y: -offsetY)
                }
                Spacer()
                HStack{
                    Image("cloud-left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350)
                        .offset(x: -offsetX, y: offsetY)
                    
                    Spacer()
                    Image("cloud-right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350)
                        .offset(x: offsetX, y: offsetY)
                }
            }
            
            //chat view
            VStack {
                Spacer()
                HStack{
                    Image(viewModel.chatIndex == 0 ? "memoji-hello" : "memoji-chat")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350)
                    
                    
                    ZStack {
                        Image("chat-bubble")
                            .resizable()
                        VStack (alignment: .leading) {
                            Text(viewModel.currentChat!.title)
                                .bold()
                            Text(viewModel.currentChat!.desc)
                            HStack{
                                Spacer()
                                Image("canting")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .scaleEffect(viewModel.chatIndex == 1 ? 1 : 0)
                                    .animation(.default, value: viewModel.chatIndex)
                                    .offset(y: -30)
                            }
                            Spacer()
                        }
                        .font(.title2)
                        .padding(.top, 30)
                        .padding(.horizontal, 50)
                        .multilineTextAlignment(.leading)
                        
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                
                                //button next
                                if viewModel.showNextButton {
                                    Button {
                                        viewModel.nextChat()
                                        if viewModel.chatIndex == 3 {
                                            withAnimation {
                                                chatBubbleHeight = 200
                                                chatBubbleOffsetY = 50
                                            }
                                        }
                                        
//                                        if viewModel.chatIndex == 4 {
//                                            
//                                        }
                                        
                                        if viewModel.chatIndex == 5 {
                                            viewModel.showNextButton.toggle()
                                        }
                                        if viewModel.chatIndex == 7 {
                                            withAnimation {
                                                viewModel.isTimerShown = false
                                                viewModel.strokeColor = .white
                                                viewModel.batikFabricPosition = CGPoint(
                                                    x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY
                                                )
                                                viewModel.fabricScale = 1
                                            }
                                        }
                                    } label: {
                                        Text("Next")
                                            .font(.title)
                                            .padding(5)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .padding(.bottom, 20)
                                    .padding(.trailing, 30)
                                }
                                
                            }
                        }
                    }
                    .frame(width: 600, height: chatBubbleHeight)
                    .offset(x: -70, y: chatBubbleOffsetY)
                    
                    Spacer()
                }
            }
            
            if viewModel.chatIndex >= 3 && viewModel.chatIndex <= 7{
                DrawingScene(viewModel: viewModel)
                    .offset(y:-30)
            }
            
            if viewModel.chatIndex > 7 {
                
            }
            
            
            
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation {
                offsetX = 0
                offsetY = 0
            }
        }
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
