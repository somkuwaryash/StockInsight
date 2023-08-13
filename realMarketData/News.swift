

struct News: Codable {
    let id: String
    let title: String
    let description: String
    let publisher: Publisher
    let articleUrl: String?
    let imageUrl: String?
    let publishedUtc: String?
    let tickers: [String]

    enum CodingKeys: String, CodingKey {
        case id, title, description, publisher
        case articleUrl = "article_url"
        case imageUrl = "image_url"
        case publishedUtc = "published_utc"
        case tickers
    }
}

struct Publisher: Codable {
    let name: String
    let homepageUrl: String
    let logoUrl: String
    let faviconUrl: String
}


struct SMAData: Decodable {
    struct Results: Decodable {
        struct Underlying: Decodable {
            let url: String
        }
        
        struct Value: Decodable {
            let timestamp: Int64
            let value: Double
        }
        
        let underlying: Underlying
        let values: [Value]
    }
    
    let results: Results
}


struct MarketStatus: Codable {
    let market: String
}


