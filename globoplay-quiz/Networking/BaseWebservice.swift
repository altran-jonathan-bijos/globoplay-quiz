//
//  BaseWebservice.swift
//  globoplay-quiz
//
//  Created by Jonathan Pereira Bijos on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

import Foundation

protocol CancellableService {
    func cancelAllRequests()
}

protocol WebserviceRequestProtocol: AnyObject {
    func cancel()
    var task: URLSessionTask? { get }
}

final class BaseWebservice: Webservice {
    // MARK: - Properties -
    private var requests: [WebserviceRequestProtocol] = []
    
    // MARK: - Deinit -
    deinit {
        debugPrint("Deinit basewebservice")
        cancelAllRequests()
    }
    
    func request(urlString: String, method: HTTPMethod, parameters: Params?, completion: @escaping (Result<Data, ApiError>) -> Void) {
        let request = Request(url: urlString)
        
        var params: Params = [:]
        if let parameters = parameters {
            params = parameters
        }
        
        switch method {
        case .get:
            request.get(params: params) { [weak self] (result) in
                self?.requests.removeAll(where: { $0.task.hashValue == request.task.hashValue })
                completion(result)
            }
        }
        
        requests.append(request)
    }
    
    func cancelAllRequests() {
        requests.forEach { $0.cancel() }
    }
    
    func retry<T: Decodable>(_ attempts: Int = 2,
                             task: @escaping (_ success: @escaping (T) -> Void, _ failure: @escaping (ApiError) -> Void) -> Void,
                             success: @escaping (T) -> Void,
                             failure: @escaping (ApiError) -> Void) {
        task({ obj in
            success(obj)
        }) { err in
            // Don't retry
            if err == .noInternet || err == .cancelled || err == .empty {
                failure(err)
                return
            }
            
            debugPrint("Error retry left \(attempts)")
            if attempts > 0 {
                let deadline: Double = attempts >= 2 ? 4.0 : 8.0
                DispatchQueue.main.asyncAfter(deadline: .now() + deadline, execute: { [weak self] in
                    self?.retry(attempts - 1, task: task, success: success, failure: failure)
                })
            } else {
                failure(err)
            }
        }
    }
}
