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
    * API call to the movie database (https://developers.themoviedb.org/3/getting*-started)
gitand populates the collection view with umovies in theatre's images, and rating
    * displayed as 5 stars using the UIControl Cosomos. (https://github.com/marketplacer/Cosmos)
    *
    */

import UIKit
import MBProgressHUD
import AFNetworking
import Cosmos
import MapKit
import SKSplashView
   

class MovieCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, CLLocationManagerDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate{
    
    @IBOutlet weak var navigationBar: UINavigationItem!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var networkErrorLabel: UILabel!
    
    var searchController : UISearchController!
    
    var long: Double!
    var lat: Double!
    
    let userDefults = UserDefaults.standard
    
    var currentPageNumber = 1
    
    
    var isMoreDataLoading = false
    
    var movies: [NSDictionary]!
    var filteredMovies: [NSDictionary]!
    var endpoint: String!
    var refreshControl: UIRefreshControl!
    
    var locationManager = CLLocationManager()
    
    var searchBar: UISearchBar = UISearchBar()
    var favoriteCounts: Int!
    
    var favoriteMovies: [String: Any]!
    
    
    
    
    /**
        Initializes the collectionview
     
        ##Important Notes##
        1. Initializes refresh control
        2. Hides the network error view
        3. Displays the MBProgreeHUD
        4. Calls movieApiCall()
     
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let test = false
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 3, bottom: 40, right: 3)
        
        if(test){
            layout.itemSize = CGSize(width: screenWidth - 10, height: screenHeight / 1.5)
        }else{
            layout.itemSize = CGSize(width: screenWidth / 2 - 5, height: screenHeight / 3)
        }
        
        
        let settingsButton = UIButton(type: .custom)
        settingsButton.setImage(#imageLiteral(resourceName: "Image-2"), for: .normal)
        settingsButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        settingsButton.addTarget(self, action: #selector(MovieCollectionViewController.settingsButtonClicked), for: .touchUpInside)
        
        //self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
        
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 4
        //collectionView!.collectionViewLayout = layout
        collectionView.setCollectionViewLayout(layout, animated: true)
      
        self.tabBarController?.tabBar.barTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.frame = CGRect(x: 0, y: 627, width: collectionView.frame.size.width, height: 40)
        self.tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 0.843980968, green: 0.4811213613, blue: 0.2574525177, alpha: 1)
//        
//        
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
        
    
//        self.searchController = UISearchController(searchResultsController:  nil)
//        self.searchController.hidesNavigationBarDuringPresentation = false
//        self.searchController.dimsBackgroundDuringPresentation = true
//        self.searchController.searchBar.delegate = self
//        self.searchController.searchBar.placeholder = "Search For Movies"
//        self.searchController.searchBar.searchBarStyle = .minimal
        
        self.navigationItem.titleView = searchBar
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.placeholder = "Search for Movies"
        
//        let frame = CGRect(x: 0, y: 0, width: 300, height: 44)
//        let titleView = UIView(frame: frame)
//        searchController.searchBar.backgroundImage = UIImage()
//        searchController.searchBar.frame = frame
//        titleView.addSubview(searchController.searchBar)
//        navigationItem.titleView = titleView
        
        self.extendedLayoutIncludesOpaqueBars = true
        

       
        
        
        //self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "Image-2")
        //self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        

        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        collectionView.insertSubview(refreshControl, at: 0)

        networkErrorView.isHidden = true
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        self.movieApiCall()
    }

    
    /**
        Makes an API call to get a dictionary of Movies.
     
        ## Important Notes ##
        1. Calls the Movie Database - https://developers.themoviedb.org/3/getting-started
        2. Hides the MBProdress Hud
        3. Calls networkError() if the API call fails
     
    */
    
    func settingsButtonClicked(){
        
        self.performSegue(withIdentifier: "settings", sender: self)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func movieApiCall() -> Void {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)&page=\(currentPageNumber)")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    MBProgressHUD.hide(for: self.view, animated:true)
           
                    
                    
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    print(self.movies!)
                    
                    self.filteredMovies = self.movies
                    
                    self.collectionView.reloadData()
                    self.networkErrorView.isHidden = true
                    //self.searchBar.isHidden = false
                    
                   
                    MBProgressHUD.hide(for: self.view, animated:true)
                    self.refreshControl.endRefreshing()
                    
                }
            } else {
                self.networkError()
                self.movieApiCall()
            }
        }
        task.resume()
    }
    
    
    
    
    /**
        Called when the user pulls down on the view. 
     
        ## Important Notes ##
        1. Shows the refresh progress indicator
        2. Calls the movieApiCall()
        3. Hides the refresh progress indicator
    
    */
    func refreshControlAction(_ refreshControl: UIRefreshControl){
        currentPageNumber = 1
        self.movieApiCall()
    }
    
    /**
        Called when there is a network error and the API call fails.
     
        ## Important Notes ##
        1. Displays the network error label
        2. Hides the search bar
    
    */
    func networkError() -> Void{
        networkErrorLabel.layer.masksToBounds = true
        networkErrorLabel.layer.cornerRadius = 5
        //self.searchBar.isHidden = true
        self.networkErrorView.isHidden = false
        MBProgressHUD.hide(for: self.view, animated:true)
    }
    
    /**
        
        Sets the number of collection view cells in the collection view.
        
        ## Important Notes ##
        1. Returns the size of a movie dictionary
        2. Either all of them or a filterned one
    
    */
    

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let filteredMovies = filteredMovies, let movies = movies{
            if movies.count > filteredMovies.count{
                return filteredMovies.count
            }else if movies.count <= filteredMovies.count{
                return movies.count
            }
        }
       return 0
    }
    

    /**
        
        Initializes a collectionviewcell and populates it with a move.
     
        ##Important Notes##
        1.  Initilizes the cosmosView https://github.com/marketplacer/Cosmos
        2.  Adds the rating to the cosmoview with 1-5 star rating
        3.  Populates the cell with the movie's image
        4.  Fades in images when theyre first loaded.

    */
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell" , for: indexPath as IndexPath) as! CollectionViewCell
       
        //cell.favoriteIconImageView.image = #imageLiteral(resourceName: "favoriteIcon")
        
        cell.cosmosView.settings.updateOnTouch = false
        cell.cosmosView.settings.fillMode = .precise
        
        let movie: NSDictionary
        
        if (self.searchBar.text != "") {
            movie = filteredMovies![indexPath.row]
        }else{
            movie = movies![indexPath.row]
        }
        
        let rating = movie["vote_average"] as! Double
        cell.cosmosView.rating = rating / 2
        
        
        if let posterPath = movie["poster_path"] as? String {
            let largeImageUrl = "https://image.tmdb.org/t/p/original"
            let largeImageRequest = NSURLRequest(url: NSURL(string: largeImageUrl + posterPath) as! URL)
            
            cell.photoViewCell.setImageWith(largeImageRequest as URLRequest, placeholderImage: nil, success: { (largeImageRequest, largeImageResponse, largeImage) in
                
                if largeImageResponse != nil {
                    cell.photoViewCell.alpha = 0.0
                    cell.photoViewCell.image = largeImage
                    
                    UIView.animate(withDuration: 0.1, animations: { () -> Void in
                        
                        cell.photoViewCell.alpha = 1.0
                        
                    })
                    
                } else {
                    cell.photoViewCell.image = largeImage
                }
                
            }, failure: { (imageRequest, imageResponse, error) in
                print(error)
            })
        }
        
        cell.tapAction = {(cell) in
            print("FUCK YES")
            
            self.userDefults.set(movie, forKey: "FavoriteMovie")
            self.userDefults.synchronize()
            
        
            
        }
        
        
        
        return cell
    }
    
    /**
        
        Filter's the movies by their respective title when text is entered in the search bar.
            
        ## Important Notes ##
        1. Called when the user enters text in the search bar 
        2. Filters through the movie dictionary by title
    */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        filteredMovies = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return (movie["title"] as! String).range(of: searchText, options: .caseInsensitive) != nil
        })
        collectionView.reloadData()
        
    }
    
    /**
        Displays Cancel button on search bar.
        
     ## Important Notes ##
        1.Displays when user clicks on search bar
     
    */
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        
    }
    
    /**
        Dismisses the searchbar when the cancel button is pressed.
        
        ## Important Notes ##
        1. Reloads CollectionView Data
        2. Resets the search bar first responder
     
    */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.filteredMovies = movies
        
        //let test = userDefults.dictionary(forKey: "Rating")
        
      
        print("test")
        
        self.collectionView.reloadData()
    }
    
    /**
        Called when the search bar is clicked. 
     
        ## Important Notes ##
        1. Initializes searchbar first responder
    
    */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
    }
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MovieDetailViewSegue" {
            let movie: NSDictionary
            
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)
            if let filteredMovies = filteredMovies {
                movie = filteredMovies[indexPath!.row]
            } else {
                movie = movies![indexPath!.row]
            }
            
            let detailViewController = segue.destination as! MovieDetailViewController
            detailViewController.movie = movie
        } else if segue.identifier == "SettingsViewSegue" {
            
        }

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(!isMoreDataLoading){
            let scrollViewContentHeight = collectionView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - collectionView.bounds.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && collectionView.isDragging){
                isMoreDataLoading = true
                loadMoreData()
            }
            
        }
    }
    
    func loadMoreData(){
        currentPageNumber += 1
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)&page=\(currentPageNumber)")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    MBProgressHUD.hide(for: self.view, animated:true)
                    
                    
                    
                    let newMovies = dataDictionary["results"] as! [NSDictionary]
                    
                    self.movies?.append(contentsOf: newMovies)
                    
                    self.filteredMovies = self.movies
                    
                    self.collectionView.reloadData()
                    self.networkErrorView.isHidden = true
                    //self.searchBar.isHidden = false
                    
                    print(dataDictionary)
                    
                    MBProgressHUD.hide(for: self.view, animated:true)
                    self.refreshControl.endRefreshing()
                    
                }
            } else {
                self.networkError()
                self.movieApiCall()
            }
        }
        isMoreDataLoading = false
        task.resume()
    }
    
}
   
