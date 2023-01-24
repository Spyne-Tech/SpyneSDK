//
//  SPNumberPlateSelectionViewController.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 01/12/22.
//

import UIKit

//MARK: SPNumberPlateSelectionViewController
class SPNumberPlateSelectionViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    
    //MARK: Class variables
    let configurator = Configurator()
    var currentSelectedIndex: IndexPath?
    
    //MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SPConfiguratorPageCollectionViewCell", bundle: Bundle.spyneSDK)
        collectionView.register(nib, forCellWithReuseIdentifier: "SPConfiguratorPageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        headerView.roundCorners([.bottomLeft,.bottomRight], radius: 12.0)
    }

    //MARK: IBActions
    @IBAction func continueButtonTouchUpInside(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "CameraV2", bundle: Bundle.spyneSDK)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SPCameraScreenV2ViewController") as! SPCameraScreenV2ViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: extension SPNumberPlateSelectionViewController
/// Confirming all the Collectionview data source and delegates
extension SPNumberPlateSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return configurator.getNumberPlates().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPConfiguratorPageCollectionViewCell", for: indexPath) as! SPConfiguratorPageCollectionViewCell
        let subCatArray = configurator.getNumberPlates()
        cell.setValues(imageUrl: subCatArray[indexPath.row].numberPlateLogoURL ?? "", subCatNameString: subCatArray[indexPath.row].numberPlateLogoName ?? "")
        if indexPath.row == 0 {
            self.currentSelectedIndex = indexPath
            cell.borderView.borderColor = .appColor
            SPStudioSetupModel.numberPlateId = String(configurator.getNumberPlates()[indexPath.row].id ?? 0)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90.0, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let currentSelectedIndex {
            let cellToDeSelect = collectionView.cellForItem(at: currentSelectedIndex) as! SPConfiguratorPageCollectionViewCell
            cellToDeSelect.borderView.borderColor = UIColor(r: 0.0, g: 0.0, b: 0.0,a: 0.1)
        }
        self.currentSelectedIndex = indexPath
        let cell = collectionView.cellForItem(at: indexPath) as! SPConfiguratorPageCollectionViewCell
        cell.borderView.borderColor = .appColor
        SPStudioSetupModel.numberPlateId = String(configurator.getNumberPlates()[indexPath.row].id ?? 0)
    }
}
