//
//  CardView.swift
//  Set Game
//
//  Created by mixemer on 3/23/22.
//

import SwiftUI

struct CardView: View {
    let card: SetGameModel.Card
    
    var body: some View {        
        GeometryReader { geo in
            let frameMaxWidth: CGFloat = geo.size.width * 0.2
            
            HStack {
                ForEach(1...card.number, id: \.self) {_ in
                    if card.shading == .solid {
                        getShape()
                    } else if card.shading == .open {
                        getShape().stroke(lineWidth: 2)
                    } else {
                        getShape()
                            .background(getShape().stroke(lineWidth: 5))
                            .opacity(0.3)
                    }
                }
                .frame(maxWidth: frameMaxWidth, maxHeight: geo.size.height * 0.8)
            }
            .cardify(isFaceUp: card.isFaceUp, highlignBorder: card.isSelected)
            .foregroundColor(getColor())
            .shadow(radius: card.isHinted ? 10 : 0)
        }
        .aspectRatio(3/2, contentMode: .fit)
    }
    
    private func getShape() -> some Shape {
        if card.shape == .squiggle {
            return AnyShape(Ellipse())
        } else if card.shape == .rect {
            return AnyShape(Rectangle())
        } else {
            return AnyShape(Diamond())
        }
    }
    
    private func getColor() -> Color {
        var color = Color.red
        
        switch card.color {
        case .red:
            color = .red
        case .green:
            color = .green
        case .purble:
            color = .purple
        }
        
        return color
    }
}

struct AnyShape: Shape {
    init<S: Shape>(_ wrapped: S) {
        _path = { rect in
            let path = wrapped.path(in: rect)
            return path
        }
    }

    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }

    private let _path: (CGRect) -> Path
}

struct CardView_Previews: PreviewProvider {
    static let card = SetGameModel.Card(color: .purble, shape: .rect, shading: .shaded, number: 2, id: 0)
    static var previews: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
            CardView(card: card)
        }
    }
}
