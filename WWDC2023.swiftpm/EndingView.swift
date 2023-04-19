//
//  EndingView.swift
//  WWDC2023
//
//  Created by Eric Prasetya Sentosa on 18/04/23.
//

import SwiftUI

struct EndingView: View {
    
    @State var textIndex = 0
    @State var chatBubbleHeight:CGFloat = 400
    @State var offsetX: CGFloat = 650
    var imageNames = [
        "batik-kawung",
        "batik-news",
        "batik-process"
    ]
    var texts = [
        "The batik that we have just made is called __batik kawung__. Each batik pattern has its own meaning and philosophy. Kawung batik is a batik motif that is shaped like a circle, similar to the fruit of the kawung palm, arranged in a neat geometric pattern. The kawung motif symbolizes __perfection, purity, and sanctity__. This batik pattern was first introduced in the 13th century, specifically on the island of __Java__.\n(source: budaya.jogjaprov.go.id)",
        "Batik is considered an important cultural icon in Indonesia. Indonesian people wear batik as casual and formal clothing that can be used in various events. At the **G20 Summit** which was held last November 2022, Indonesia hosted the event and provided batik to be used as souvenirs and worn by world leaders attending the Welcoming Dinner.\n(source: kompasiana.com)",
        "**UNESCO** has designated the Indonesian Batik as a **Masterpiece of the Oral and Intangible Heritage of Humanity** since 2 October 2009. Since then, 2 October has been designated as National Batik Day in Indonesia.\n(source: budaya.jogjaprov.go.id)"
    ]
    
    var body: some View {
        HStack(spacing: 50){
            Image(imageNames[textIndex])
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 400)
                .offset(x: -offsetX)
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(0.5), value: offsetX)
            ZStack {
                ChatBubble(height: $chatBubbleHeight)
                    .frame(width: 300)
                VStack{
                    Text(.init(texts[textIndex]))
                        .multilineTextAlignment(.center)
                        .padding(.top, 50)
                        .font(.system(size: 14))
                    Spacer()
                }
                .frame(width: 250, height: 400)
                
                VStack() {
                    Spacer()
                    HStack{
                        Spacer()
                        Button {
                            if textIndex > 0 {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)) {
                                    textIndex -= 1
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button {
                            if textIndex < texts.count-1 {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)) {
                                    textIndex += 1
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.bottom, 60)
                    .padding(.trailing, 10)
                }
                .frame(width: 250, height: 400)
            }
            .offset(x: offsetX)
            .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(1), value: offsetX)
        }
        .onAppear {
            offsetX = 0
        }
    }
}

struct EndingView_Previews: PreviewProvider {
    static var previews: some View {
        EndingView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
