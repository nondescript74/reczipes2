//
//  GoogleSearchView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/21/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import SwiftUI
import SafariServices

struct GoogleSearchView: View  {
    
    // MARK: - View Process
    var body: some View  {
        GeometryReader { proxy in
            if proxy.size.width > proxy.size.height {
                NavigationView {
                    ScrollView {
                        VStack {
                            
                        }.frame(minWidth: 0, idealWidth: 0, maxWidth: 0, minHeight: proxy.size.height, idealHeight: proxy.size.height, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topLeading)
                        
                    }
                    ScrollView {
                        VStack {
                            Text("Search")
                                .font(Font.system(size: 30, weight: .bold, design: .rounded))
                                .padding()
                            
                            SafariView(url: URL(string: "https://google.com")!)
                        }.frame(minWidth: proxy.size.width * 2 / 3, idealWidth: proxy.size.width, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: proxy.size.height, idealHeight: proxy.size.height, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topLeading)
                    }
                }
            } else {
                ScrollView {
                    VStack {
                        Text("Google Search")
                            .font(Font.system(size: 30, weight: .bold, design: .rounded))
                            .padding()
                        
                        SafariView(url: URL(string: "https://google.com")!)
                    }.frame(minWidth: proxy.size.width, idealWidth: proxy.size.width, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: proxy.size.height, idealHeight: proxy.size.height, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topLeading)
                }
            }
        }
    }
}




// MARK: - Previews
struct GoogleSearchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GoogleSearchView()
        }
    }
}

