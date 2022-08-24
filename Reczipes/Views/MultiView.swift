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
    @ObservedObject var trivia = WebQueryRecipes()
    @ObservedObject var joke = WebQueryRecipes()
    
    // MARK: - State
    @State fileprivate var searchTerm : String = ""
    @State var show: Selectors
    //    @State fileprivate var showingProfile: Bool = false
    
    // MARK: - Properties
    enum Selectors {
        case notyet
        case trivia
        case joke
    }
    
    private enum msgs: String {
        //        case findrecipes = "Find Recipes"
        //        case readFilesInASDsuccess = "Success"
        //        case userProfile = "User Profile"
        case jort = "Joke and Trivia"
        case makeSelection = "Click Joke or Trivia"
        case noTitle = "No Recipe Title"
        case noJoke = "No Joke?"
        case noTrivia = "No Trivia?"
        case trivia = "olive"
        case joke = "joke"
    }
    
    private enum labelz: String {
        case trivia = "Trivia"
        case joke = "Joke"
        case get = "Get"
    }
    
    //    private enum imagez: String {
    ////        case zhome = "zhome"
    //        case triviathumb = "Trivia-thumb"
    //        case jokethumb = "Joke-thumb"
    //    }
    
    //    var profileButton: some View {
    //        Button(action: { self.showingProfile.toggle() }) {
    //            Image(uiImage: UIImage(named: imagez.zhome.rawValue)!.scaledDown(into: CGSize(width: 40, height: 40), centered: true))
    //                .imageScale(.large)
    //                .accessibility(label: Text(msgs.userProfile.rawValue))
    //                .padding()
    //        }
    //    }
    
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
                    Text(msgs.jort.rawValue).font(.largeTitle).bold()
                        .padding(.bottom)
                    Text(msgs.makeSelection.rawValue)
                        .font(.callout)
                        .foregroundColor(.black)
                        .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    HStack {
                        Button(action: {self.getTrivia()}) {
                            RoundButton3View(someTextTop: labelz.get.rawValue, someTextBottom: labelz.trivia.rawValue, someImage: msgs.trivia.rawValue)
                        }.padding()
                        Button(action: {self.getJoke()}) {
                            RoundButton3View(someTextTop: labelz.get.rawValue, someTextBottom: labelz.joke.rawValue, someImage: msgs.joke.rawValue)
                        }.padding()
                    }
                    
                    List   {
                        if show == Selectors.trivia {
                            Text(trivia.aTrivia?.text ?? msgs.noTrivia.rawValue)
                                .lineLimit(20)
                        }
                        if show == Selectors.joke {
                            Text(joke.joke?.text ?? msgs.noJoke.rawValue)
                                .lineLimit(20)
                        }
                    }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
        }
        
    }
}


struct MultiView_Previews: PreviewProvider {
    static var previews: some View {
        MultiView(show: .notyet)
            .previewDevice("iPhone Xr")
    }
}

