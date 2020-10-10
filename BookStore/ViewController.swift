//
//  ViewController.swift
//  BookStore
//
//  Created by Kaio Dantas on 09/10/20.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var textResult: UILabel!
    
    
    var bookList:[Book] = []
    var page = 0
    var perpage = 20
    var total = 0
    
    var searchString = ""
    
    private var dataService: DataService = DataService()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: 106, height: 106)

        loading.stopAnimating()


        self.collectionView.reloadData()
        self.searchBar.delegate = self

    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }



    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchBar.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        if(searchBar.text! != ""){
            self.searchString =  searchBar.text!.replacingOccurrences(of: " ", with: ",")
            clearSearch()
            conectBooksAPI(searchText: self.searchString, page: page)
            self.searchBar.endEditing(true)
        }
    }

    
    
    func clearSearch(){
        self.bookList.removeAll()
        self.collectionView.reloadData()
        page = 0
        total = 0
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






    var error: Error? {
        didSet {
            self.showMessage(message: NSLocalizedString("impossible_load", comment: "Não foi possível carregar a lista de livros."))
        }
    }
    var isLoading: Bool = false {
        didSet {
            if(isLoading){
                self.loading.startAnimating()
            } else {
                self.loading.stopAnimating()
            }

        }
    }


    // MARK: - Network call
    func conectBooksAPI( searchText: String, page:Int){

        self.isLoading = true
        self.dataService.requestBooksList(with: searchText, maxResults:perpage, startIndex: (page * perpage), completion: { (booksResult, error) in
            if let error = error {
                self.error = error
                self.isLoading = false
                return
            }

            //IF IS OK
            self.isLoading = false

            if let booksResultsList = booksResult{
                if(booksResultsList.items.count == 0 ){ 
                    self.showMessage(message: NSLocalizedString("no_books", comment: "No books found. You can try again"))
                } else {
                    self.setBooks(books: booksResultsList.items)
                    self.total = booksResultsList.totalItems

                    self.resultView.isHidden = false
                    self.textResult.text = "\(booksResultsList.totalItems) "+NSLocalizedString("books_found", comment: "livros encontrados")

                    self.collectionView.reloadData()
                }
            } else {
                self.showMessage(message: NSLocalizedString("impossible_load", comment: "Não foi possível carregar a lista de livros. Por favor, tente novamente."))
            }

        })
    }




    func showMessage(message:String){
        self.loading.stopAnimating()
        if ((self.view.window != nil) && (self.isViewLoaded )){

            let alert = CustomUIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("ok", comment: "OK"), style: UIAlertAction.Style.cancel) { (UIAlertAction) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true) { () -> Void in }

        }
    }




    
    func setBooks(books:[Book]){

        for book in books{
            bookList.append(book)
        }

    }












    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height * 4 {
            loadNewItems()
        }
    }


    func loadNewItems() {
        if(self.total > ((self.page + 1) * perpage)){
            self.page = self.page + 1
            conectBooksAPI(searchText: searchString, page: self.page)
        }

    }

}





extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let padding: CGFloat = 25
        let collectionCellSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionCellSize/2, height: collectionCellSize/2)

    }

}
