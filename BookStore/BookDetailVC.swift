//
//  BookDetailVC.swift
//  BookStore
//
//  Created by Kaio Dantas on 09/10/20.
//

import Foundation
import Kingfisher

class BookDetailVC: UIViewController{
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var subtitleLb: UILabel!
    @IBOutlet weak var authorsLb: UILabel!
    @IBOutlet weak var publisherLb: UILabel!
    @IBOutlet weak var pagesLb: UILabel!
    @IBOutlet weak var descriptionLb: UILabel!
    @IBOutlet weak var buyBt: UIButton!
    @IBOutlet weak var favoriteBt: UIButton!
    
    var book:Book?
    var bookUrl = ""
    var favorite = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !(book == nil){
            
            if let imgUrl = book?.volumeInfo?.imageLinks?.thumbnail ?? book?.volumeInfo?.imageLinks?.smallThumbnail{
                guard let url = URL.init(string: imgUrl) else {
                    return
                }
                
                self.imgView.kf.indicatorType = .activity
                self.imgView.kf.setImage(with: url, completionHandler:  { result in
                    switch result {
                        case .success(let value):
                            print("Image: \(value.image). Got from: \(value.cacheType)")
                        case .failure(let error):
                            print("Error: \(error)")
                            self.imgView.image = UIImage(named: "book")
                    }
                })
            }
            
            titleLb.text = book?.volumeInfo?.title ?? ""
            subtitleLb.text = book?.volumeInfo?.subtitle ?? ""
            var strAuthors = ""
            for author in book?.volumeInfo?.authors ?? [] {
                strAuthors = strAuthors + author + ". "
            }
            authorsLb.text = strAuthors
            publisherLb.text = book?.volumeInfo?.publisher ?? "-"
            
            if let pags = book?.volumeInfo?.pageCount {
                pagesLb.text = "\(pags)"
            } else {
                pagesLb.text = ""
            }
            
            descriptionLb.text = book?.volumeInfo?.description ?? "-"
            
            
            if let bookLink = book?.volumeInfo?.previewLink ?? book?.volumeInfo?.infoLink {
                buyBt.isHidden = false
                self.bookUrl = bookLink
            }
            
            let defaults = UserDefaults.standard
            let dictFavorites = defaults.dictionary(forKey:  "arrayFavorites") ?? [String:Book]()
            if (dictFavorites.index(forKey: book?.id ?? "0") != nil){
                favorite = true
                favoriteBt.setImage(UIImage(named: "favorite"), for: .normal)
            }
            favoriteBt.isHidden = false
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    
    @IBAction func buyBook(_ sender: Any) {
        if(self.bookUrl != ""){
            guard let url = URL(string: self.bookUrl) else { return }
            UIApplication.shared.open(url)
        }
    }
    
    
    @IBAction func clickFavoriteBt(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        var dictFavorites = defaults.dictionary(forKey:  "arrayFavorites") ?? [String:Book]()

        if let id = book?.id {
            if(!favorite) {
                dictFavorites[id] = try? PropertyListEncoder().encode(book)
                favoriteBt.setImage(UIImage(named: "favorite"), for: .normal)
            } else {
                dictFavorites.removeValue(forKey: id)
                favoriteBt.setImage(UIImage(named: "unfavorite"), for: .normal)
            }
            favorite = !favorite
        }
        
        defaults.set(dictFavorites , forKey: "arrayFavorites")
        defaults.synchronize()
    }
}
