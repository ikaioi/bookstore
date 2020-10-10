//
//  FavoritesVC.swift
//  BookStore
//
//  Created by Kaio Dantas on 09/10/20.
//

import Foundation
import Kingfisher

class FavoritesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var textResult: UILabel!
    
    
    var bookList:[Book] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: 106, height: 106)
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = UserDefaults.standard
        let dictFavorites = defaults.dictionary(forKey:  "arrayFavorites") ?? [String:Book]()
        bookList.removeAll()
        
        for key in dictFavorites.keys{
            guard let book = try? PropertyListDecoder().decode(Book.self, from: dictFavorites[key] as! Data) else {
                return
            }
            
            bookList.append(book)
        }
        
        self.resultView.isHidden = false
        self.textResult.text = "\(bookList.count) "+NSLocalizedString("books_found", comment: "livros encontrados")
        
        loading.stopAnimating()
        
        self.collectionView.reloadData()
    }
    
    
    
   
    
    
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_book", for: indexPath) as! CellBook
        cell.layer.cornerRadius = 3.0
        
        let book = self.bookList[indexPath.row]
        cell.setCell(book)
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            if let cell = collectionView.cellForItem(at: indexPath)  {
                let imagem = cell.viewWithTag(1) as! UIImageView
                imagem.transform = .init(scaleX: 0.90, y: 0.90)
                cell.contentView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.6)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            if let cell = collectionView.cellForItem(at: indexPath)  {
                let imagem = cell.viewWithTag(1) as! UIImageView
                imagem.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let book = self.bookList[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "book_details") as! BookDetailVC
        vc.book = book
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}





extension FavoritesVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 25
        let collectionCellSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionCellSize/2, height: collectionCellSize/2)
        
    }
    
}
