//
//  MovieListView.swift
//  MovieDB_iOS
//
//  Created by Zubin Gala on 16/11/24.
//

import SwiftUI

struct MovieListView: View {
    //MARK: - PROPERTIES
    @StateObject private var viewModel = MovieViewModel()
    @State private var isShowingAlert = false
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading && viewModel.movies.isEmpty {
                    ProgressView("Loading Movies...")
                } else {
                    List(viewModel.movies) { movie in
                        NavigationLink(
                            destination: MovieDetailView(movieId: movie.id)
                        ) {
                            VStack {
                                AsyncImage(url: movie.posterURL()) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(12)
                                } placeholder: {
                                    Constants.placeholderImage
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(12)
                                }
                                .frame(width: 250, height: 375)
                                .clipped()
                                .padding()
                                
                                Text(movie.title ?? "Unknown Title")
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 8)
                            }//: VSTACK
                            .onAppear {
                                if movie == viewModel.movies.last {
                                    viewModel.fetchMovies()
                                }
                            }
                        }
                    }
                }
            }//: GROUP
            .navigationTitle("Popular Movies")
            .onAppear {
                viewModel.fetchMovies()
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "Something went wrong"),
                    dismissButton: .default(Text("OK"))
                )
                
            }//: ALERT
            .onChange(of: viewModel.errorMessage) { newErrorMessage in
                if newErrorMessage != nil {
                    isShowingAlert = true
                }
            }
        }//: NAVIGATIONVIEW
    }
}

//MARK: - PREVIEW
#Preview {
    MovieListView()
}
