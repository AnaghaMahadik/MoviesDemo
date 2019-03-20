//
//  MoviewDetailsVC.swift
//  MoviesDemo
//
//  Created by CRDR MAC1 on 19/03/19.
//  Copyright © 2019 myMac. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class MoviewDetailsVC: UIViewController {
    var movieDetailsData = [[String: AnyObject]]()
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var details: UITextView!
    
    func readDetails()
    {
        let api_url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(key)&language=en-US")
        Alamofire.request(api_url!).responseJSON { response in
            let json = JSON(response.result.value!)
            
            self.name.text = json["original_title"].string
            self.details.text =  json["overview"].string
            self.releaseDate.text = "Release Date : " + (json["release_date"].string!)
            let rating =  json["vote_average"].double
            self.rating.text = "\(rating ?? 0.0)"
            
            Alamofire.request(("https://image.tmdb.org/t/p/w500\(json["backdrop_path"].string ?? "")")).responseData { (response) in
                if response.error == nil {
                    // Show the downloaded image:
                    if let data = response.data {
                        self.img.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        readDetails()
        //name.text = movieDetailsData["title"]
    }
    
   
}
