//
//  MovieDetailViewModelTests.swift
//  MovieDB_iOSTests
//
//  Created by Zubin Gala on 17/11/24.
//

import XCTest
import Combine

@testable import MovieDB_iOS

var viewModel: MovieDetailViewModel!
var mockNetworkManager: MockNetworkManager!

let mockDetailData = MovieData(id: 1, title: "Test Movie", voteCount: nil, video: false, voteAverage: nil, popularity: nil, posterPath: nil, originalLanguage: nil, originalTitle: "Test Movie", backdropPath: nil, adult: false, overview: "This is a test movie.", releaseDate: "2024-11-17", genreIds: nil)

final class MovieDetailViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = MovieDetailViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    
    func testFetchMovieDetailsSuccess() {
        
        let expectedMovie = mockDetailData
        mockNetworkManager.mockMovieData = expectedMovie
        
        let expectation = self.expectation(description: "Movie data is fetched successfully.")
        
        viewModel.$movie
            .dropFirst()
            .sink { movie in
                if let movie = movie {
                    XCTAssertEqual(movie.title, "Test Movie")
                    XCTAssertEqual(movie.id, 1)
                    expectation.fulfill()
                }
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.fetchMovieDetails(movieId: 1)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testFetchMovieDetailsFailure() {
        
        mockNetworkManager.mockError = NSError(domain: "NetworkError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch movie details."])
        
        
        let expectation = self.expectation(description: "Error message is displayed on failure.")
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                if let errorMessage = errorMessage {
                    XCTAssertEqual(errorMessage, "Failed to fetch movie details.")
                    expectation.fulfill()
                }
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.fetchMovieDetails(movieId: 1)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testFetchMovieDetailsLoadingState() {
        mockNetworkManager.mockMovieData = mockDetailData
        
        viewModel.fetchMovieDetails(movieId: 1)
        
        XCTAssertTrue(viewModel.isLoading)
        
        let expectation = self.expectation(description: "Loading state should be false after data fetch.")
        
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    XCTAssertFalse(isLoading)
                    expectation.fulfill()
                }
            }
            .store(in: &viewModel.cancellables)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
