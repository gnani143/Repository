//
//  CategoriesViewController.swift
//  DocumentRepository
//
//  Created by Gnani on 8/12/17.
//  Copyright © 2017 Gnani. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!

    
    var categorieslist : [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Repository"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        var image = UIImage(named: "Back")
        
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backaction))
        
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "plus")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState())
        button.tintColor = UIColor.white
        button.addTarget(self,  action: #selector(self.addmoreAction), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        apiRequestforCategories()
        
        tableview.estimatedRowHeight = 80
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.tableFooterView = UIView()
        tableview.register(UINib(nibName: "CategoriesTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoriesTableViewCell")
    }

    func addmoreAction()
    {
        alert().alertview(title: "", subtitle: "Functionality not enabled", buttontitle: "OK", parent: self)
    }
    
    func apiRequestforCategories()
    {
        
        let url: URL = URL(string: "https://s3.ap-south-1.amazonaws.com/mobileassignment/repository/doc_categories".addingPercentEscapes(using: String.Encoding.utf8)!)!
        
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
                        self.categorieslist = jsonResult["DocumentCategories"] as! [AnyObject]
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categorieslist.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categorieslist[indexPath.row]
        
        let cell: CategoriesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableViewCell") as! CategoriesTableViewCell
        if let backgroungImg = category["cat_background_img"] as? String{
            cell.backgroundImg.image = UIImage(named: backgroungImg)
        }else
        {
            cell.backgroundImg.image = nil
        }
        if let caticon = category["cat_icon"] as? String{
            cell.categoryIcon.image = UIImage(named: caticon)
        }else
        {
             cell.categoryIcon.image = nil
        }
        cell.categoryTitle.text = category["cat_name"] as? String
        cell.numofDocs.text = (category["num_docs"] as? Int)?.description
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailsViewController") as! CategoryDetailsViewController
        guard let name = categorieslist[indexPath.row]["cat_name"] as? String else {
            return
        }
        guard let id = categorieslist[indexPath.row]["cat_id"] as? String else {
            return
        }
        vc.categoryTitle = name
        vc.selectedcategory = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
