//
//  SPBackgroundSelectionViewController.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 01/12/22.
//

import UIKit
import KRProgressHUD

//MARK: SPBackgroundSelectionViewController
class SPBackgroundSelectionViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    
    //MARK: Local variables
    let configurator = Configurator()
    var currentSelectedIndex: IndexPath?

    //MARK: Viewcontroller Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SPConfiguratorPageCollectionViewCell", bundle: Bundle.spyneSDK)
        collectionView.register(nib, forCellWithReuseIdentifier: "SPConfiguratorPageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        headerView.roundCorners([.bottomLeft,.bottomRight], radius: 12.0)
    }
    
    //MARK: Class methods
    func getOverlays(frames:Int){
        configurator.getOverlays(prod_id: SPStudioSetupModel.categoryId ?? "", prod_sub_cat_id: SPStudioSetupModel.subCategoryID ?? "", no_of_frames: "\(frames)") {
            KRProgressHUD.dismiss()
            let storyBoard = UIStoryboard(name: "Configuration", bundle: Bundle.spyneSDK)
            let vc = storyBoard.instantiateViewController(withIdentifier: "SPNumberPlateSelectionViewController") as! SPNumberPlateSelectionViewController
            self.navigationController?.pushViewController(vc, animated: false)
        } onError: { (error) in
            KRProgressHUD.dismiss()
        }
    }
    
    //MARK: IBActions
    @IBAction func continueButtonTouchUpInside(_ sender: Any) {
        getOverlays(frames:configurator.getFrames())
        KRProgressHUD.show()
    }
}

//MARK: extensions SPBackgroundSelectionViewController
/// Confirming all the Collectionview data source and delegates
extension SPBackgroundSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return configurator.getBackgrounds().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPConfiguratorPageCollectionViewCell", for: indexPath) as! SPConfiguratorPageCollectionViewCell
        let subCatArray = configurator.getBackgrounds()
        cell.setValues(imageUrl: subCatArray[indexPath.row].backgroundImageUrl, subCatNameString: subCatArray[indexPath.row].backgroundName)
        if indexPath.row == 0 {
            self.currentSelectedIndex = indexPath
            cell.borderView.borderColor = .appColor
            SPStudioSetupModel.backgroundId = configurator.getBackgrounds()[indexPath.row].backgroundId
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
        SPStudioSetupModel.backgroundId = configurator.getBackgrounds()[indexPath.row].backgroundId
    }
}
