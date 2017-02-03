//
//  MovieCollectionViewController.swift
//  Flickster
//
//  Created by Ryan Liszewski on 2/1/17.
//  Copyright © 2017 Smiley. All rights reserved.
//

import UIKit
import MBProgressHUD
import AFNetworking

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
        
        searchBar.delegate = self
        searchBar.barStyle = UIBarStyle.blackTranslucent

        networkErrorView.isHidden = true

        let refreshControl = UIRefreshControl()
        collectionView.insertSubview(refreshControl, at: 0)
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.movieApiCall()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func movieApiCall() {
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
                
            }else{
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
    
    func networkError(){
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
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell" , for: indexPath as IndexPath) as! CollectionViewCell
       
        let movie: NSDictionary
        
        if (searchBar.text != "") {
            movie = filteredMovies![indexPath.row]
        }else{
            movie = movies![indexPath.row]
        }
        
        
        //let movie = filteredMovies![indexPath.row]
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
            }else{
                print("Image was not cached so just update the image")
                cell.photoViewCell.image = image
            }
    
        }) { (imageRequest, imageResponse, error) in
            print(error)
        }
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        filteredMovies = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return (movie["title"] as! String).range(of: searchText, options: .caseInsensitive) != nil
        })
        collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
