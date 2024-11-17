//
//  MockNetworkManager.swift
//  MovieDB_iOSTests
//
//  Created by Zubin Gala on 17/11/24.
//

import Combine
import XCTest

@testable import MovieDB_iOS

class MockNetworkManager: NetworkManager {
    var shouldReturnError = false
    var mockMovies: MovieModel!
    var mockMovieData: MovieData?
    var mockError: Error?
    
    override init() {}
    
    //MARK: - fetch popular movies
    override func fetchPopularMovies(page: Int) -> AnyPublisher<MovieModel, Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "TestError", code: 1, userInfo: nil))
                .eraseToAnyPublisher()
        } else {
            return Just(mockMovies)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    override func fetchMovieDetails(movieId: Int64) -> AnyPublisher<MovieData, Error> {
           if let error = mockError {
               return Fail(error: error).eraseToAnyPublisher()
           }
           
           guard let movieData = mockMovieData else {
               return Fail(error: NSError(domain: "MovieNotFound", code: 404, userInfo: nil)).eraseToAnyPublisher()
           }
           
           return Just(movieData)
               .setFailureType(to: Error.self)
               .eraseToAnyPublisher()
       }
}
