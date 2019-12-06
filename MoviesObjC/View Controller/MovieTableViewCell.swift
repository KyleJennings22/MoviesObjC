//
//  MovieTableViewCell.swift
//  MoviesObjC
//
//  Created by Kyle Jennings on 12/6/19.
//  Copyright © 2019 Kyle Jennings. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    // MARK: - Properties
    var movie: KPJMovie? {
        didSet {
            // updateview once movie is set
            updateViews()
        }
    }
    
    // MARK: - Custom Functions
    func updateViews() {
        guard let movie = movie else {return}
        KPJMovieController.fetchPoster(from: movie) { (image) in
            guard let image = image else {return}
            DispatchQueue.main.async {
                self.posterImageView.image = image
            }
        }
        movieTitleLabel.text = movie.title
        overviewLabel.text = movie.overview
        
        // if movie doesn't have a rating, set the label to Not Yet Rated as to not confuse the user.
        if movie.rating == 0 {
            movieRatingLabel.text = "Not Yet Rated"
        } else {
            movieRatingLabel.text = "Rating: \(movie.rating)"
        }
    }
}
