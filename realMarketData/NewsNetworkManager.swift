//
//  NewsNetworkManager.swift
//  realMarketData
//
//  Created by Yash Somkuwar on 08/08/23.
//

import Foundation
import Alamofire
import SwiftyJSON

class NewsNetworkManager {
    let polygonAPIKey = "Q6F7tICmPHVcpseZZNsfhDFcFVsSekkQ"
    
    func fetchNews(completion: @escaping ([News]) -> Void) {
        let url = "https://api.polygon.io/v2/reference/news?apiKey=\(polygonAPIKey)"

        AF.request(url).response { response in
            debugPrint(response)

            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let data = data {
                        let newsResponse = try decoder.decode(NewsResponse.self, from: data)
                        completion(newsResponse.results)
                    }
                } catch {
                    print("Decoding Error: \(error)")
                }
            case .failure(let error):
                print("Error in fetching news: \(error)")
            }
        }
    }

    struct NewsResponse: Codable {
        let results: [News]
    }
    
    
    func fetchMarketStatus(completion: @escaping (MarketStatus) -> Void) {
        let url = "https://api.polygon.io/v1/marketstatus/now?apiKey=\(polygonAPIKey)"
        AF.request(url).responseDecodable(of: MarketStatus.self) { response in
            switch response.result {
            case .success(let marketStatus):
                completion(marketStatus)
            case .failure(let error):
                print("Error decoding market status: \(error)")
            }
        }
    }




}
