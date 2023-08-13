import SwiftUI

struct ContentView: View {
    let ticker: String
    @State private var marketData: [String: String] = [:]

    var body: some View {
        VStack {

            List(marketData.sorted(by: <), id: \.key) { key, value in
                VStack(alignment: .leading) {
                    Text(key).font(.headline)
                            .fontWeight(.bold)
                    Text(value).font(.subheadline)
                            .foregroundColor(.secondary)
                }
            }.navigationBarTitle(ticker, displayMode: .inline)
        }
        .onAppear {
            loadData()
            loadSMA()
            // Call similar functions for EMA, MACD, RSI if you have them
        }
        .navigationBarTitle(ticker, displayMode: .inline)
    }

    func loadData() {
        NetworkManager().loadData(ticker: ticker) { data in
            DispatchQueue.main.async {
                self.marketData = data
            }
        }
    }

    func loadSMA() {
        NetworkManager().loadSMA(ticker: ticker) { sma in
            DispatchQueue.main.async {
                self.marketData["SMA"] = String(sma)
            }
        }
    }



}
