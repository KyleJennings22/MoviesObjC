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
    @IBOutlet weak var favoritesBarButtonItem: UIBarButtonItem!
    
    
    // MARK: - Properties
    var movies: [KPJMovie]? {
        didSet {
            // need to be on the main queue to reload tableview
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // empty array to hold our favorite movies
    var favoriteMovies: [KPJMovie] = []
    
    // property observer to see if favorites button is on or off
    var favoriteIsOn: Bool? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // cant forget to set delegate
        searchBar.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func favoritesButtonTapped(_ sender: UIBarButtonItem) {
        if favoriteIsOn == nil {
            favoriteIsOn = true
            favoritesBarButtonItem.title = "Cancel"
        } else if favoriteIsOn == true {
            favoriteIsOn = false
            favoritesBarButtonItem.title = "Favorites"
        } else if favoriteIsOn == false {
            favoriteIsOn = true
            favoritesBarButtonItem.title = "Cancel"
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if favoriteIsOn == true {
            // returning the count of favorite movies instead of movies
            return favoriteMovies.count
        } else {
            // since movies is optional, if it contains nil, set numberofrows to 0
            return movies?.count ?? 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // casting our cell as our custom MovieTableViewCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        
        if favoriteIsOn == true {
            // grabbing the movie from the index of favoriteMovies
            let movie = favoriteMovies[indexPath.row]
            // sending the movie to the custom cell to update the views
            cell.movie = movie
        } else {
            // grabbing the movie from the index of movies
            let movie = movies?[indexPath.row]
            // sending the movie to the custom cell to update the views
            cell.movie = movie
        }
        
        return cell
    }
    
    // MARK: - Editable Table View Cells Function
    
    // I know this is deprecated but I couldn't find a different way to do this
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {

        // creating our favorite action
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            // creating a movie from our movies index
            guard let movie = self.movies?[index.row] else {return}
            // appending the movie to the favorite movie array
            self.favoriteMovies.append(movie)
        }
        favorite.backgroundColor = .orange

        return [favorite]
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
