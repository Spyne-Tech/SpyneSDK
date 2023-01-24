//
//  SPSubcategorySelectionViewController.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 29/11/22.
//

import UIKit

//MARK: - SPSubcategorySelectionViewController
class SPSubcategorySelectionViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    
    //MARK: Local variables
    let configurator = Configurator()
    var currentSelectedIndex: IndexPath?

    //MARK: ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let nib = UINib(nibName: "SPConfiguratorPageCollectionViewCell", bundle: Bundle.spyneSDK)
        collectionView.register(nib, forCellWithReuseIdentifier: "SPConfiguratorPageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        headerView.roundCorners([.bottomLeft,.bottomRight], radius: 12.0)
    }
    
    //MARK: IBActions
    @IBAction func continueButtonTouchUpInside(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Configuration", bundle: Bundle.spyneSDK)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SPBackgroundSelectionViewController") as! SPBackgroundSelectionViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: extension SPSubcategorySelectionViewController
/// Confirming all the Collectionview data source and delegates
extension SPSubcategorySelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return configurator.getSubcategories().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPConfiguratorPageCollectionViewCell", for: indexPath) as! SPConfiguratorPageCollectionViewCell
        let subCatArray = configurator.getSubcategories()
        cell.setValues(imageUrl: subCatArray[indexPath.row].displayThumbnail, subCatNameString: subCatArray[indexPath.row].subCatName)
        if indexPath.row == 0 {
            self.currentSelectedIndex = indexPath
            cell.borderView.borderColor = .appColor
            SPStudioSetupModel.categoryId = configurator.getSubcategories()[indexPath.row].prodCatId
            SPStudioSetupModel.subCategoryID = configurator.getSubcategories()[indexPath.row].prodSubCatId
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90.0, height: 110.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let currentSelectedIndex {
            let cellToDeSelect = collectionView.cellForItem(at: currentSelectedIndex) as! SPConfiguratorPageCollectionViewCell
            cellToDeSelect.borderView.borderColor = UIColor(r: 0.0, g: 0.0, b: 0.0,a: 0.1)
        }
        self.currentSelectedIndex = indexPath
        let cell = collectionView.cellForItem(at: indexPath) as! SPConfiguratorPageCollectionViewCell
        cell.borderView.borderColor = .appColor
        SPStudioSetupModel.categoryId = configurator.getSubcategories()[indexPath.row].prodCatId
        SPStudioSetupModel.subCategoryID = configurator.getSubcategories()[indexPath.row].prodSubCatId
    }
}
