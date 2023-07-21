//
//  BlackJackView.swift
//  testApp
//
//  Created by lucas gagne on 5/26/23.
//

import SwiftUI

struct BlackJackView: View {
    @State var cards = Array(0...51)
//    @State var cards = Array(0...13)
    @State var playAgain = false

    @State var myCards = [99]
    @State var enemyCards = [99]
    @State var isVisible = true
    @State var minVal = 0
    @State var maxVal = 0
    @State var gameOver = false
    @State var gameStarted = false
    @State var goHome = false
    @State var cardWidth: CGFloat = 65
    @State var cardHeight: CGFloat = 100
    @State var expectedValue = 0
    @State var suggestion = ""
    var body: some View {
        VStack {
            Button("Go home") {
                goHome.toggle()
            }
            Spacer()

            VStack {
    //            ForEach(cards, id: \.self) { int in
    //                Text("card: \(int)")
    //            }
                
                    if gameOver {
                        Text("Game Over")
                        
                        Button("play again") {
                            playAgain.toggle()
                        }
                        
                    }
//                Text("hi")
                if minVal > 0 {
                    Text("Max hand Val (Ace is 11): \(maxVal)")
                }
                if maxVal > 0 {
                    Text("Min hand Val (Ace is 1): \(minVal)")
                }
                
                if gameStarted {
                    Text("juice box")
                    if !gameOver {
                        Text("expected value is \(expectedValue), you should \(suggestion)")
                    }
                    HStack {
                        Spacer()
                        VStack {
                            if gameStarted {
                                //For testing purposes I displayed value of the card below
//                                Text("card: \(enemyCards[1])")
                            }
                            if gameOver == true  {
                                Image("img\(enemyCards[1])").resizable().frame(width: 65, height: 100)
                            }
                            else {
                                Image("backCard").resizable().frame(width: 65, height: 100)
                            }
                            
                        }
                        
                        VStack {
                            

                            if gameStarted {
                                //For testing purposes:
//                                Text("card: \(enemyCards[2])")
                            }
                            if gameOver == true  {
                                Image("img\(enemyCards[2])").resizable().frame(width: 65, height: 100)
                            }
                            else {
                                Image("backCard").resizable().frame(width: 65, height: 100)
                            }
                        }
                        
                        
                        
                        
                        Spacer()
                    }
                }
//                Text("card stack len: \(cards.count)")
                Image("backCard").resizable().frame(width: 65, height: 100).rotationEffect(.degrees(90))
                Button {
                    let cardInd = drawCard(someCards: cards)
                    let drawnCard = cards[cardInd]
                    var vals1 = handleVal(val: drawnCard)
                    myCards.append(drawnCard + 1)
                    cards.remove(at: cardInd)
                    
                    let cardInd2 = drawCard(someCards: cards)
                    let drawnCard2 = cards[cardInd2]
                    let vals2 = handleVal(val: drawnCard2)
                    myCards.append(drawnCard2 + 1)
                    cards.remove(at: cardInd2)
                    
                    let cardInd3 = drawCard(someCards: cards)
                    let drawnCard3 = cards[cardInd3]
                    var vals3 = handleVal(val: drawnCard3)
                    enemyCards.append(drawnCard3 + 1)
                    cards.remove(at: cardInd3)
                    
                    let cardInd4 = drawCard(someCards: cards)
                    let drawnCard4 = cards[cardInd4]
                    var vals4 = handleVal(val: drawnCard4)
                    enemyCards.append(drawnCard4 + 1)
                    cards.remove(at: cardInd4)
                    
                    
                    
                    minVal += vals1[0]
                    minVal += vals2[0]
                    maxVal += vals1[1]
                    maxVal += vals2[1]
                    isVisible = false
                    gameStarted = true
                    
                    //Update expected val when game begins.
                    expectedValue = expectedVal(cards: cards)
                    if expectedValue <= 21 {
                        suggestion = "HIT!"
                    } else {
                        suggestion = "hold."
                    }
                    
                    
                } label : {
                    Text("Begin Game")
                }.opacity(!isVisible ? 0 : 1)
                    .disabled(!isVisible)
                
                
                HStack {
                    Spacer()
                    ForEach(myCards, id: \.self) { card in
                        if card != 99 {
                            VStack {
                                //For testing purposes:
//                                Text("card: \(card)")
                                Image("img\(card)").resizable().frame(width:cardWidth, height: cardHeight)
                            }

                        }

                    }
                    Spacer()
                }
                if gameStarted && !gameOver {
                    Button("Show Cards") {
                        gameOver.toggle()
                    }.disabled(gameOver)
                }
                
                
                Button {
                    let cardInd = drawCard(someCards: cards)
                    let drawnCard = cards[cardInd]
                    let vals = handleVal(val: drawnCard)
                    minVal += vals[0]
                    maxVal += vals[1]
                    if minVal > 21 {
                        gameOver.toggle()
                    }
                    cardWidth = cardWidth * 0.9
                    cardHeight = cardHeight * 0.9
                    myCards.append(drawnCard +  1)
                    cards.remove(at: cardInd)
                    expectedValue = expectedVal(cards: cards)
                } label : {
                    Text("Draw card")
                }.opacity(!gameStarted ? 0 : 1)
                    .disabled(gameOver)
                
            
                
                
            }

            Spacer()

        }.background(Color.green).fullScreenCover(isPresented: $playAgain) {
            BlackJackView()
        }.fullScreenCover(isPresented: $goHome) {
            ContentView()
        }
        
                
    }
}

func expectedVal(cards: [Int]) -> Int {
    //Computes the expected value of a potential card draw
    print("count is \(cards.count)")
    var expectedVal = 0
    for card in cards {
        expectedVal += handleVal(val: card)[0]
    }
    print("expected val is: \(expectedVal)")
    expectedVal = expectedVal / (cards.count + 2)
    return expectedVal
}

func handleVal(val: Int) -> [Int] {
    //Takes the value of a card and returns in min and max val in a list
    let modVal = val % 13
    var maxVal = 0
    var minVal = 0
    if modVal >= 9 {
        minVal = 10
        maxVal = 10
        
    }
    else if modVal == 0 {
        minVal = 1
        maxVal = 11
        
    }
    else {
        minVal = modVal + 1
        maxVal = modVal + 1
    }
    return [minVal, maxVal]
}

func removeCard(cards: [Int], val: Int) -> [Int]{
    var cardsCopy = cards
    var x = 0
    let count = cards.count
    while x < count {
        if cards[x] == val {
            cardsCopy.remove(at: x)
            break
        }
        x += 1
    }
    return cardsCopy
}
//func fillArr(arr: [Int]) -> [Int]{
//
//}
func drawCard(someCards: [Int]) -> Int {
//    print(someCards)
    let ind = Int(arc4random_uniform(UInt32(someCards.count)))
    return ind
}

struct BlackJackView_Previews: PreviewProvider {
    static var previews: some View {
        BlackJackView()
    }
}
