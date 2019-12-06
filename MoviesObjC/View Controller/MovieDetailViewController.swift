//
//  MovieDetailViewController.swift
//  MoviesObjC
//
//  Created by Kyle Jennings on 12/6/19.
//  Copyright © 2019 Kyle Jennings. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    
    // MARK: - Properties
    var movie: KPJMovie? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Custom Functions
    func updateViews() {
        // in case the view hasn't loaded yet
        loadViewIfNeeded()
        guard let movie = movie else {return}
        title = movie.title
        KPJMovieController.fetchPoster(from: movie) { (image) in
            // need to be on the main queue
            DispatchQueue.main.async {
                self.posterImageView.image = image
            }
        }
        // didn't put these within the fetchPoster because I want them to populate even if there isn't a poster
        movieTitleLabel.text = movie.title
        movieOverviewLabel.text = movie.overview
        
        // If a movie doesn't currently have a rating, I want the user to know it hasn't been rated yet
        if movie.rating == 0 {
            movieRatingLabel.text = "Not Yet Rated"
        } else {
            movieRatingLabel.text = "Rating: \(movie.rating)"
        }
    }
}
