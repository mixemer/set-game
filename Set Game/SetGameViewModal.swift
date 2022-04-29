//
//  SetGameViewModal.swift
//  Set Game
//
//  Created by mixemer on 3/23/22.
//

import Foundation

class SetGameViewModal: ObservableObject {
    typealias Card = SetGameModel.Card
    
    @Published private(set) var setGame = SetGameModel()
    private(set) var hintedCards: (Int, Int, Int)?
    var canAskForHint: Bool {
        hintNumber > 0
    }
    @Published private(set) var hintNumber = 3
    
    var deck: [Card] {
        setGame.deck
    }
    var cards: [Card] {
        setGame.openCards
    }
    var discardedCards: [Card] {
        setGame.discardedCards
    }
    var score: Int {
        setGame.score
    }
    var ended: Bool {
        discardedCards.count >= setGame.deck.count
    }

    
    // MARK: - Indents
    
    func select(_ card: Card) {
        setGame.select(card)
    }
    func getOneCard() {
        setGame.drawCardFromDeck(1)
    }
    
    func startDeck() {
        setGame.drawCardFromDeck(SetGameModel.startingNumberOfCards)
    }
    
    func getMoreCard() {
        setGame.drawCardFromDeck(3)
    }
    
    func newGame() {
        setGame = SetGameModel()
        hintNumber = 3
    }
    
    /*
     if there is hint, show three indexes or ids of cards that match and then deselect everything
     if no hint, dont do anything
     
      TODO: - what if user is at the bottom and hint is at the top?
     TODO: - optimize this, currently is O(n^3)
     */
    func getHint() {
        if !canAskForHint { return }
        
        for i in cards.indices {
            let card1 = cards[i]
            if (card1.isMatched) { continue }
            
            for j in i..<cards.count {
                let card2 = cards[j]
                if (card2.isMatched) { continue }
                
                for k in j..<cards.count {
                    if i != j && i != k && j != k {
                        let card3 = cards[k]
                        if (card3.isMatched) { continue }
                        
                        if (card1.isCardsMatch(card2) == card1.isCardsMatch(card3) && card1.isCardsMatch(card2) == card2.isCardsMatch(card3)) {
                            hintedCards = (card1.id, card2.id, card3.id)
                            
                            setGame.setCardsHint(hintedCards!, to: true)
                            setGame.deselectAllCards()
                            
                            hintNumber -= 1
                            
                            let delayTime = DispatchTime.now() + 3.0
                               DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                                   self.setGame.setCardsHint(self.hintedCards!, to: false)
                               })
                            
                            return
                        }
                    }
                }
            }
        }
    }
}
