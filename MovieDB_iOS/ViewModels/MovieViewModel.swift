//
//  MovieViewModel.swift
//  MovieDB_iOS
//
//  Created by Zubin Gala on 16/11/24.
//

import Combine

class MovieViewModel: ObservableObject {
    @Published var movies: [MovieData] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    var currentPage = 1
    var totalPages = 1
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    //MARK: - Fetch Movies API
    func fetchMovies() {
        
        guard !isLoading, currentPage <= totalPages else { return }
        
        isLoading = true
        errorMessage = nil
        
        networkManager.fetchPopularMovies(page: currentPage)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] movieModel in
                guard let self = self else { return }
                self.movies.append(contentsOf: movieModel.movies)
                self.totalPages = Int(movieModel.totalPages ?? 1)
                self.currentPage += 1
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Reset Movies Data
    func resetMovies() {
        currentPage = 1
        totalPages = 1
        movies = []
        fetchMovies()
    }
    
}
