//
//  AddCreditViewModel.swift
//  Spyne
//
//  Created by Vijay Parmar on 07/07/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
import KRProgressHUD

class AddCreditViewModel{
    
    var arrProducts = [GetCreditListData]()
    
    //MARK:- Get Credit
    func getCreditList(onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        KRProgressHUD.show()
        Network.request(.getCreditList, decodeType: GetCreditListRootClass.self, errorDecodeType: GetCreditListRootClass.self, decoder: JSONDecoder(), success: { result in
            
            KRProgressHUD.dismiss()
            if result.status == 200{
                self.arrProducts = result.data ?? []
                onSuccess()
            } else {
                onError(result.message ?? Alert.SomethingWrong)
            }
        }, error: { (_, errorResult,_ ) in
            print(errorResult?.message as Any)
            KRProgressHUD.dismiss()
            onError(errorResult?.message  ??  Alert.SomethingWrong)
        }, failure: { error in
            KRProgressHUD.dismiss()
            onError(error.localizedDescription)
        }, completion: {
        })
    }
    
    
    
    //MARK:- Create Order
    func createOrder(orderId: String, planDiscount: Float, planFinalCost: Float, planId: String, planOrigCost: Float, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        KRProgressHUD.show()
        Network.request(.createOrder(orderId: orderId, planDiscount: planDiscount, planFinalCost: planFinalCost, planId: planId, planOrigCost: planOrigCost), decodeType: CreateOrderRootClass.self, errorDecodeType: CreateOrderRootClass.self, decoder: JSONDecoder(), success: { result in
            print(result)
            KRProgressHUD.dismiss()
            if result.status == "CREATED"{
                onSuccess()
            } else {
                onError(result.status ?? Alert.SomethingWrong)
            }
        }, error: { (_, errorResult,_ ) in
            print(errorResult?.status as Any)
            KRProgressHUD.dismiss()
            onError(errorResult?.status  ??  Alert.SomethingWrong)
        }, failure: { error in
            KRProgressHUD.dismiss()
            onError(error.localizedDescription)
        }, completion: {
        })
    }
    
    //MARK:- Create Purchase Log
    func updateCredit(credit_id:String,credit_alotted:String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        KRProgressHUD.show()
        Network.request(.updateUserCredit(credit_id:credit_id,credit_alotted:credit_alotted), decodeType: UserCreditRootClass.self, errorDecodeType: UserCreditRootClass.self, decoder: JSONDecoder(), success: { result in
            print(result)
            KRProgressHUD.dismiss()
            if result.status == 200{
                onSuccess()
            } else {
                onError(result.message ?? Alert.SomethingWrong)
            }
        }, error: { (_, errorResult,_ ) in
            print(errorResult?.status as Any)
            KRProgressHUD.dismiss()
            onError(errorResult?.message  ??  Alert.SomethingWrong)
        }, failure: { error in
            KRProgressHUD.dismiss()
            onError(error.localizedDescription)
        }, completion: {
        })
    }
    
    
}
