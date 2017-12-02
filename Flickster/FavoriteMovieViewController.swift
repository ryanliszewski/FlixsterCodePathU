//
//  FavoriteMovieViewController.swift
//  Flickster
//
//  Created by Ryan Liszewski on 2/15/17.
//  Copyright © 2017 Smiley. All rights reserved.
//

import UIKit

class FavoriteMovieViewController: UIViewController {

    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("test")
        
        let movie = userDefaults.dictionary(forKey: "FavoriteMovie")
        
        let smallImageUrl = "https://image.tmdb.org/t/p/w45"
        let largeImageUrl = "https://image.tmdb.org/t/p/original"
        
        
        if let posterPath = movie?["poster_path"] as? String {
            let smallImageRequest = NSURLRequest(url: NSURL(string: smallImageUrl + posterPath) as! URL)
            let largeImageRequest = NSURLRequest(url: NSURL(string: largeImageUrl + posterPath) as! URL)
            
            self.posterImageView.setImageWith(smallImageRequest as URLRequest, placeholderImage: nil, success: { (smallImageRequest, smallImageResponse, smallImage) in
                
                if smallImageResponse != nil {
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = smallImage
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        
                        self.posterImageView.alpha = 1.0
                        
                    }, completion: { (sucess) -> Void in
                        
                        
                        self.posterImageView.setImageWith(largeImageRequest as URLRequest, placeholderImage: smallImage, success: {(largeImageRequest, largeImageResponse, largeImage) -> Void in
                            
                            self.posterImageView.image = largeImage
                            
                        },
                                                          
                       failure: { (request, response, error) -> Void in
                                                            //add default image
                        })
                    })
                } else {
                    self.posterImageView.image = smallImage
                }
                
            }, failure: { (imageRequest, imageResponse, error) in
                print(error)
            })
        }
        titleLabel.text = movie?["title"] as? String
        overviewLabel.text = movie?["overview"] as? String 
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
