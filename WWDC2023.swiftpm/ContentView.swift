import SwiftUI
import PencilKit
import AVKit

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State var offsetX: CGFloat = 400
    @State var offsetY: CGFloat = 600
    @State var chatBubbleHeight: CGFloat = 300
    @State var chatBubbleOffsetY: CGFloat = -150
    @State var bgMusic: AVAudioPlayer?
    @State var fillColor = false
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
            BackgroundView(offsetX: $offsetX, offsetY: $offsetY)
            //chat view
            VStack {
                Spacer()
                HStack{
                    Image(viewModel.chatIndex == 0 ? "memoji-hello" :  viewModel.chatIndex == 8 ? "memoji-thanks" : "memoji-chat")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .zIndex(3)
                        .offset(y: offsetY)
                        .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(1.5), value: offsetY)
                        .animation(.spring(), value: viewModel.chatIndex)
                    
                    ZStack {
                        ChatBubbleView(height: $chatBubbleHeight)
                        VStack (alignment: .leading) {
                            Text(.init(viewModel.currentChat!.title))
                                .bold()
                                .font(.system(size: 22))
                            Text(.init(viewModel.currentChat!.desc))
                                .font(.system(size: 18))
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
                                            withAnimation(.spring()) {
                                                chatBubbleHeight = 200
                                                chatBubbleOffsetY = 50
                                            }
                                        }
                                        
                                        if viewModel.chatIndex == 5 {
                                            viewModel.showNextButton.toggle()
                                        }
                                        if viewModel.chatIndex == 7 {
                                            withAnimation(.spring()) {
                                                viewModel.isTimerShown = false
                                                viewModel.strokeColor = .white
                                                viewModel.batikFabricPosition = CGPoint(
                                                    x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY
                                                )
                                                viewModel.fabricScale = 1
                                            }
                                        }
                                        if viewModel.chatIndex == 8 {
                                            viewModel.showNextButton.toggle()
                                        }
                                    } label: {
                                        Text("Next")
                                            .font(.title)
                                            .padding(5)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .padding(.bottom, 20)
                                    .padding(.trailing, 30)
                                    .disabled(viewModel.strokeIsFour == false && viewModel.chatIndex == 3)
                                }
                            }
                        }
                    }
                    .frame(width: 600, height: chatBubbleHeight)
                    .offset(x: -20, y: chatBubbleOffsetY)
                    
                    .offset(y: offsetY)
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(2), value: offsetY)
                    Spacer()
                }
            }
            
            if viewModel.chatIndex >= 3 && viewModel.chatIndex <= 7{
                ProcessView(viewModel: viewModel)
                    .offset(y:-30)
            }
            
            if viewModel.chatIndex > 7 {
                EndingView()
                    .offset(y: -30)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            offsetX = 0
            offsetY = 0
            playSound()
        }
        
    }
    
    //playaudio
    func playSound() {
        guard let url = Bundle.main.url(forResource: "bg-music", withExtension: "mp3")
        else {
            return
        }
        do {
            bgMusic = try AVAudioPlayer(contentsOf: url)
            bgMusic?.numberOfLoops = -1
            bgMusic?.play()
            bgMusic?.setVolume(0.2, fadeDuration: 0.5)
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
