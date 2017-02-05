   /**
    * Copyright (c) 2017 Ryan Liszewski
    *
    * Permission is hereby granted, free of charge, to any person obtaining a copy
    * of this software and associated documentation files (the "Software"), to deal
    * in the Software without restriction, including without limitation the rights
    * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    * copies of the Software, and to permit persons to whom the Software is
    * furnished to do so, subject to the following conditions:
    *
    * The above copyright notice and this permission notice shall be included in
    * all copies or substantial portions of the Software.
    *
    * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    * THE SOFTWARE.
    *
    * MovieCollectionViewController.Swift
    *
    * This is the CollectionViewController for the Flickster App. It makes an
    * API call to the movie database (https://developers.themoviedb.org/3/getting-started)
    * and populates the collection view with umovies in theatre's images, and rating
    * displayed as 5 stars using the UIControl Cosomos. (https://github.com/marketplacer/Cosmos)
    *
    */

import UIKit
import MBProgressHUD
import AFNetworking
import Cosmos

class MovieCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var networkErrorLabel: UILabel!
    
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        collectionView.insertSubview(refreshControl, at: 0)
        
        searchBar.delegate = self
        searchBar.barStyle = UIBarStyle.blackTranslucent
        searchBar.placeholder = "Search for Movies in Theatres"
        
        networkErrorView.isHidden = true
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.movieApiCall()
    }

    func movieApiCall() -> Void {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    MBProgressHUD.hide(for: self.view, animated:true)
           
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.filteredMovies = self.movies
                    
                    self.collectionView.reloadData()
                    self.networkErrorView.isHidden = true
                    self.searchBar.isHidden = false
                }
            } else {
                self.networkError()
                self.movieApiCall()
            }
        }
        task.resume()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl){
        self.movieApiCall()
        refreshControl.endRefreshing()
    }
    
    ///Called if it there is no network error
    func networkError() -> Void{
        networkErrorLabel.layer.masksToBounds = true
        networkErrorLabel.layer.cornerRadius = 5
        self.searchBar.isHidden = true
        self.networkErrorView.isHidden = false
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let filteredMovies = filteredMovies{
            return filteredMovies.count
        }else if let movies = movies{
            return movies.count
        }else{
            return 0
        }
    }
    /**
     
    
 
    */
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell" , for: indexPath as IndexPath) as! CollectionViewCell
       
        cell.shareIconImageView.alpha = 0.2
        
        cell.shareIconImageView.image = #imageLiteral(resourceName: "shareIcon")
        cell.favoriteIconImageView.image = #imageLiteral(resourceName: "favoriteIcon")
        
        cell.cosmosView.settings.updateOnTouch = false
        cell.cosmosView.settings.fillMode = .precise
        
        let movie: NSDictionary
        
        if (searchBar.text != "") {
            movie = filteredMovies![indexPath.row]
        }else{
            movie = movies![indexPath.row]
        }
        
        let rating = movie["vote_average"] as! Double
        cell.cosmosView.rating = rating / 2
        
        let posterPath = movie["poster_path"] as! String
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        let imageUrl = NSURLRequest(url: NSURL(string: baseUrl + posterPath) as! URL)
        
        cell.photoViewCell.setImageWith(imageUrl as URLRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) in
            if imageResponse != nil {
                print("Imag wwas not cached, fade in image")
                cell.photoViewCell.alpha = 0.0
                cell.photoViewCell.image = image
                UIView.animate(withDuration: 0.3, animations: { () -> Void in cell.photoViewCell.alpha = 1.0
                })
            } else {
                print("Image was not cached so just update the image")
                cell.photoViewCell.image = image
            }
    
        }) { (imageRequest, imageResponse, error) in
            print(error)
        }
        return cell
    }
    
    ///Filter's the movies by their respective title when text is entered in the search bar.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        filteredMovies = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return (movie["title"] as! String).range(of: searchText, options: .caseInsensitive) != nil
        })
        collectionView.reloadData()
    }
    
    //Called when text begins to entered. Displays cancel bar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    ///Dismisses the searchbar when the cancel button is pressed
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.collectionView.reloadData()
    }
    
    ///Begins search when searchbar button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}
