//
//  DoorView.swift
//  testApp
//
//  Created by lucas gagne on 5/17/23.
//

import SwiftUI
import Charts

struct DoorView: View {
//    @State var doors = [false, false, false];
//    let randInt = Int.random(in: 1..<3)
//    doors[randInt] = true
    @State var openDoor = 99
    @State private var isPresenting = false
    @State var selectedDoor = 99
    @State var selectedDoor2 = 99
    @State var chosenMode = "switch doors"
    @State var chosenReps = 99
 
    var carDoor = Int(arc4random_uniform(3))
    
    func hostPickDoor(selectedDoor: Int) -> Int{
        var possibleDoors = [Int]()
        for num in [0,1,2] {
            if num != carDoor && num != selectedDoor {
                possibleDoors.insert(num, at: 0)
            }
        }
        if possibleDoors.count == 1 {
            return possibleDoors[0]
        } else {
            let randInt = Int(arc4random_uniform(2))
            return possibleDoors[randInt]
        }
                
    }
    func check_gameOver() {
        print("got here")
        if selectedDoor2 != 99 {
            isPresenting = true
        }
    }
    

    var body: some View {
        
        
        
        VStack {
            Spacer()
           Text("Choose your door")
            Spacer()
            VStack {
                Text(String(carDoor)).hidden()
                Text(String(selectedDoor)).hidden()
                Text(String(selectedDoor2)).hidden()
                Spacer()
                Spacer()
                HStack {
                    Spacer()
                    Spacer()
                    ForEach(0..<3) { int in
                        Button {
                            if selectedDoor == 99 {
                                selectedDoor = int
                                openDoor = hostPickDoor(selectedDoor: selectedDoor)
                            }
                            else if selectedDoor2 == 99 {
                                selectedDoor2 = int
                                isPresenting.toggle()
                            }
                        } label : {
                            ZStack {
                                
                                Rectangle().size(width: 70, height: 150).foregroundColor((openDoor == int) ? .black : .brown).animation( .easeIn(duration: 0.1)).shadow(color: .green, radius: (selectedDoor == int) ? 10 : 0).offset(x: 40, y: 50)
                                if openDoor == int {
                                    Text("🐐").animation(.easeIn(duration: 0.25)).offset(x: 10, y: -50)
                                }
                                
                            }
                            
                        }
                    }
                    Spacer()
                    
                }
                // Below is if we want to analyze the game
                
                NavigationStack {
                    let gameModes = ["switch doors", "keep doors"]
                    Text("Choose a game mode to analyze the outcomes")
                    Picker("Please choose a color", selection: $chosenMode) {
                                    ForEach(gameModes, id: \.self) {
                                        Text($0)
                                    }
                                }
                    Picker("Please choose a color", selection: $chosenReps) {
                        ForEach(0..<1000) { int in
                                        Text(String(int))
                                    }
                                }
                    NavigationLink {
                        analyzeView(numReps: chosenReps, gameMode: chosenMode)
                    } label : {
                        Text("Simulate Games")
                    }
                }
                
            }
        }
        .fullScreenCover(isPresented: $isPresenting) {
            finalView(chosenDoor: selectedDoor2, winningDoor: carDoor, chosenDoorTest: selectedDoor)
        }
       
    }
    
    
    
}
func simulateManyGames(n: Int, gameMode: Int) -> [[Int]]{
    //We will return an array of all the games where index zero is the total games we won...
    var x = 0
    var total_wins = [0]
    var results = [[Int]]()
    results.append(total_wins)
    while x < n {
        let result = simulateGame(gameMode: gameMode)
        results.append(result)
        results[0][0] += result[3]
        x += 1
    }
    return results
}

func simulateGame(gameMode: Int) -> [Int] {
    var game_results = [0,0,0, 0]
    var cars = [0,0,0]
    let carDoor = Int.random(in: 0..<3)
    cars[carDoor] = 1
    print(cars)
    let chosenDoor1 = Int.random(in: 0..<3)
    var chosenDoor2 = chosenDoor1
    var hostDoor = carDoor
    while hostDoor == carDoor || hostDoor == chosenDoor1{
        hostDoor = Int.random(in: 0..<3)
    }
    //Let 0 represent the switch door strategy
    if gameMode == 0 {
        while chosenDoor1 == chosenDoor2 || chosenDoor2 == hostDoor{
            chosenDoor2 = Int.random(in: 0..<3)
        }
    }
    game_results[0] = chosenDoor1
    game_results[1] = chosenDoor2
    game_results[2] = carDoor
    
    
    if chosenDoor2 == carDoor {
        game_results[3] = 1
    } else {
       game_results[3] = 0
    }
    return game_results
    
}
struct analyzeView : View {
    var numReps : Int
    var gameMode: Int
//    @State var total: ViewModel
//    @State var results : [Int]
    init(numReps: Int, gameMode: String) {
        self.numReps = numReps + 1
        if gameMode == "switch doors" {
            self.gameMode = 0
        } else {
            self.gameMode = 1
        }
//        self.total = ViewModel(val: 0)
    }

    
    
    var body: some View {
        
        let fucked_up_list = simulateManyGames(n: numReps, gameMode: gameMode)
        let total = fucked_up_list[0][0]
        let new_list = fucked_up_list[1...]
        Text("You won \(total) out of \(numReps) games.")
        Text("Test: \(total / numReps)")
        ScrollView {
            ForEach(new_list, id: \.self) { list in
                HStack {
                    Text("Car was behind door \(list[3] + 1)")
                    Text("First door chosen was \(list[0] + 1)")
                    Text("Second door chosen was \(list[1] + 1)")
                    if list[2] == 1 {
                        Text("Resulted in a win")
                    } else {
                        Text("Resulted in a loss")
                    }
                    
                }
            }

            
        }
        
    }
}

struct finalView: View {
    
    
    var chosenDoor: Int
    var winningDoor: Int
    var chosenDoorTest: Int
    init(chosenDoor: Int, winningDoor: Int, chosenDoorTest: Int) {
        self.chosenDoor = chosenDoor
        self.winningDoor = winningDoor
        self.chosenDoorTest = chosenDoorTest
    }
    var body: some View {
        NavigationView {
            VStack {
                
                if chosenDoor == winningDoor {
                    Text("You won")
                    Text("Here is your car, 🚗")
                } else {
                    Text("You lost")
                    Text("Here is your goat, 🐐")
                }
                
                
                NavigationLink {
                    ContentView().navigationBarBackButtonHidden(true)
                } label : {
                    Text("Back to home screen")
                }
                NavigationLink {
                    DoorView()
                } label : {
                    Text("Play again")
                }
                VStack {
                    Chart(1..<30,  id: \.self) { num in
                        let wins = simulateManyGames(n: num, gameMode: 0)[0][0]
                        let fraction = Double(wins) / Double(num)
                        let wins2 = simulateManyGames(n: num, gameMode: 1)[0][0]
                        let fraction2 = Double(wins2) / Double(num)
                        
                                LineMark(
                                    x: .value("Month", num),
                                    y: .value("Revenue", fraction * 100)
                                ).foregroundStyle(Color.red)
                        RuleMark(y: .value("Limit", 66.66666)).foregroundStyle(Color.red)
                                
                        PointMark(x: .value("Month", num),
                                 y:.value("Revenue", fraction2 * 100) ).foregroundStyle(Color.blue)
                        RuleMark(y: .value("Limit", 33.333)).foregroundStyle(Color.blue)

                            
                        
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
                }
                
                
//                .frame(height: 300)
            }
            
        }
        
        
    }
}



struct DoorView_Previews: PreviewProvider {
    static var previews: some View {
        DoorView()
    }
}
