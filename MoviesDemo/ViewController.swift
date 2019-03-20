//
//  ViewController.swift
//  MoviesDemo
//
//  Created by CRDR MAC1 on 18/03/19.
//  Copyright © 2019 myMac. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

var movieId = Int()
let key = "2758fdf8c2125bb54354ddc86d04c4a2"

class ViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate {
    //var
    var keyType = "popular"
    var movieData = [[String: AnyObject]]()
    private var searchController = UISearchController(searchResultsController: nil)
    var searchActive : Bool = false
    
    //Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func showComponent(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            keyType = "popular"
            readData()
        } else {
            keyType = "top_rated"
            readData()
        }
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        // Create the search controller and specify that it should present its results in this same view
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable
        // Make this class the delegate and present the search
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    //Search action
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActive = false
        dismiss(animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        readData()
        self.collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            Alamofire.request("https://api.themoviedb.org/3/search/movie?api_key=\(key)&query=\(searchText)").responseJSON { (responseData) -> Void  in
                if ((responseData.result.value) != nil){
                    let jsonData = JSON(responseData.result.value!)
                    if let searchMovies = jsonData["results"].arrayObject {
                        self.movieData = searchMovies as! [[String : AnyObject]]
                    }
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func readData()
    {
        let api_url = URL(string: "https://api.themoviedb.org/3/movie/\(keyType)?api_key=\(key)&language=en-US")
        Alamofire.request(api_url!).responseJSON { response in
            let json = JSON(response.result.value!)
            self.movieData = json["results"].arrayObject as! [[String : AnyObject]]
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readData()
        
        //search Controller
        searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.delegate = self
            controller.searchBar.delegate = self
            controller.dimsBackgroundDuringPresentation = false
            controller.hidesNavigationBarDuringPresentation = true
            controller.searchBar.placeholder = "Search here"
            controller.searchBar.sizeToFit()
            return controller
        })()
      }
    }

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! movieCell
        var data = movieData[indexPath.row]
        
        cell.name.text = data["title"] as? String
        Alamofire.request(("https://image.tmdb.org/t/p/w500\(data["poster_path"]  ?? "" as AnyObject)")).responseData { (response) in
            if response.error == nil {
                // Show the downloaded image:
                if let data = response.data {
                    cell.img.image = UIImage(data: data)
                }
              }
           }
       return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var data = movieData[indexPath.row]
        movieId =  (data["id"] as? Int)!
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let myVc = storyBoard.instantiateViewController(withIdentifier: "moviewDetails") as! MoviewDetailsVC
        navigationController?.pushViewController(myVc, animated: true)
    }
}

class movieCell: UICollectionViewCell
{
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
}
