//
//  ApiError.swift
//  globoplay-quiz
//
//  Created by Jonathan Pereira Bijos on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

enum ApiError: Error {
  case noInternet
  case serverError
  case decodingError
  case invalidResponse
  case invalidEndpoint
  case empty
  case cancelled

  var message: String {
    switch self {
    case .noInternet:
      return "No internet connection"
    case .serverError:
      return "Unable to connect to the server"
    case .decodingError, .invalidResponse:
      return "There was a problem connecting to the server"
    case .invalidEndpoint:
      return "Unable to connect to the server"
    case .empty:
      return "No results found for the current search.\n\nTry searching for something else :)"
    case .cancelled:
      return ""
    }
  }
}
