//
//  CategoryDetailsViewController.swift
//  DocumentRepository
//
//  Created by Gnani on 8/12/17.
//  Copyright © 2017 Gnani. All rights reserved.
//

import UIKit
import SDWebImage

enum SortState {
    case unSorted
    case ascending
    case descending
}

class CategoryDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var orderImageView: UIImageView!
    
    var categorieslist : [AnyObject] = []
    var categoryListSortState: SortState = .unSorted
    
    var filteredCategorieslist : [AnyObject] = []
    var isSearchActive: Bool = false
    
    var selectedcategory : String = ""
    var categoryTitle : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = categoryTitle
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        var image = UIImage(named: "Back")
        
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backaction))
        
        apiRequestforCategories()
        
        tableview.estimatedRowHeight = 70
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.tableFooterView = UIView()
        tableview.register(UINib(nibName: "CategoryDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryDetailTableViewCell")
        
        addrightNavBtns()
        
        nameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sortAction)))
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapOnOutside)))
    }

    
    func addrightNavBtns()
    {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "plus")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState())
        button.tintColor = UIColor.white
        button.addTarget(self,  action: #selector(self.addmoreAction), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
        
        let barButton = UIBarButtonItem(customView: button)
        
        let button1: UIButton = UIButton()
        button1.setImage(UIImage(named: "more_ic")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState())
        button1.tintColor = UIColor.white
        button1.addTarget(self,  action: #selector(self.addoptionsAction), for: UIControlEvents.touchUpInside)
        button1.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
        let barButton1 = UIBarButtonItem(customView: button1)
        
        self.navigationItem.rightBarButtonItems = [barButton1,barButton]
    }
    
    func addoptionsAction(sender : UIButton)
    {
        
    }
    
    func addmoreAction()
    {
        alert().alertview(title: "", subtitle: "Functionality not enabled", buttontitle: "OK", parent: self)
    }
    
    func apiRequestforCategories()
    {
        
        let urlString = "https://s3.ap-south-1.amazonaws.com/mobileassignment/repository/docs_list/"+selectedcategory
        
        let url: URL = URL(string: urlString.addingPercentEscapes(using: String.Encoding.utf8)!)!
        
        let request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 15.0)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }else{
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
//                        print("Synchronous\(jsonResult)")
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.categorieslist = jsonResult["documents"] as! [AnyObject]
                                self.tableview.reloadData()
                            })
                        })
                        
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func backaction()  {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func sortAction() {
        
        let comparisonResult: ComparisonResult
        
        if categoryListSortState == .unSorted || categoryListSortState == .descending {
            comparisonResult = .orderedAscending
            orderImageView.image = UIImage(named: "sort_asc_ic")
            categoryListSortState = .ascending
            
        } else {
            comparisonResult = .orderedDescending
            orderImageView.image = UIImage(named: "sort_desc_ic")
            categoryListSortState = .descending
        }
        
        categorieslist.sort{
            
            if let dictionary1 = $0 as? Dictionary<String, AnyObject?>, let dictionary2 = $1 as? Dictionary<String, AnyObject?>, let docName1 = dictionary1["doc_name"] as? String, let docName2 = dictionary2["doc_name"] as? String  {
                return (docName1.localizedCaseInsensitiveCompare(docName2) == comparisonResult)
            } else {
                return false
            }
        }
        
        tableview.reloadData()
    }
    
    func tapOnOutside() {
        if isSearchActive {
            isSearchActive = false
            searchbar.endEditing(true)
            tableview.reloadData()
        }
    }

}
extension CategoryDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearchActive {
            return filteredCategorieslist.count
        } else {
            return categorieslist.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var category: Dictionary<String, AnyObject>? = Dictionary<String, AnyObject>()
        
        if isSearchActive {
            category = indexPath.row < filteredCategorieslist.count ? filteredCategorieslist[indexPath.row] as? Dictionary<String, AnyObject> : nil
            
        } else {
            category = indexPath.row < categorieslist.count ? categorieslist[indexPath.row] as? Dictionary<String, AnyObject> : nil
        }
        
        if let category = category {
            
            let cell: CategoryDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CategoryDetailTableViewCell") as! CategoryDetailTableViewCell
            cell.titleLabel.text = category["doc_name"] as? String
            if let docsize = category["doc_size"] as? String{
                cell.filesizeLabel.text = "File Size " + docsize
            }else
            {
                cell.filesizeLabel.text = ""
            }
            
            if let docImgurl = category["doc_url"] as? String{
            
            cell.imgView.sd_setImage(with: URL(string: docImgurl), placeholderImage: UIImage(named: ""))
            }else
            {
               cell.imgView.image = nil
            }
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
}

extension CategoryDetailsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearchActive = false;
        searchbar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false;
        searchbar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false;
        searchbar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            isSearchActive = false
            searchbar.endEditing(true)
            tableview.reloadData()
            return
        }
        
        filteredCategorieslist = categorieslist.filter({ (text) -> Bool in
            let tmp: NSString = text["doc_name"] as! NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if filteredCategorieslist.count > 0 {
            isSearchActive = true;
        }
        tableview.reloadData()
    }

}

extension CategoryDetailsViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSearchActive = false
        searchbar.endEditing(true)
        tableview.reloadData()
    }
}
