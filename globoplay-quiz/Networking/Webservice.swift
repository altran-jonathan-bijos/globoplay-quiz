//
//  Webservice.swift
//  globoplay-quiz
//
//  Created by Jonathan Pereira Bijos on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

import Foundation

protocol Webservice {
    func request(urlString: String, method: HTTPMethod, parameters: Params?, completion: @escaping (Result<Data, ApiError>) -> Void)
    func cancelAllRequests()
    func retry<T: Decodable>(_ attempts: Int,
                             task: @escaping (_ success: @escaping (T) -> Void, _ failure: @escaping (ApiError) -> Void) -> Void,
                             success: @escaping (T) -> Void,
                             failure: @escaping (ApiError) -> Void)
}
