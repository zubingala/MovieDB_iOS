//
//  MovieViewModelTests.swift
//  MovieDB_iOSTests
//
//  Created by Zubin Gala on 16/11/24.
//

import XCTest
import Combine

@testable import MovieDB_iOS

final class MovieViewModelTests: XCTestCase {
    
    var viewModel: MovieViewModel!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = MovieViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    
    func testFetchMoviesSuccess() {
        // Arrange
        let mockMovieData = [MovieData.mock()]
        let mockMovieModel = MovieModel(page: 2, totalResults: 20, totalPages: 4, movies: mockMovieData)
        mockNetworkManager.mockMovies = mockMovieModel
        
        // Act
        viewModel.fetchMovies()
        
        // Assert
        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.movies.first?.title, "Test Movie")
        XCTAssertEqual(viewModel.totalPages, 2)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testFetchMoviesFailure() {
        // Arrange
        mockNetworkManager.shouldReturnError = true
        
        // Act
        viewModel.fetchMovies()
        
        // Assert
        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    func testResetMovies() {
        // Arrange
        let mockMovieData = [MovieData.mock()]
        let mockMovieModel = MovieModel(page: 2, totalResults: 20, totalPages: 4, movies: mockMovieData)
        mockNetworkManager.mockMovies = mockMovieModel
        viewModel.fetchMovies()
        
        // Act
        viewModel.resetMovies()
        
        // Assert
        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertEqual(viewModel.totalPages, 1)
    }
    
}
