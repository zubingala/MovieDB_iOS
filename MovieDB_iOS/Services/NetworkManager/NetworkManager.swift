//
//  NetworkManager.swift
//  MovieDB_iOS
//
//  Created by Zubin Gala on 16/11/24.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    init() {}
    
    private let apiConfig: APIConfig = APIConfig.load()
    
    //MARK: - Fetch Popular Movies
    func fetchPopularMovies(page: Int = 1) -> AnyPublisher<MovieModel, Error> {
        guard var urlComponents = URLComponents(string: apiConfig.baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        urlComponents.path += ServicePath.popularList
        urlComponents.queryItems = [
            URLQueryItem(name: Keys.apiKey, value: apiConfig.apiKey),
            URLQueryItem(name: Keys.page, value: String(page)),
        ]
        guard let url = urlComponents.url else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                // Ensure valid HTTP response
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: MovieModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    //MARK: - Fetch movie details
    func fetchMovieDetails(movieId: Int64) -> AnyPublisher<MovieData, Error> {
        guard var urlComponents = URLComponents(string: apiConfig.baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let detailPath = String(format: ServicePath.detailList, "\(movieId)")
        urlComponents.path += detailPath
        urlComponents.queryItems = [
            URLQueryItem(name: Keys.apiKey, value: apiConfig.apiKey)
        ]
        
        guard let url = urlComponents.url else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: MovieData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
