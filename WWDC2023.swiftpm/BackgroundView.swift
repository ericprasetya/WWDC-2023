//
//  BackgroundView.swift
//  WWDC2023
//
//  Created by Eric Prasetya Sentosa on 20/04/23.
//

import SwiftUI

struct BackgroundView: View {
    @Binding var offsetX: CGFloat
    @Binding var offsetY: CGFloat
    var body: some View {
        VStack{
            HStack{
                Image("ornament-left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)
                    .offset(x: -offsetX, y: -offsetY)
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5), value: offsetX)
                Spacer()
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)
                    .offset(y: -offsetY)
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(1), value: offsetY)
                    
                
                Spacer()
                Image("ornament-right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)
                    .offset(x: offsetX, y: -offsetY)
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(0.4), value: offsetX)
            }
            Spacer()
            HStack{
                Image("cloud-left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)
                    .offset(x: -offsetX, y: offsetY)
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(0.8), value: offsetX)
                
                Spacer()
                Image("cloud-right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)
                    .offset(x: offsetX, y: offsetY)
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(0.6), value: offsetX)
            }
        }
    }
}
