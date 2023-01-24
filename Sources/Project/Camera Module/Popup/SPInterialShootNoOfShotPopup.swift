//
//  SPInterialShootNoOfShotPopup.swift
//  Spyne
//
//  Created by Vijay on 24/04/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import UIKit

protocol AngleSelectionDelegate {
    func didSelectAngle(noOfAngeles:Int,selectedRow:Int)
}


class SPInterialShootNoOfShotPopup: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Outlet
    @IBOutlet weak var pickerNoOfShots: UIPickerView!
    
    // Variable
    var arrNoOfShots = [4,8,12,24,36]
    var delegate:AngleSelectionDelegate?
    var noOfAngeles = 4
    var selectedRow:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerNoOfShots.delegate = self
        pickerNoOfShots.dataSource = self
        pickerNoOfShots.selectRow(selectedRow!, inComponent: 0, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
    }
    
    //MARK:- Button Action
    @IBAction func Proceed(_ sender: UIButton) {
        delegate?.didSelectAngle(noOfAngeles: noOfAngeles,selectedRow: pickerNoOfShots.selectedRow(inComponent: 0))
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SPInterialShootNoOfShotPopup{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrNoOfShots.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return "\(arrNoOfShots[row]) ANGLES"
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(35)
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var color: UIColor
        var font: UIFont
        if row == pickerView.selectedRow(inComponent: component){
            color = UIColor.appColor!
        }
        else
        {
            color = UIColor.pickerLableColor!
        }
        return NSAttributedString(string: "\(arrNoOfShots[row]) ANGLES", attributes: [NSAttributedString.Key.foregroundColor: color])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        noOfAngeles = arrNoOfShots[row]
        pickerView.reloadAllComponents()
        
    }
}
