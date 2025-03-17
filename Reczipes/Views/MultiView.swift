//
//  MultiView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/9/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import SwiftUI

struct MultiView: View {
    // MARK: - ObservedObject
    var trivia = WebQueryRecipes()
    var joke = WebQueryRecipes()
    // MARK: - State
    @State var show: Selectors = .notyet
    // MARK: - Properties
    enum Selectors {
        case notyet
        case trivia
        case joke
    }
    
    private enum msgs: String {
        case jort = "Joke and Trivia"
        case makeSelection = "Click Joke or Trivia"
        case noTitle = "No Recipe Title"
        case noJoke = "No Joke?"
        case noTrivia = "No Trivia?"
        case trivia = "leaf.arrow.triangle.circlepath"
        case joke = "figure.wave"
        /*
        Unicode: U+1F921, UTF-8: F0 9F A4 A1
         */
    }
    
    private enum labelz: String {
        case trivia = "Trivia"
        case joke = "Joke"
        case get = "Get"
    }
    
    // MARK:- Methods
    func getTrivia() {
        show = Selectors.trivia
        trivia.getTrivia()
    }
    
    func getJoke() {
        show = Selectors.joke
        joke.getJoke()
    }
    
    // MARK: - View Process
    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                VStack {
                    HStack {
                        Button(action: {self.getTrivia()}) {
                            RoundButton3View(someTextTop: labelz.get.rawValue, someTextBottom: labelz.trivia.rawValue, someImage: "msgs.trivia.rawValue", reversed: false)
                        }.padding()
                        Spacer()
                        Button(action: {self.getJoke()}) {
                            RoundButton3View(someTextTop: labelz.get.rawValue, someTextBottom: labelz.joke.rawValue, someImage: msgs.joke.rawValue, reversed: false)
                        }.padding()
                    }
                    
                    ScrollView   {
                        if show == Selectors.trivia {
                            Text(trivia.aTrivia?.text ?? msgs.noTrivia.rawValue)
                        }
                        if show == Selectors.joke {
                            Text(joke.joke?.text ?? msgs.noJoke.rawValue)
                        }
                    }
                }
                .navigationBarTitle("Joke or Trivia")
            }
        }
    }
}


struct MultiView_Previews: PreviewProvider {
    static var previews: some View {
        MultiView(show: .notyet)    }
}

