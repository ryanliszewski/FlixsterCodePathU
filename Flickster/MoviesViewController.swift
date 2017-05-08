//
//  MoviesViewController.swift
//  Flickster
//
//  Created by Ryan Liszewski on 1/29/17.
//  Copyright © 2017 Smiley. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var networkErrorView: UIView!
  
    @IBOutlet weak var networkErrorLabel: UILabel!
    
    var movies: [NSDictionary]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        networkErrorView.isHidden = true
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        self.movieApiCall()
        
        
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
                    print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
                    self.networkErrorView.isHidden = true
                }
                
            }else{
                self.networkError()
                self.movieApiCall()
            }
      
        }
        task.resume()

    }
    
    
    func refreshControlAction(_ refreshControl: UIRefreshControl){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        self.movieApiCall()
        refreshControl.endRefreshing()
    }
    
    func networkError(){
        networkErrorLabel.layer.masksToBounds = true
        networkErrorLabel.layer.cornerRadius = 5
        self.networkErrorView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if let movies = movies {
            return movies.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath as IndexPath)
        
//        let movie = movies![indexPath.row]
//        let title = movie["title"] as! String
//        let overview = movie["overview"] as! String
//        let posterPath = movie["poster_path"] as! String
//        
//        let baseUrl = "https://image.tmdb.org/t/p/w500"
//        
//        let imageUrl = NSURL(string: baseUrl + posterPath)
//   
//        cell.posterView.setImageWith(imageUrl as! URL)
//        
//        
//        cell.titleLabel.text = title
//        cell.overViewLabel.text = overview
        
        
        return cell;
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
