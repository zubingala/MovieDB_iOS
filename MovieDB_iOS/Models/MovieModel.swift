//
//  MovieModel.swift
//  MovieDB_iOS
//
//  Created by Zubin Gala on 16/11/24.
//

import Foundation

struct MovieModel: Codable {
  let page: Int?
  let totalResults: Int64?
  let totalPages: Int64?
  let movies: [MovieData]

  private enum CodingKeys: String, CodingKey {
    case page
    case totalResults = "total_results"
    case totalPages = "total_pages"
    case movies = "results"
  }
}

struct MovieData: Identifiable,Codable, Equatable {

  let id: Int64
  let title: String
  let voteCount: Int64?
  let video: Bool?
  let voteAverage: Double?
  let popularity: Double?
  let posterPath: String?
  let originalLanguage: String?
  let originalTitle: String?
  let backdropPath: String?
  let adult: Bool?
  let overview: String?
  let releaseDate: String?
  let genreIds: [Int]?

  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case voteCount = "vote_count"
    case video
    case voteAverage = "vote_average"
    case popularity
    case posterPath = "poster_path"
    case originalLanguage = "original_language"
    case originalTitle = "original_title"
    case backdropPath = "backdrop_path"
    case adult
    case overview
    case releaseDate = "release_date"
    case genreIds = "genre_ids"
  }

}

extension MovieData {
    
    func formattedReleaseDate() -> String {
      let convertToDate: ((String?) -> Date?) = { dateString in
        guard let dateString = dateString else { return nil }
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        formatter.dateFormat = Constants.releaseDateFormat
        return formatter.date(from: dateString)
      }
      guard let date = convertToDate(releaseDate) else { return "" }
      return date.stringValue(format: Constants.dateDisplayFormat) ?? ""
    }
    
    func posterURL(size: PosterSize = .w500) -> URL? {
      guard let relativePath = posterPath else { return nil }
      let thumbnailPath = String.init(format: ServicePath.movieThumbnailPath, size.stringValue)
      let posterPath = URL.init(string: thumbnailPath)?.appendingPathComponent(relativePath)
      return posterPath
    }

    func backdropURL(size: BackdropSize = .w1280) -> URL? {
      guard let relativePath = backdropPath else { return nil }
      let thumbnailPath = String.init(format: ServicePath.movieThumbnailPath, size.stringValue)
      let backdropPath = URL.init(string: thumbnailPath)?.appendingPathComponent(relativePath)
      return backdropPath
    }

    func movieLanguage() -> String? {
      guard let languageCode = originalLanguage else { return "" }
      let locale = NSLocale.current as NSLocale
      return locale.displayName(forKey: .identifier, value: languageCode)
    }

    func movieRatings() -> String? {
      guard let voteAverage = voteAverage else { return "" }
      return String(voteAverage)
    }
}


extension MovieData {
    static func mock(
        id: Int64 = 1,
        title: String = "Test Movie",
        voteCount: Int64? = nil,
        video: Bool? = nil,
        voteAverage: Double? = nil,
        popularity: Double? = nil,
        posterPath: String? = nil,
        originalLanguage: String? = nil,
        originalTitle: String? = nil,
        backdropPath: String? = nil,
        adult: Bool? = nil,
        overview: String? = nil,
        releaseDate: String? = nil,
        genreIds: [Int]? = nil
    ) -> MovieData {
        return MovieData(
            id: id,
            title: title,
            voteCount: voteCount,
            video: video,
            voteAverage: voteAverage,
            popularity: popularity,
            posterPath: posterPath,
            originalLanguage: originalLanguage,
            originalTitle: originalTitle,
            backdropPath: backdropPath,
            adult: adult,
            overview: overview,
            releaseDate: releaseDate,
            genreIds: genreIds
        )
    }
}
