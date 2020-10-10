//
//  CellBook.swift
//  BookStore
//
//  Created by Kaio Dantas on 09/10/20.
//

import Foundation
import UIKit
import Kingfisher

class CellBook: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    
    func setCell(_ book: Book){
        
        title.text = ""
        self.image.image = UIImage(named: "book")
        
        
        if let imgUrl = book.volumeInfo?.imageLinks?.thumbnail ?? book.volumeInfo?.imageLinks?.smallThumbnail{
            guard let url = URL.init(string: imgUrl) else {
                return
            }
            
            self.image.kf.indicatorType = .activity
            self.image.kf.setImage(with: url, completionHandler:  { result in
                switch result {
                    case .success(let value):
                        print("Image: \(value.image). Got from: \(value.cacheType)")
                    case .failure(let error):
                        print("Error: \(error)")
                        self.image.image = UIImage(named: "book")
                        
                }
            })
        }
        
        title.text = book.volumeInfo?.title ?? ""
        
        
    }
}
