import SwiftUI

struct HomePage: View {
    @State private var selectedTicker = ""
    @State private var tickers: [String] = []
    @State private var newsItems: [News] = []
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State var marketStatus: String = "Fetching..."
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: nil) {
                if isLoading {
                    ProgressView("Loading...")
                }else{
                    if tickers.isEmpty {
                        ProgressView("Loading tickers...")
                    } else {
                        SearchableDropdown(selectedTicker: $selectedTicker, tickers: tickers)
                        
                        NavigationLink(destination: ContentView(ticker: selectedTicker)) {
                            Text("Show Details")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .disabled(selectedTicker.isEmpty)
                    }
                    if newsItems.isEmpty {
                        ProgressView("Loading news...")
                    } else {
                        List {
                            Section(header: Text("Latest News").font(.title).fontWeight(.bold)) {
                                ForEach(newsItems, id: \.id) { news in
                                    VStack(alignment: .leading) {
                                        Text(news.title)
                                            .font(.headline)
                                        Text(news.description)
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }}
            .padding()
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                                    MarketStatusBadge(status: $marketStatus)
                                }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                HStack {
                                    Button(action: {
                                        isDarkMode.toggle()
                                    }) {
                                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                    
                                    
                                }
                            }
                        }
        }
        .onAppear {
            fetchMarketStatus()
            NetworkManager().fetchTickers { fetchedTickers in
                DispatchQueue.main.async {
                    self.tickers = fetchedTickers
                    print("Tickers fetched: \(fetchedTickers)")
                }
            }
            NewsNetworkManager().fetchNews { fetchedNews in
                DispatchQueue.main.async {
                    self.newsItems = fetchedNews
                    print("News items fetched: \(fetchedNews)")
                    isLoading = false
                }
            }
        }
    }
    func fetchMarketStatus() {
        NewsNetworkManager().fetchMarketStatus { status in
            DispatchQueue.main.async {
                self.marketStatus = status.market
            }
        }
    }

}

struct MarketStatusBadge: View {
    @Binding var status: String
    
    var body: some View {
        Text("Market: \(status.uppercased())")
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(status == "open" ? Color.green : Color.red)
            .foregroundColor(.white)
            .cornerRadius(15)
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}

