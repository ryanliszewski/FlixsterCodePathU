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

    
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.delegate = self
        collectionView.dataSource = self

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
                    
                    self.filteredMovies = movieTitles["titles"] as? [String]
                    
                    
                    
                    self.collectionView.reloadData()
                    //self.networkErrorView.isHidden = true
                }
                
            }else{
                //self.networkError()
                self.movieApiCall()
            }
            
        }
        task.resume()
        
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        
        self.movieApiCall()
        refreshControl.endRefreshing()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies{
            return movies.count
        }else{
            return 0
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell" , for: indexPath as IndexPath) as! CollectionViewCell
       
        print(indexPath)
        let movie = movies![indexPath.row]
        let posterPath = movie["poster_path"] as! String
        //print(posterPath)
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        cell.photoViewCell.setImageWith(imageUrl as! URL)
        
        
        return cell
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
//        filteredMovies = searchText.isEmpty ? movies : movies.filter({(dataString: String) -> Bool in
//            // If dataItem matches the searchText, return true to include it
//            return dataDictionary.range(of: searchText, options: .caseInsensitive) != nil
//        })
//        collectionView.reloadData()
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
