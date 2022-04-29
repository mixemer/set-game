//
//  Cardify.swift
//  Set Game
//
//  Created by mixemer on 3/26/22.
//

import SwiftUI

struct Cardify: ViewModifier {
    let isFaceUp: Bool
    let highlignBorder: Bool
    
    @State var rotation: Double = 180
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 10)
            if rotation < 90 {
                shape.foregroundColor(.white)
                shape.strokeBorder(lineWidth: highlignBorder ? 4 : 1)
            } else {
                shape
            }
            content.opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(.degrees(rotation), axis: (x: 1, y: 0, z: 0))
        .onAppear {
            if isFaceUp {
                withAnimation(.linear.delay(2)) {
                    rotation = 0
                }
            }
        }
        .onDisappear {
            rotation = 180
        }
    }
}

extension View {
    func cardify(isFaceUp: Bool, highlignBorder: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, highlignBorder: highlignBorder))
    }
}
