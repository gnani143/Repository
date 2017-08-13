//
//  ViewController.swift
//  DocumentRepository
//
//  Created by Gnani on 8/12/17.
//  Copyright © 2017 Gnani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionview: UICollectionView!
    
    var itemsList : [String] = ["REPOSITORY","LOREM IPSUM","LOREM IPSUM","LOREM IPSUM","LOREM IPSUM"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        collectionview.register(UINib(nibName: "RepositoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RepositoryCollectionViewCell")
        
        self.title = "Application Name"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(hex:"00c9d1")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "menu_ic")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState())
        button.tintColor = UIColor.white
        button.addTarget(self,  action: #selector(self.leftmenuAction), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
        
        let barButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.leftBarButtonItem = barButton
        
    }
    
    func leftmenuAction(){
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    func individualWidthGivenTotalItems(numberOfItems: CGFloat) -> CGFloat {
        
        if numberOfItems == 0 {
            return 0
        }
        let collectionViewWidth = collectionview.bounds.size.width
        let inset: CGFloat = 5.0
        let width: CGFloat = floor((collectionViewWidth - (numberOfItems - 1) * inset - 25 ) / numberOfItems)
        return width
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return itemsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell: RepositoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RepositoryCollectionViewCell", for: indexPath as IndexPath) as! RepositoryCollectionViewCell
            cell.titleLabel.text = itemsList[indexPath.row]
        
            if(indexPath.row != 0)
            {
                cell.backgroundImg.image = UIImage(named:("dummy_bg"+indexPath.row.description))
            }else
            {
                cell.backgroundImg.image = UIImage(named:"repository_bg")
            }
        
            return cell
            
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row == 0){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
                
                let width = individualWidthGivenTotalItems(numberOfItems: 2)
        
                return CGSize(width : width, height : width )
        

        }
}

