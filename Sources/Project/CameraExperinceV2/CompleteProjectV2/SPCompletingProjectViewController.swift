//
//  SPCompletingProjectViewController.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 12/12/22.
//

import UIKit

class SPCompletingProjectViewController: UIViewController {
    
    var completeProjectViewModel: CompleteProjectViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shootData = Storage.shared.vmShoot
        completeProjectViewModel = CompleteProjectViewModel()
        completeProjectViewModel?.processImage(skuId: shootData.skuId, background_id: SPStudioSetupModel.backgroundId ?? "" , is360: "false", isBlurNumPlate: "false", isTintWindow: "false", windowCorrection: "false", shootEnv: 0, numberplateID: "", isShadow: true, onSuccess: {
            self.markDone()
        }, onError: { message in
            print(message)
            
        })
    }
    
    func markDone() {
        let shootData = Storage.shared.vmShoot
        completeProjectViewModel?.updateProjectIds(projectIds: [shootData.projectId], onSuccess: {
                SpyneSDK.shared.orientationLock = .portrait
                self.navigationController?.popTo(controllerToPop: SpyneSDK.referenceVC!)
        }, onError: {
            error in
            print(error)
        })
    }
}
