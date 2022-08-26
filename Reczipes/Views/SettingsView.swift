//
//  SettingsView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/18/22.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - Debug
    private var zBug:Bool = false
    // MARK: - Environment Variables
    @EnvironmentObject var userData: UserData
    // MARK: - ObservedObject
    @ObservedObject var trivia = WebQueryRecipes()
    @ObservedObject var joke = WebQueryRecipes()
    // MARK: - State
    @State private var show: Selectors = .notyet
    // MARK: - Properties
    private var versionLabel = ""
    private var buildLabel = ""
    private enum msgs:String {
        case sv = "User Settings View"
        case cfsv = "CFBundleShortVersionString"
        case cfb = "CFBundleVersion"
        case z = "Hello, Z"
        case vers = "Version: "
        case build = "Build: "
        case nvn = "No Version #???"
        case nbn = "No Build #???"
        case jort = "Joke and Trivia"
        case makeSelection = "Click Joke or Trivia"
        case noTitle = "No Recipe Title"
        case noJoke = "No Joke?"
        case noTrivia = "No Trivia?"
        case trivia = "olive"
        case joke = "joke"
    
    }
    enum labelz: String {
        case trivia = "Trivia"
        case joke = "Joke"
        case get = "Get"
    }
    enum Selectors {
        case notyet
        case trivia
        case joke
    }
    // MARK: - Methods
    func getTrivia() {
        show = Selectors.trivia
        trivia.getTrivia()
    }
    
    func getJoke() {
        show = Selectors.joke
        joke.getJoke()
    }
    var body: some View {
        VStack {
            Text(msgs.sv.rawValue).font(.largeTitle).bold()
            Text(msgs.vers.rawValue + "\(Bundle.main.infoDictionary?[msgs.cfsv.rawValue] as? String ?? msgs.nvn.rawValue)")
            Text(msgs.build.rawValue + "\(Bundle.main.infoDictionary?[msgs.cfb.rawValue] as? String ?? msgs.nbn.rawValue)")
            Divider()
            
//            VStack {
//                Text(msgs.jort.rawValue).font(.largeTitle).bold()
//                    .padding(.bottom)
//                Text(msgs.makeSelection.rawValue)
//                    .font(.callout)
//                    .foregroundColor(.black)
//                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                
//                HStack {
//                    Button(action: {self.getTrivia()}) {
//                        RoundButton3View(someTextTop: labelz.get.rawValue, someTextBottom: labelz.trivia.rawValue, someImage: msgs.trivia.rawValue)
//                    }.padding()
//                    Button(action: {self.getJoke()}) {
//                        RoundButton3View(someTextTop: labelz.get.rawValue, someTextBottom: labelz.joke.rawValue, someImage: msgs.joke.rawValue)
//                    }.padding()
//                }
//                
//                List   {
//                    if show == Selectors.trivia {
//                        Text(trivia.aTrivia?.text ?? msgs.noTrivia.rawValue)
//                            .lineLimit(20)
//                    }
//                    if show == Selectors.joke {
//                        Text(joke.joke?.text ?? msgs.noJoke.rawValue)
//                            .lineLimit(20)
//                    }
//                }
//            }
            
//            ProfileHost().padding()
//            NutritionHost().padding()
            FilesDisplayView()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
