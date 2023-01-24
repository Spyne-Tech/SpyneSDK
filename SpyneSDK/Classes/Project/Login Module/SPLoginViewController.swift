//
//  SPLoginViewController.swift
//  Spyne SDK
//
//  Created by Akash Verma on 03/08/22.
//

import UIKit
import Toast_Swift

class SPLoginViewController: UIViewController {
    
    var viewModel : SPLoginViewModel?
    var presentingByViewController: UIViewController?
    var categoryID = ""
    var emailID = ""
    var userId = ""
    var categoryAgnosticModel: CategoryMasterRoot?
    var skuName = ""
    var vmShoot = SPShootViewModel()
    let configurator = Configurator()
    
    var arrExteriorCollectionImage = [ProcessedImageData]()
    var arrInteriorCollectionImage = [ProcessedImageData]()
    var arrMiscellaneousImage = [ProcessedImageData]()
    var arrImages = [ProcessedImageData]()
    var arrOverlayByIds = [OverlayByIdData]()
    var draftProject: CheckForDraft?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        viewModel = SPLoginViewModel()
        viewModel?.userLogin(email: emailID, externalId: emailID, contactNo: "9999598474", userName: "AkashVerma", onSuccess: {model in
            CLIENT.shared.setSecretKeyAuthKey(authKey: model.data?.secretKey ?? "")
            self.getCategoryAgnostic(categoryID: self.categoryID)
        }, onError: { error in
            print(error)
        })
    }
    
    func getCategoryAgnostic(categoryID: String) {
        viewModel?.getCategoryAgnostic(categoryId: categoryID, onSuccess: { model in
            self.categoryAgnosticModel = model
            Storage.shared.setCatagoryMasterData(categoryMasterData: model)
            Storage.shared.arrInteriorPopup = model.data.first?.sdkInterior ?? []
            Storage.shared.arrFocusedPopup = model.data.first?.sdkMisc ?? []
            LocalOverlays.InteriorOverlaysData = model.data.first?.interior
            LocalOverlays.MiscelenousOverlayData = model.data.first?.miscellaneous
            self.viewModel?.getDraftInProjectForSku(projectName: SpyneSDK.shared.skuId, onsuccess: { model in
                self.draftProject = model
                SPStudioSetupModel.categoryId = self.draftProject?.data.skuData.categoryId ?? ""
                SPStudioSetupModel.subCategoryID = self.draftProject?.data.skuData.subCategoryId ?? ""
                self.viewModel?.getCompletedImagesBySkuID(skuName: model.data.skuData.skuId ?? "", onSuccess: { model in
                    print(model)
                    self.arrImages = model.data ?? []
                    for image in self.arrImages{
                        if image.imageCategory == "Exterior"{
                            self.arrExteriorCollectionImage.append(image)
                        }else if image.imageCategory == "Interior"{
                            self.arrInteriorCollectionImage.append(image)
                        }else {
                            self.arrMiscellaneousImage.append(image)
                        }
                    }
                    self.configurator.getOverlays(prod_id: SPStudioSetupModel.categoryId ?? "", prod_sub_cat_id: SPStudioSetupModel.subCategoryID ?? "", no_of_frames: "\(self.configurator.getFrames())") {
                        self.startDraftFlow()
                    } onError: { (error) in
                        self.openConfigurationPage()
                    }
                    //Start Draft flow
                }, onError: {_ in
                    print("error")
                    self.openConfigurationPage()
                })
            }, onError: {
                self.openConfigurationPage()
            })
        }, onError: { _ in
            print("Error")
        })
    }
    
    func openConfigurationPage() {
        let story = UIStoryboard(name: "Configuration", bundle: Bundle.spyneSDK)
        if let vc = story.instantiateViewController(withIdentifier: "SPSubcategorySelectionViewController")as? SPSubcategorySelectionViewController{
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func startDraftFlow() {
        DraftStorage.draftProjectId = self.draftProject?.data.projectData.projectId ?? ""
        let storyBoard = UIStoryboard(name: "Configuration", bundle: Bundle.spyneSDK)
        let buttonHidden = self.draftProject?.data.projectData.status != "Draft" ? true : false
        let draftViewController = storyBoard.instantiateViewController(withIdentifier: "SPDraftImagesViewController") as! SPDraftImagesViewController
        draftViewController.arrExteriorCollectionImage = self.arrExteriorCollectionImage
        draftViewController.arrInteriorCollectionImage = self.arrInteriorCollectionImage
        draftViewController.arrMiscellaneousImage = self.arrMiscellaneousImage
        draftViewController.skuList = self.draftProject?.data.skuData
        draftViewController.draftProject = self.draftProject?.data.projectData
        draftViewController.skuCount = 1
        draftViewController.subCatId = self.draftProject?.data.skuData.subCategoryId
        draftViewController.hideResumeButton = buttonHidden
        self.navigationController?.pushViewController(draftViewController, animated: true)
    }
    
    @IBAction func openCamera(_ sender: Any) {
        self.openConfigurationPage()
    }
    
}

extension SPLoginViewController : SP360OrderSummaryVCDelegate{
    func showAlertDataRequest(skuId: String, isShoot: Bool) {
        ShowAlert(message: "Shoot Completed. Sku Id: \(skuId) ", theme: .warning)

    }
}
