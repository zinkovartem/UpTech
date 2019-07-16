//
//  NetworkManager.swift
//  UpTech
//
//  Created by A.Zinkov on 7/12/19.
//  Copyright © 2019 ArtemZinkov. All rights reserved.
//

import RxSwift

typealias JSON = [AnyHashable: Any]

enum NetworkErrors: Error {
    case networkError(description: String)
    case notSuccess(code: Int, header: [AnyHashable: Any])
    // shouldn't appear at all, but JIC
    case responseCastError
    case noDataWhereRecieved
    case decodingError
}

class NetworkManager {
    
    private static let kApiKey = "237d9303a7f44854b39dc587a99eceb1"
    private let baseUrlString = "https://newsapi.org/v2/everything"
    private let session = URLSession.shared
    
    public static var shared = NetworkManager()
    
    func getNewsResponse(with question: String, forPage pageNumber: Int) -> Observable<NewsResponse> {
        
        return .create { [weak self] observer -> Disposable in
            
            guard let wself = self,
                var urlComponents = URLComponents(string: wself.baseUrlString)
                else { return Disposables.create() }
            
            urlComponents.queryItems = [
                URLQueryItem(name: "q", value: question),
                URLQueryItem(name: "page", value: pageNumber.description)
            ]
            
            guard let url = urlComponents.url else { return Disposables.create() }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.addValue(NetworkManager.kApiKey, forHTTPHeaderField: "Authorization")
            
            wself.session.dataTask(with: urlRequest) { data, response, error in
                
                if let networkError = wself.wrapError(response, error) {
                    observer.onError(networkError)
                } else if data == nil {
                    observer.onError(NetworkErrors.noDataWhereRecieved)
                } else {
                    if let newsResponse = try? JSONDecoder().decode(NewsResponse.self, from: data!) {
                        observer.onNext(newsResponse)
                        observer.onCompleted()
                    } else {
                        observer.onError(NetworkErrors.decodingError)
                    }
                }
                
            }.resume()
            
            return Disposables.create()
        }
    }
    
    // MARK: Private methods
    private func wrapError(_ response: URLResponse?, _ error: Error?) -> NetworkErrors? {
        if let error = error {
            return .networkError(description: error.localizedDescription)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return.responseCastError
        }
        
        if !(200..<300).contains(httpResponse.statusCode) {
            return.notSuccess(code: httpResponse.statusCode, header: httpResponse.allHeaderFields)
        }
        
        return nil
    }
}
