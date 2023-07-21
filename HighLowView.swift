//
//  HighLowView.swift
//  testApp
//
//  Created by lucas gagne on 5/26/23.
//

import SwiftUI
import Charts

struct HighLowView: View {
    @State var showText = false
    @State var chosenMode = "high"
    @State var betAmount = 10
    @State var numGames = 10
    @State var arr = [[3,2,1]]
    @State var isPresenting = false
    @State var face = "tails"
    @State var rotation: CGFloat = 0.0
    @State var offset_y: CGFloat = 0.0
    @State var offset_x: CGFloat = 0.0
    @State var rotateCube = false
    @State var finResults = [6,6]

    
   
    var body: some View {
        
        VStack {
            Text("Total prof: \(arr[0][0])")
            Spacer()
            HStack {
            Spacer()
                Text("\(finResults[0])").background(
                Rectangle().fill(Color.white).frame(width: 50, height: 50)
                ).rotationEffect(.degrees(-rotation))
                    .offset(x: offset_x, y: offset_y).onChange(of: rotateCube) { (val) in
                        if val {
                            withAnimation(.easeOut(duration: 1.0).delay(0.0)) {
                                offset_y = -300
                                rotation -= 90
                            }
                            
                            withAnimation(.easeIn(duration: 1.0).delay(1.0)) {
                                offset_y = 0.0
                                rotation -= 90
                            }
                        }
                    }
                Spacer()
                Text("\(finResults[1])").background(
                Rectangle().fill(Color.white).frame(width: 50, height: 50)
                ).rotationEffect(.degrees(-rotation))
                    .offset(x: offset_x, y: offset_y).onChange(of: rotateCube) { (val) in
                        if val {
                            withAnimation(.easeOut(duration: 1.0).delay(0.0)) {
                                offset_y = -300
                                rotation -= 90
                            }
                            
                            withAnimation(.easeIn(duration: 1.0).delay(1.0)) {
                                offset_y = 0.0
                                rotation -= 90
                            }
                        }
                    }
                Spacer()
            }
            Spacer()
            let gameModes = ["high", "low", "seven"]
            Button {
//                offset_x += 5
//                offset_y += 5
//                rotation -= 90
                if rotateCube == false {
                    rotateCube = true
                } else {
                    rotateCube = false
                }
                if showText == false {
                    finResults = rollDice()
                }
                
                
                showText.toggle()
                
                
                
            } label : {
                if showText == false {
                    Text("Roll Dice")
                } else {
                    Text("Play again")
                }
                
            }
            
            HStack {
                if showText == true {
                    
                    

                    Text("\(finResults[0]) \(finResults[1])")
                    let total = finResults[0] + finResults[1]
                    Text("Total: \(total)")
                    
                    if chosenMode == "high" {
                        if total >= 8 {
                            Text("you won bro")
                        } else {
                            Text("you lost bro")
                        }
                    }
                    else if chosenMode == "low" {
                        if total <= 6 {
                            Text("you won bro")
                        } else {
                            Text("you lost bro")
                        }
                    }
                    else {
                        if total == 7{
                            Text("You won bro")
                        } else {
                            Text("You lost bro")
                        }
                    }
                    let profit = simulateGame(bet: chosenMode, betAmount: betAmount, dice: finResults)
                    Text("Profit: \(profit)")
                } else {
                    Text("")
                }
            }
            HStack {
                VStack {
                    Text("place you bet: ")
                    Picker("Please choose a game mode", selection: $chosenMode) {
                                    ForEach(gameModes, id: \.self) {
                                        Text($0)
                                    }
                    }
                }
                
                VStack {
                    Text("Bet value: ")
                    Picker("Please choose a game mode", selection:
                            $betAmount) {
                        ForEach(0..<1000, id: \.self) { int in
                                        Text(String(int))
                                    }
                    }
                }
                VStack {
                    Text("Number of games: ")
                    Picker("Please choose a number of games", selection:
                            $numGames) {
                        ForEach(0..<100, id: \.self) { int in
                                        Text(String(int))
                                    }
                    }
                }
                
            }
            Button {
                arr = simulateManyGame(bet: chosenMode, betAmount: betAmount, reps: numGames)
                isPresenting.toggle()
            } label : {
                Text("Simulate Games")
            }

            
            
            
        }.background(Color.brown).fullScreenCover(isPresented: $isPresenting) {
            finalViewHighLow(results: arr)
        }
        
    }

}
func simulateGame(bet: String, betAmount: Int,  dice:[Int]) -> Int{
    let total = dice[0] + dice[1]
    if total >= 8 && bet == "high"{
        return betAmount
    }
    else if total <= 6 && bet == "low"{
        return betAmount
    }
    else if total == 7 && bet == "seven" {
        return betAmount
    }
    else {
        return betAmount * -1
    }
    
}
func rollDice() -> [Int] {
    let randInt1 = Int(arc4random_uniform(6)) + 1
    let randInt2 = Int(arc4random_uniform(6)) + 1
    let results = [randInt1, randInt2]
    return results
}
func simulateManyGame(bet: String, betAmount: Int, reps: Int) -> [[Int]] {
    //Store every rounds dice outcome, as well as the profit made each round. Index zero is a single index list containing total profit.
    var results = [[Int]]()
    var totalProf = 0
    var x = 0
    while x < reps {
        var dice = rollDice()
        var profit = simulateGame(bet: bet, betAmount: betAmount, dice: dice)
        dice.append(profit)
        results.append(dice)
        totalProf += profit
        x += 1
    }
    results.insert([totalProf], at: 0)
//    isPresenting.toggle()
//    print(results)
    
    return results
}

func getWins(arr: [[Int]]) -> Int{
    var x = 1
    var wintotal = 0
    while x < arr.count {
        if arr[x][2] > 0 {
            wintotal += 1
        }
        x += 1
    }
    return wintotal
}

struct finalViewHighLow: View {
    
    
    var results: [[Int]]
    var resultRange: Int
    var totalWins : Int
    
    init(results: [[Int]]) {
        self.results = results
        self.resultRange = results.count
        self.totalWins = getWins(arr: results)
        
    }
    var body: some View {
        NavigationView {
            VStack {
                
                NavigationLink {
                    ContentView().navigationBarBackButtonHidden(true)
                } label : {
                    Text("Back to home screen")
                }
                NavigationLink {
                    HighLowView()
                } label : {
                    Text("Play again")
                }
                ScrollView {
                    Text("Total Profit: \(results[0][0])")
                    Text("You won \(totalWins) out of \(resultRange-1) games")
                    //                    Text("Total profit: \(results[0])")
                    ForEach(1..<resultRange) { int in
                        HStack {
                            Text("Dice rolled: \(results[int][0]) and \(results[int][1]). Profit this round: \(results[int][2])")
                        }
                    }
                }
                    Text("Chart below shows win to loss ratio over different number of repetitons of rounds. As you can see as we play more rounds the results are more constant")
                    Chart(1..<20,  id: \.self) { num in

                        let games = simulateManyGame(bet: "high", betAmount: 10, reps: num)
                        let winCount = Double(getWins(arr: games)) / Double(num)
                        let losses = Double(1) - Double(winCount)

                                BarMark(
                                    x: .value("Month", num),
                                    y: .value("Revenue", winCount)
                                ).foregroundStyle(Color.red)

                                BarMark(x: .value("Month", num),
                                 y:.value("Revenue", losses) ).foregroundStyle(Color.blue)



                    }.chartXAxis {
                        AxisMarks(preset: .aligned)
                      }
                    .chartYAxis {
                        AxisMarks() {
                           let value = $0.as(Int.self)!
                           AxisValueLabel {
                               Text("\(value)%")
                           }
                       }
                    }

                    Spacer()
                
                
                
            }
            
        }
        
        
    }
}
struct HighLowView_Previews: PreviewProvider {
    static var previews: some View {
        HighLowView()
    }
}
