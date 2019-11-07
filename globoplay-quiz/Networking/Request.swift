//
//  Request.swift
//  globoplay-quiz
//
//  Created by Jonathan Pereira Bijos on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

import Foundation

typealias Params = [String: String]
typealias Response = (Result<Data, ApiError>) -> Void

enum HTTPMethod: String {
  case get = "GET"
}

final class Request: WebserviceRequestProtocol {
    // MARK: - Public properties -
    var task: URLSessionTask?
    
    // MARK: - Private properties -
    private let timeoutInterval: TimeInterval = 20
    private let cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    private let urlString: String
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    // MARK: - Init -
    init(url: String) {
        urlString = url
    }
    
    deinit {
        debugPrint("Deinit Request")
    }
    
    // MARK: - Public functions -
    func get(params: Params? = nil, completion: @escaping Response) {
        guard !urlString.isEmpty else {
            completion(Result.failure(ApiError.invalidEndpoint))
            return
        }
        
        var urlComponents = URLComponents(string: urlString)
        var items: [URLQueryItem] = []
        if let params = params {
            for (key,value) in params {
                items.append(URLQueryItem(name: key, value: value))
            }
        }
        items = items.filter({ !$0.name.isEmpty })
        if !items.isEmpty {
            urlComponents?.queryItems = items
        }
        guard let url = urlComponents?.url else {
            completion(Result.failure(ApiError.invalidEndpoint))
            return
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        
        task = session.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                if let error = error as? URLError {
                    switch error.code {
                    case .notConnectedToInternet:
                        completion(Result.failure(ApiError.noInternet))
                    case .cancelled:
                        completion(Result.failure(ApiError.cancelled))
                    default:
                        completion(Result.failure(ApiError.serverError))
                    }
                    return
                }
                
                guard let response = response as? HTTPURLResponse, let data = data else {
                    completion(Result.failure(ApiError.invalidResponse))
                    return
                }
                
                switch response.statusCode {
                case 200...300:
                    completion(.success(data))
                default:
                    completion(Result.failure(ApiError.serverError))
                }
            }
        }
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
}
