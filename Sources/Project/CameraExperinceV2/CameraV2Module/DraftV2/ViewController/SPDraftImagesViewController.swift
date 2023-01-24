//
//  SPDraftImagesViewController.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 22/12/22.
//

import UIKit

class SPDraftImagesViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var skuNameLabel: UILabel!
    @IBOutlet weak var totalImagesLabel: UILabel!
    @IBOutlet weak var resumeButton: UIButton!
    
    @IBOutlet weak var exteriorCollectionView: UICollectionView!
    
    //MARK:- Variable
    var draftProject: ProjectData?
    var skuList: ProjectSKU?
    var skuCount: Int?
    var subCatId: String? = ""
    var realmProjectObject = RealmProjectData()
    var realmEcomProjectObject = RealmProjectData()
    var vmSPOrderNow = SPOrderNowVM()
    var vmRealm = RealmViewModel()
    var hideResumeButton = false
    
    var arrExteriorCollectionImage = [ProcessedImageData]()
    var arrInteriorCollectionImage = [ProcessedImageData]()
    var arrMiscellaneousImage = [ProcessedImageData]()
    var arrImages = [ProcessedImageData]()
    var arrOverlayByIds = [OverlayByIdData]()
    
    var vmShoot = SPShootViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.skuNameLabel.text = "Project Name: " + SpyneSDK.shared.skuId
        self.totalImagesLabel.text = "Total Images: \(arrExteriorCollectionImage.count + arrInteriorCollectionImage.count + arrMiscellaneousImage.count)"
        headerView.roundCorners([.bottomLeft,.bottomRight], radius: 12.0)
        setUpCollectionViewDataSource()
        let layout = exteriorCollectionView.collectionViewLayout as? UICollectionViewFlowLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
    }
    
    func setUpCollectionViewDataSource() {
        let nib = UINib(nibName: "SPConfiguratorPageCollectionViewCell", bundle: Bundle.spyneSDK)
        exteriorCollectionView.register(nib, forCellWithReuseIdentifier: "SPConfiguratorPageCollectionViewCell")
        exteriorCollectionView.dataSource = self
        exteriorCollectionView.delegate = self
        exteriorCollectionView.reloadData()
    }
    
    func initialSetUp() {
        
    }
    
    func navigateToAutomobileShoot(){
        
        guard  let project = draftProject else{return}
        
        DraftStorage.isFromDraft = true
        
        var exteriorCount  = 0
        var interiorCount = 0
        var misCount = 0
        
        if let realmProjectData = vmRealm.getRealmData(projectId: project.projectId ?? ""){
            
            let realmSkuData = vmRealm.getRealmSkuData(skuId: skuList?.skuId ?? "")
            
            let getRealmImageData = vmRealm.getRealmImageData(status: 1, skuId: skuList?.skuId ?? "")
            
            let vmShoot = SPShootViewModel()
            
            vmShoot.cat_id = realmProjectData.prodCatId
            vmShoot.sub_cat_id = self.subCatId ?? ""
            vmShoot.projectId = realmProjectData.projectId
            vmShoot.selectedAngle  = realmSkuData?.completedAngles ?? 0
            vmShoot.projectName = realmProjectData.projectName
            vmShoot.skuId = realmSkuData?.skuId ?? ""
            vmShoot.skuName = realmSkuData?.skuName ?? ""
            vmShoot.noOfAngles = realmProjectData.noOfAngles
            Storage.shared.vmSPOrderNow = vmSPOrderNow
            Storage.shared.vmShoot = vmShoot
            DraftStorage.isFromDraft = true
            self.vmSPOrderNow.arrImages = self.arrExteriorCollectionImage
            self.vmSPOrderNow.arrInteriorCollectionImage = self.arrInteriorCollectionImage
            self.vmSPOrderNow.arrMiscellaneousImage = self.arrMiscellaneousImage
            
            Storage.shared.vmSPOrderNow = self.vmSPOrderNow
            
            let serverExteriorCount = vmSPOrderNow.arrImages.filter{$0.imageCategory == StringCons.exterior}.count
            let serverInteriorCount = vmSPOrderNow.arrImages.filter{$0.imageCategory == StringCons.interior}.count
            let serverMisCount = vmSPOrderNow.arrImages.filter{$0.imageCategory == StringCons.miscellaneous}.count
            
            let vmRealm = RealmViewModel.init()
            
            let arrLocalImages = vmRealm.getRealmAllImageData(skuId: skuList?.skuId ?? "")
            
            exteriorCount = arrLocalImages.filter{$0.imageCategory == StringCons.exterior}.count
            interiorCount = arrLocalImages.filter{$0.imageCategory == StringCons.interior}.count
            misCount = arrLocalImages.filter{$0.imageCategory == StringCons.miscellaneous}.count
            vmShoot.arrOverLays = LocalOverlays.ExteriorOverlayData!
            self.vmShoot = vmShoot
            if serverExteriorCount > exteriorCount{
                exteriorCount = serverExteriorCount
            }
            
            if serverInteriorCount > interiorCount{
                interiorCount = serverInteriorCount
            }
            
            if serverMisCount > misCount{
                misCount = serverMisCount
            }
            
            
            let totalWithInteriorCount = (realmProjectData.noOfAngles + realmProjectData.noOfInteriorAngles)
            
            let totalWithMisCount = (realmProjectData.noOfAngles + realmProjectData.noOfInteriorAngles + realmProjectData.noOfMisAngles)

            if exteriorCount < realmProjectData.noOfAngles{
                //Navigate To Exterior
                moveToShoot()
            }
            else if (exteriorCount + interiorCount) < totalWithInteriorCount{
                //Navigate To Interior
                moveToShoot()
            }
            else if (exteriorCount + interiorCount + misCount) < totalWithMisCount || realmProjectData.interiorSkiped{
                //Navigate To Focused shoot
//                if let vc = story.instantiateViewController(withIdentifier: "SPShootFocusImagesVC")as? SPShootFocusImagesVC{
//                    vc.vmShoot = vmShoot
//                    vc.vmOrderNow = self.vmSPOrderNow
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
            }else if (exteriorCount + interiorCount + misCount) >= totalWithMisCount || realmProjectData.misSkiped{
                Storage.shared.vmShoot = vmShoot
//                let story = UIStoryboard(name: "ImageProccesing", bundle:nil)
//                if let vc = story.instantiateViewController(withIdentifier: "SPImageProccesingVC")as? SPImageProccesingVC{
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
            }
        }else{
            self.getSkuDetails(skuId:skuList?.skuId ?? "")
        }
    }
    
    //MARK:-  Get  Automobiles / Footwear Draft Details
    func getSkuDetails(skuId:String){
        
        let vmShoot = SPShootViewModel()
        vmShoot.getProductSubCategories(prod_id: draftProject?.categoryId ?? "") {
            self.realmProjectObject = RealmProjectData(authKey: USER.authKey, prodCatId: self.draftProject?.categoryId ?? "", subCatId: self.draftProject?.subCategoryId ?? "", projectId: self.draftProject?.projectId ?? "", projectName: self.draftProject?.projectName ?? "", skuId: self.skuList?.skuId ?? "", imageCategory: self.draftProject?.category ?? "", completedAngles: self.skuList?.totalImagesCaptured ?? 0, noOfAngles: self.skuList?.exteriorClick ?? 0, noOfInteriorAngles: Storage.shared.arrInteriorPopup.count , noOfMisAngles: Storage.shared.arrFocusedPopup.count , interiorSkiped: false, misSkiped: false, is360IntSkiped: false)
            
            let realmSkuObject = RealmSkuData(projectId: self.draftProject?.projectId ?? "", skuId: self.skuList?.skuId ?? "", skuName: self.skuList?.skuName ?? "", completedAngles: self.skuList?.totalImagesCaptured ?? 0)
            
            try? RealmViewModel.main.realm.safeWrite {
                RealmViewModel.main.realm.add(self.realmProjectObject)
                RealmViewModel.main.realm.add(realmSkuObject)
                self.navigateToAutomobileShoot()
            }
            
        } onError: { (errMessage) in
            ShowAlert(message: errMessage, theme: .error)
        }
        
    }
    
    func moveToShoot() {
        let storyBoard = UIStoryboard(name: "CameraV2", bundle: Bundle.spyneSDK)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SPCameraScreenV2ViewController") as! SPCameraScreenV2ViewController
        vc.vmShoot = self.vmShoot
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func resumeShootButtonTapped(_ sender: Any) {
        
        guard  let project = draftProject else{return}
        
        if project.category?.lowercased() == "Automobiles".lowercased(){
            
            self.navigateToAutomobileShoot()
            
        }else if project.category?.lowercased() == "bikes".lowercased(){
            self.navigateToAutomobileShoot()
        } else if project.category?.lowercased() == "Footwear".lowercased(){
            //MARK:- Footwear Data Storage
            DraftStorage.draftProjectId = project.projectId ?? ""
            if vmRealm.getRealmData(projectId: project.projectId ?? "") != nil{
//                self.navigateToReshoot()
            }else{
                
                let skuElement = SkuElements(completedAngles: skuList?.totalImagesCaptured ?? 0, noOfAngles: skuList?.exteriorClick ?? 0, noOfInteriorAngles: 0, noOfMisAngles: 0, interiorSkiped: true, misSkiped: true, is360IntSkiped: true)
                
                self.vmRealm.storeProjectData(draftProject:  self.draftProject, projectSku: skuList!,elements: skuElement) {
                    self.vmRealm.storeSkuData(draftProject: self.draftProject, projectSku: self.skuList) {
//                        self.navigateToReshoot()
                    } onError: { error in
                        ShowAlert(message: Alert.insertProjectError, theme: .error)
                    }
                } onError: { error in
                    ShowAlert(message: Alert.insertSkuError, theme: .error)
                }
            }
            
        }else{
            //MARK:- Ecom and Grocery
            DraftStorage.draftProjectId = project.projectId ?? ""
            
            if vmRealm.getRealmData(projectId: project.projectId ?? "") != nil{
//                self.navigateToReshoot()
            }else{
                
                //Create SKU Element
                let skuElement = SkuElements(completedAngles: skuList?.totalImagesCaptured ?? 0, noOfAngles: skuList?.exteriorClick ?? 0, noOfInteriorAngles: 0, noOfMisAngles: 0, interiorSkiped: true, misSkiped: true, is360IntSkiped: true)
                
                //Store Data if not available in local storage
                self.vmRealm.storeProjectData(draftProject:  self.draftProject, projectSku: skuList!,elements: skuElement) {
                    self.vmRealm.storeSkuData(draftProject: self.draftProject, projectSku: self.skuList) {
//                        self.navigateToReshoot()
                    } onError: { error in
                        ShowAlert(message: Alert.insertProjectError, theme: .error)
                    }
                } onError: { error in
                    ShowAlert(message: Alert.insertSkuError, theme: .error)
                }
            }
        }
    }
}

extension SPDraftImagesViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 128)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.arrExteriorCollectionImage.count > 0 {
            if self.arrInteriorCollectionImage.count > 0 {
                if self.arrMiscellaneousImage.count > 0 {
                    return 3
                } else {
                    return 2
                }
            } else {
                return 1
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0: return self.arrExteriorCollectionImage.count
            case 1: return self.arrInteriorCollectionImage.count
            case 2: return self.arrMiscellaneousImage.count
            default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPConfiguratorPageCollectionViewCell", for: indexPath) as! SPConfiguratorPageCollectionViewCell
        switch indexPath.section {
            case 0:
            cell.setDraftValues(imageUrl: self.arrExteriorCollectionImage[indexPath.row].inputImageLresURL ?? "", subCatNameString: "")
            case 1: cell.setDraftValues(imageUrl: self.arrInteriorCollectionImage[indexPath.row].inputImageLresURL ?? "", subCatNameString: "")
            case 2: cell.setDraftValues(imageUrl: self.arrMiscellaneousImage[indexPath.row].inputImageLresURL ?? "", subCatNameString: "")
            default: print("Undefined case needed to be handled")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SPDraftHeaderCollectionReusableView", for: indexPath) as? SPDraftHeaderCollectionReusableView {
            sectionHeader.myLabel.textColor = .blue
            switch indexPath.section {
                case 0: sectionHeader.myLabel.text = "Exterior"
                case 1: sectionHeader.myLabel.text = "Interior"
                case 2: sectionHeader.myLabel.text = "miscellaneous"
                default: print("Undefined case needed to be handled")
            }
           return sectionHeader
          }
          return UICollectionReusableView()
      }
}
