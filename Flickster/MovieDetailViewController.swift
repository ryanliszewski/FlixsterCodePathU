//
//  MovieDetailViewController.swift
//  Flickster
//
//  Created by Ryan Liszewski on 5/9/17.
//  Copyright © 2017 Smiley. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var moviePosterView: UIImageView!
    @IBOutlet weak var movieScrollView: UIScrollView!
    @IBOutlet weak var movieDescriptionView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let title = movie["title"] as? String
        movieTitleLabel.text = title
        movieTitleLabel.sizeToFit()
        
        let overview = movie["overview"] as? String
        movieOverviewLabel.text = overview
        movieOverviewLabel.sizeToFit()

        movieScrollView.contentSize = CGSize(width: movieScrollView.frame.size.width, height: movieDescriptionView.frame.origin.y + (movieOverviewLabel.frame.size.height) * 3)
        
        loadMovieImage()
    }
    
    /*
    //MARK
    
    //Load's the movie's detail image view with a NSURL request.
    */

    private func loadMovieImage(){
   
        if let posterPath = movie["poster_path"] as? String {
            let smallImageRequest = NSURLRequest(url: NSURL(string: M.URL.Image.SmallImage + posterPath) as! URL)
            let largeImageRequest = NSURLRequest(url: NSURL(string: M.URL.Image.LargeImage + posterPath) as! URL)
            
            self.moviePosterView.setImageWith(smallImageRequest as URLRequest, placeholderImage: nil, success: { (smallImageRequest, smallImageResponse, smallImage) in
                
                if smallImageResponse != nil {
                    self.moviePosterView.alpha = 0.0
                    self.moviePosterView.image = smallImage
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        
                        self.moviePosterView.alpha = 1.0
                    }, completion: { (sucess) -> Void in
                        
                    self.moviePosterView.setImageWith(largeImageRequest as URLRequest, placeholderImage: smallImage, success: {(largeImageRequest, largeImageResponse, largeImage) -> Void in
                            
                            self.moviePosterView.image = largeImage
                        },
                        failure: { (request, response, error) -> Void in
                        //add default image
                        })
                    })
                } else {
                    self.moviePosterView.image = smallImage
                }
            }, failure: { (imageRequest, imageResponse, error) in
                print(error)
            })
        }
    }
    
    /*
    //MARK: Navigation
    */
    
}
