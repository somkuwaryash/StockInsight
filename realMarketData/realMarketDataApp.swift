//
//  realMarketDataApp.swift
//  realMarketData
//
//  Created by Yash Somkuwar on 06/08/23.
//

import SwiftUI

@main
struct YourApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some Scene {
        WindowGroup {
            HomePage()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

