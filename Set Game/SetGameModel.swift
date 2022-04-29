//
//  SetGameModel.swift
//  Set Game
//
//  Created by mixemer on 3/23/22.
//

/**
 atributes of the cards
 shape: oval, squiqly,  Diamond
 color: red, green, purple
 shading/fill: solid, open, shaded
 count: 1, 2, 3
 
 rules:
 all features has to be same
 or all has to be different
 
 https://www.setgame.com/sites/default/files/instructions/SET%20INSTRUCTIONS%20-%20ENGLISH.pdf
 */

import Foundation

struct SetGameModel {
    private(set) var deck: [Card]
    private(set) var openCards: [Card]
    private(set) var discardedCards: [Card]
    
    private(set) var score = 0
    static let startingNumberOfCards = 12
    
    var selectedCards: [Int] {
        openCards.indices.filter({ openCards[$0].isSelected })
    }
    
    init() {
        deck = []
        openCards = []
        discardedCards = []
        
        populateTheDeck()
        // deck.shuffle()
        
        //drawCardFromDeck(SetGameModel.startingNumberOfCards)
    }
    
    // how may selected?
    // if 3 is selected and then check if they match?
    // if not match, next time select, unselect the seclted
    // if match, mark as matched.
    mutating func select(_ card: Card) {
        if let chosenIndex = openCards.firstIndex(where: { $0.id == card.id }) {
            openCards[chosenIndex].isSelected.toggle()
            
            let selectedCardCount = selectedCards.count
            
            if selectedCardCount == 3 {
                if let (card1Index, card2Index, card3Index) = getSelectedCardsIndex() {
                    let card1 = openCards[card1Index]
                    let card2 = openCards[card2Index]
                    let card3 = openCards[card3Index]
                    
                    if (card1.isCardsMatch(card2) == card1.isCardsMatch(card3) && card1.isCardsMatch(card2) == card2.isCardsMatch(card3)) {
                        // delete and add discarded
                        
                        discardedCards.append(contentsOf: [setUpCardForDiscarded(card1), setUpCardForDiscarded(card2), setUpCardForDiscarded(card3)])

                        openCards.remove(at: openCards.firstIndex{ $0.id == card1.id }!)
                        openCards.remove(at: openCards.firstIndex{ $0.id == card2.id }!)
                        openCards.remove(at: openCards.firstIndex{ $0.id == card3.id }!)

                        score += 3
                    } else {
                        deselectAllCards()
                        openCards[chosenIndex].isSelected.toggle()
                        if (score > 0) { score -= 1 }
                    }
                    
                }
            }
        }
    }
    
    private func setUpCardForDiscarded(_ card: Card) -> Card {
        return Card(isSelected: false, isMatched: true, isHinted: false, isFaceUp: false, color: card.color, shape: card.shape, shading: card.shading, number: card.number, id: card.id)
    }
    
    private func getSelectedCardsIndex() -> (Int, Int, Int)? {
        let cardIndex = selectedCards
        if cardIndex.count != 3 {
            return nil
        }
        
        return (cardIndex[0], cardIndex[1], cardIndex[2])
    }
    
    mutating func setCardsHint(_ cards: (Int, Int, Int), to hint: Bool) {
        openCards.indices.forEach {
            if openCards[$0].id == cards.0 || openCards[$0].id == cards.1 || openCards[$0].id == cards.2 {
                openCards[$0].isHinted = hint
            }
        }
    }
    
    mutating func deselectAllCards() {
        openCards.indices.forEach({ openCards[$0].isSelected = false })
    }
    
    mutating func drawCardFromDeck(_ number: Int) {
        for _ in 0..<number {
            if (deck.isEmpty) {
                break
            }
            
            let index = 0
            deck[index].isFaceUp = true
            let card = deck[index]
            deck.remove(at: index)
            openCards.append(card)
        }
    }
    
    mutating func populateTheDeck() {
        var count = 0
        for shape in Shape.allCases {
            for shade in Shading.allCases {
                for number in 1...3 {
                    for color in Color.allCases {
                        let card = Card(color: color, shape: shape, shading: shade, number: number, id: count)
                        deck.append(card)
                        count += 1
                    }
                }
            }
        }
    }
    
    enum Shape: CaseIterable {
        case squiggle, rect, diamond
    }
    enum Shading: CaseIterable  {
        case solid, open, shaded
    }
    enum Color: CaseIterable  {
        case red, green, purble
    }
    
    struct Card: Identifiable {
        var isSelected = false
        var isMatched = false
        var isHinted = false
        var isFaceUp = false
        
        let color: Color
        let shape: Shape
        let shading: Shading
        let number: Int // can only be 1-2-3 -- could use enum to enforce
        
        let id: Int
        
        // all features has to be same
        // or all has to be different
        func isCardsMatch(_ other: Card) -> (Bool, Bool, Bool, Bool){
            return (color == other.color, shape == other.shape, shading == other.shading, number == other.number);
        }
        
        mutating func setUpForDiscarded() {
            isSelected = false
            isMatched = true
            isHinted = false
            isFaceUp = false
        }
    }
}
