//
//  APIConstants.swift
//  MovieDB_iOS
//
//  Created by Zubin Gala on 16/11/24.
//

import Foundation

enum ServicePath {
    static let popularList          = "/movie/popular"
    static let detailList            = "/movie/%@"
    static let movieThumbnailPath   = "http://image.tmdb.org/t/p/%@/"
}

enum Keys {
    // MARK: - Service Parameter Keys
    static let page                 = "page"
    static let apiKey              = "api_key"
}

enum PageInfo {
    static let defaultPage = 1
}
