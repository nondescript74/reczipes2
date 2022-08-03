//
//  SearchBar.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 4/20/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation
import SwiftUI

struct SearchBar: UIViewRepresentable {
    
    private let myPrompt: String = "Enter search terms, click ?"
    
    @Binding var text: String
    
    class Coordinator: NSObject, UISearchBarDelegate   {
        @Binding var text: String
        
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchbar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.autocorrectionType = .no
        searchBar.placeholder = myPrompt
        //searchBar.prompt = self.myPrompt
        return searchBar
    }
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
