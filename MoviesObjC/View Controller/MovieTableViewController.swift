//
//  MovieTableViewController.swift
//  MoviesObjC
//
//  Created by Kyle Jennings on 12/6/19.
//  Copyright © 2019 Kyle Jennings. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController, UISearchBarDelegate {

    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: - Properties
    var movies: [KPJMovie]? {
        didSet {
            // need to be on the main queue to reload tableview
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var favoriteMovies: [KPJMovie] = []
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // cant forget to set delegate
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // since movies is optional, if it contains nil, set numberofrows to 0
        return movies?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}

        // grabbing the movie from the index
        let movie = movies?[indexPath.row]
        // sending the movie to the custom cell to update the views
        cell.movie = movie

        return cell
    }
    
    // MARK: - SearchBar Functions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // unwrapping the searchbar text to be sure it exists and isn't empty
        guard let searchText = searchBar.text, !searchText.isEmpty else {return}
        //fetching the movies with the searchtext
        KPJMovieController.fetchMovies(fromSearchTerm: searchText) { (results) in
            self.movies = results
        }
        // getting rid of keyboard after searching
        searchBar.resignFirstResponder()
        // resetting the searchBar text after searching
        searchBar.text = ""
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMovieDetail" {
            guard let destinationVC = segue.destination as? MovieDetailViewController, let indexPath = tableView.indexPathForSelectedRow else {return}
            destinationVC.movie = movies?[indexPath.row]
        }
    }
}
