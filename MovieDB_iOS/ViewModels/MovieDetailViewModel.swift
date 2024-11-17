//
//  MovieDetailViewModel.swift
//  MovieDB_iOS
//
//  Created by Zubin Gala on 16/11/24.
//

import Combine

class MovieDetailViewModel: ObservableObject {
    //MARK: - PROPERTIES
    @Published var movie: MovieData?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    var cancellables = Set<AnyCancellable>()
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    //MARK: - Fetch Movie Details API
    func fetchMovieDetails(movieId: Int64) {
        isLoading = true
        errorMessage = nil
        
        networkManager.fetchMovieDetails(movieId: movieId)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] movieData in
                self?.movie = movieData
            }
            .store(in: &cancellables)
    }
}
