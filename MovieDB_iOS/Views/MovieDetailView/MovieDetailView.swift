//
//  MovieDetailView.swift
//  MovieDB_iOS
//
//  Created by Zubin Gala on 16/11/24.
//

import SwiftUI

struct MovieDetailView: View {
    //MARK: - PROPORTIES
    let movieId: Int64
    @StateObject private var viewModel = MovieDetailViewModel()
    
    //MARK: - BODY
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            detailView
        }.onAppear {
            viewModel.fetchMovieDetails(movieId: movieId)
        }
        .navigationTitle("Movie Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var detailView: some View {
        guard let model = viewModel.movie else {
            return AnyView(EmptyView())
        }
        
        return AnyView(
            VStack(alignment: .leading, spacing: 16) {
                // Backdrop Image
                AsyncImage(url: model.backdropURL()) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width, height: 200)
                        .cornerRadius(8)
                } placeholder: {
                    Constants.placeholderImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width, height: 200)
                }
                
                // Poster and Movie Info
                HStack(alignment: .top, spacing: 16) {
                    AsyncImage(url: model.posterURL()) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 150)
                            .cornerRadius(8)
                    } placeholder: {
                        Constants.placeholderImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 150)
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        // Title Info
                        Text(model.title ?? "Unknown Title")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        // Rating Info
                        HStack(spacing: 4) {
                            Image("rating-star")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                            
                            Text(model.movieRatings() ?? "No Rating")
                                .font(.footnote)
                                .foregroundColor(.black)
                        }
                        
                        // Language Info
                        Text(model.movieLanguage() ?? "Unknown Language")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        
                        // Release Date Info
                        Text(model.formattedReleaseDate())
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                }
                
                Divider().background(Color.white).padding(.vertical, 8)
                
                // Overview
                Text(model.overview ?? "No Overview Available")
                    .font(.footnote)
                    .foregroundColor(.black)
                    .padding(.bottom, 16)
                
                Spacer()
            }
                .padding(.leading, 16)
        )
    }
    
}

//MARK: - PREVIEW
#Preview {
    MovieDetailView(movieId: 558216)
}
