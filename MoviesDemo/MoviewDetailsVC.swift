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
    //var
    var movieDetailsData = [[String: AnyObject]]()
    let formatter = DateFormatter()
    let dateFormatterToDisplay = DateFormatter()
    
    //outlets
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var details: UITextView!
    
    func readDetails() -> Void
    {
        let api_url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(key)&language=en-US")
        Alamofire.request(api_url!).responseJSON { response in
            let json = JSON(response.result.value!)
            
            let rating =  json["vote_average"].double
           
            self.formatter.dateFormat = "yyyy-MM-dd"
            self.dateFormatterToDisplay.dateFormat = "MMM dd,yyyy"
            let dateInDateFormat = self.formatter.date(from: (json["release_date"].string)!)
            
            self.name.text = json["original_title"].string
            self.releaseDate.text = "Release Date : " + (self.dateFormatterToDisplay.string(from: dateInDateFormat!))
            self.rating.text = "\(rating ?? 0.0)"
            self.details.text =  json["overview"].string
            
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
    }
}
