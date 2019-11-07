//
//  QuizWebservice.swift
//  globoplay-quiz
//
//  Created by Jonathan Pereira Bijos on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

import Foundation

protocol QuizWebserviceProtocol: AnyObject {
    func getQuestions(completion: @escaping (Result<[Question], ApiError>) -> Void)
}

final class QuizWebservice: QuizWebserviceProtocol {
    private let service: Webservice
    
    init(service: Webservice = BaseWebservice()) {
        self.service = service
    }
    
    deinit {
        debugPrint("Deinit QuizWebservice")
        service.cancelAllRequests()
    }
    
    func getQuestions(completion: @escaping (Result<[Question], ApiError>) -> Void) {
        service.retry(2, task: { [weak self] (successCompletion, errorCompletion) in
            self?.service.request(urlString: Endpoints.questions, method: .get, parameters: nil, completion: { (result) in
                switch result {
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    do {
                        let response = try jsonDecoder.decode([Question].self, from: data)
                        successCompletion(response)
                    } catch {
                        errorCompletion(.decodingError)
                    }
                case .failure(let err):
                    errorCompletion(err)
                }
            })
            }, success: { (response: [Question]) in
                completion(.success(response))
        }) { (err) in
            completion(.failure(err))
        }
    }
}
