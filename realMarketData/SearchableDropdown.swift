//
//  SearchableDropdown.swift
//  realMarketData
//
//  Created by Yash Somkuwar on 07/08/23.
//

import SwiftUI

struct SearchableDropdown: View {
    @Binding var selectedTicker: String
    @State private var searchText = ""
    @State private var showDropdown = false
    let tickers: [String]
    
    var body: some View {
        VStack {
            Button(action: {
                self.showDropdown = true
            }) {
                HStack {
                    Text(selectedTicker.isEmpty ? "Select ticker" : selectedTicker)
                    Spacer()
                    Image(systemName: "arrowtriangle.down.fill")
                }
            }
            
            if showDropdown {
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                List {
                    ForEach(tickers.filter { searchText.isEmpty ? true : $0.contains(searchText) }, id: \.self) { ticker in
                        Button(action: {
                            self.selectedTicker = ticker
                            self.showDropdown = false
                        }) {
                            Text(ticker)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}
