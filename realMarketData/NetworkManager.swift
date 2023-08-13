import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    let polygonAPIKey = "Q6F7tICmPHVcpseZZNsfhDFcFVsSekkQ"
    
    func fetchTickers(nextPageURL: String? = nil, completion: @escaping ([String]) -> Void) {
            let url = nextPageURL ?? "https://api.polygon.io/v3/reference/tickers?active=true&apiKey=\(polygonAPIKey)"

            AF.request(url).responseString { response in
                switch response.result {
                case .success(let value):
                    if let dataFromString = value.data(using: .utf8, allowLossyConversion: false) {
                        let json = JSON(dataFromString)
                        let tickers = json["results"].arrayValue.map { $0["ticker"].stringValue }

                        if let nextPageURL = json["next_url"].string {
                            self.fetchTickers(nextPageURL: nextPageURL) { nextTickers in
                                completion(tickers + nextTickers)
                            }
                        } else {
                            completion(tickers)
                        }
                    }

                case .failure(let error):
                    print(error)
                }
            }
    }


    
    func loadData(ticker: String, completion: @escaping ([String: String]) -> Void) {
        let url = "https://api.polygon.io/v2/aggs/ticker/\(ticker)/range/1/day/2023-01-09/2023-01-09?apiKey=Q6F7tICmPHVcpseZZNsfhDFcFVsSekkQ"

        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
        ]

        let parameters: [String: Any] = [
            "apiKey": "Q6F7tICmPHVcpseZZNsfhDFcFVsSekkQ"
        ]

        AF.request(url, method: .get, parameters: parameters, headers: headers).responseString { response in
            switch response.result {
            case .success(let value):
                if let dataFromString = value.data(using: .utf8, allowLossyConversion: false) {
                    let json = JSON(dataFromString)
                    if let results = json["results"].array, !results.isEmpty {
                        let firstResult = results[0]
                        let openPrice = firstResult["o"].doubleValue
                        let closePrice = firstResult["c"].doubleValue
                        let volume = firstResult["v"].intValue
                        
                        var marketData: [String: String] = [:]
                        marketData["Open Price"] = "\(openPrice)"
                        marketData["Close Price"] = "\(closePrice)"
                        marketData["Volume"] = "\(volume)"
                        
                        completion(marketData)
                    }
                }

            case .failure(let error):
                print(error)
            }
        }
    }
    func loadSMA(ticker: String, completion: @escaping (Double) -> Void) {
        let smaURL = "https://api.polygon.io/v1/indicators/sma/\(ticker)?timespan=day&adjusted=true&window=50&series_type=close&order=desc&apiKey=Q6F7tICmPHVcpseZZNsfhDFcFVsSekkQ"
        
        AF.request(smaURL, method: .get).responseDecodable(of: SMAData.self) { response in
            switch response.result {
            case .success(let data):
                if let smaValue = data.results.values.first?.value {
                    completion(smaValue)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    




}

