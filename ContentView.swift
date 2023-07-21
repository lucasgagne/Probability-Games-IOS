//
//  ContentView.swift
//  testApp
//
//  Created by lucas gagne on 5/15/23.
//

import SwiftUI

struct ContentView: View {
    @State var skyBlue = Color(red: 0.4627, green: 0.8392, blue: 1.0)
    @State var lemonYellow = Color(hue: 0.1639, saturation: 1, brightness: 1)


    var body: some View {
    
        VStack {
            NavigationView {
                VStack {
                    Text("Casino IQ")
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Text("Monty Hall Game ")
                            NavigationLink {
                                DoorView()
                            } label : {
                                Text("click here to play").foregroundColor(lemonYellow)
                            }
                            Spacer()
                            Spacer()
                            
                        }
                        VStack {
                            Text("Black Jack")
                            NavigationLink {
                                BlackJackView()
                            } label : {
                                Text("click here to play").foregroundColor(lemonYellow)
                            }
                        }
                        VStack {
                            Text("High Low")
                            NavigationLink {
                                HighLowView()
                            } label : {
                                Text("click here to play").foregroundColor(lemonYellow)
                            }
                        }
                        Spacer()
                    }.scaledToFit().background(skyBlue)
                    Spacer()
                }.background(skyBlue)
                

            }
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
