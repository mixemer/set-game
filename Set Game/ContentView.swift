//
//  ContentView.swift
//  Set Game
//
//  Created by mixemer on 3/23/22.
//

import SwiftUI

struct ContentView: View {
    @Namespace var cardNamespace
    @ObservedObject var game: SetGameViewModal
    
    var body: some View {
        VStack {
            titleGroup
            openCardsBody
            
            Spacer()
            HStack {
                deckBody
                discardedCardsBody
            }
            HStack {
                hintButton
                newgameButton
            }
        }
    }
    
    private var openCardsBody: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(game.cards) { card in
                    CardView(card: card)
                        .matchedGeometryEffect(id: card.id, in: cardNamespace)
                        .onTapGesture {
                            withAnimation{
                                game.select(card)
                                
                                if (game.cards.count < 12) {
                                    getMoreCards()
                                }
                            }
                        }
                }
            }
            .padding()
        }
    }
    private var deckBody: some View {
        VStack {
            ZStack {
                ForEach(game.deck) { card in
                    CardView(card: card)
                        .matchedGeometryEffect(id: card.id, in: cardNamespace)
                        .zIndex(-Double(game.deck.firstIndex(where: {$0.id == card.id}) ?? 0))
                        .frame(width: 120, height: 65)
                }
            }
            if game.deck.count > 0 {
                Text("Deck")
            }
        }
        .onTapGesture {
            // TODO: - if there cards that can be matched, disable this 
            getMoreCards()
        }
    }
    
    private func getMoreCards() {
        if game.deck.isEmpty { return }
        
        var cardCount = 3
        if game.deck.count == 81 {
            cardCount = 12
        }
        
        for index in 1...cardCount {
            let maxDur: Double = 2 // must be the same as cardify
            let dur =  Double(index) * (maxDur / Double(cardCount))
            withAnimation(.easeInOut(duration: dur)) {
                game.getOneCard()
            }
        }
    }
    
    private var discardedCardsBody: some View {
        VStack {
            ZStack {
                ForEach(game.discardedCards) { card in
                    CardView(card: card)
                        .matchedGeometryEffect(id: card.id, in: cardNamespace)
                        .zIndex(-Double(game.discardedCards.firstIndex(where: {$0.id == card.id}) ?? 0))
                        .frame(width: 120, height: 65)
                }
            }
            if game.discardedCards.count > 0 {
                Text("Discarded")
            }
        }
    }

    
    private var titleGroup: some View {
        ZStack {
            VStack {
                Text("Set Game")
                    .font(.largeTitle)
                HStack{
                    Text("Score: \(game.score)")
                }
            }
        }
    }
    
    private var hintButton: some View {
        Button(action: {
            game.getHint()
        }, label: {
            Text("Hint: \(game.hintNumber)")
        })
        .buttonStyle(.borderedProminent)
        .disabled(!game.canAskForHint)
    }
    private var newgameButton: some View {
        Button(action: {
            withAnimation {
                game.newGame()
            }
        }, label: {
            Text("New Game")
        })
        .buttonStyle(.borderedProminent)
    }
}
















struct ContentView_Previews: PreviewProvider {
    static let game = SetGameViewModal()
    static var previews: some View {
        ContentView(game: game)
            .previewInterfaceOrientation(.portrait)
    }
}

