//
//  SPOverlaysDrawer.swift
//  SpyneFrameworkDebug
//
//  Created by Akash Verma on 28/11/22.
//

import UIKit

protocol SPOverlayDrawerContentUpdateDelegate {
    func updateDrawerOverlayCells(shootType: ShootType)
}

protocol SPSelectedCellDelegate {
    func updateSelectedCell(index:Int,shootType:ShootType)
}

protocol SPDrawerDismissDelegate {
    func dismissDrawer()
}

class SPOverlaysDrawer: UIView,UIGestureRecognizerDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    
    var shootType = ShootType.Exterior
    var exteriorOverlays = getExteriorOverlayData()
    var interiorOverlays: [SubCategoryInterior] = []
    var miscOverlays : [SubCategoryInterior] = []
    var vmShoot: SPShootViewModel?
    var selectedCellDelegate: SPSelectedCellDelegate?
    var dismissDrawerDelegate: SPDrawerDismissDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.spyneSDK.loadNibNamed("SPOverlaysDrawer", owner: self, options: nil)
        addSubview(contentView)
        contentView.alpha = 0.0
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let nib = UINib(nibName: "SPOverLaysCollectionViewCell", bundle: Bundle.spyneSDK)
        collectionView.register(nib, forCellWithReuseIdentifier: "SPOverLaysCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        guard let vmShoot else { return }
        exteriorOverlays = vmShoot.arrOverLays
        interiorOverlays =  Storage.shared.arrInteriorPopup
        miscOverlays = Storage.shared.arrFocusedPopup
        collectionView.reloadData()
    }

    @IBAction func dismissButtonTouchUpInside(_ sender: Any) {
        dismissDrawerDelegate?.dismissDrawer()
    }
}

extension SPOverlaysDrawer: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch shootType {
        case .Exterior: return exteriorOverlays.count
        case .Interior: return interiorOverlays.count
        case .Misc: return miscOverlays.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110.0, height: 102.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPOverLaysCollectionViewCell", for: indexPath) as! SPOverLaysCollectionViewCell
        switch shootType {
        case .Exterior:
            if vmShoot?.selectedAngle == indexPath.row {
                cell.borderView.borderColor = .green
            } else {
                cell.borderView.borderColor = .red
            }
            if let clickedImage = exteriorOverlays[indexPath.row].clickedImage {
                cell.borderView.borderColor = .green
                cell.setValues(imageViewurl: "", overlayName: exteriorOverlays[indexPath.row].displayName ?? "",clickedImage: clickedImage)
            } else if let clickedImageURL = exteriorOverlays[indexPath.row].imageUrl {
                cell.borderView.borderColor = .green
                cell.setValues(imageViewurl: "", overlayName: exteriorOverlays[indexPath.row].displayName ?? "",clickedImageUrl: clickedImageURL)
            } else {
                cell.setValues(imageViewurl: exteriorOverlays[indexPath.row].displayThumbnail ?? "", overlayName: exteriorOverlays[indexPath.row].displayName ?? "")
            }
        case .Interior:
            if let clickedImage = interiorOverlays[indexPath.row].clickedImage {
                cell.borderView.borderColor = .green
                cell.setValues(imageViewurl: "", overlayName: interiorOverlays[indexPath.row].displayName ?? "" ,clickedImage: clickedImage)
            }else if let clickedImageURL = interiorOverlays[indexPath.row].imageUrl {
                cell.borderView.borderColor = .green
                cell.setValues(imageViewurl: "", overlayName: interiorOverlays[indexPath.row].displayName ?? "",clickedImageUrl: clickedImageURL)
            } else {
                cell.setValues(imageViewurl: interiorOverlays[indexPath.row].displayThumbnail ?? "" , overlayName: interiorOverlays[indexPath.row].displayName ?? "" ,mendatory: interiorOverlays[indexPath.row].mendatoy ?? false,exterior: false)
            }
            if vmShoot?.selectedInteriorAngles == indexPath.row {
                cell.borderView.borderColor = .green
            }
        case .Misc:
            if let clickedImage = miscOverlays[indexPath.row].clickedImage {
                cell.borderView.borderColor = .green
                cell.setValues(imageViewurl: "" , overlayName: miscOverlays[indexPath.row].displayName ?? "" ,clickedImage: clickedImage)
            } else if let clickedImageURL = miscOverlays[indexPath.row].imageUrl {
                cell.borderView.borderColor = .green
                cell.setValues(imageViewurl: "", overlayName: miscOverlays[indexPath.row].displayName ?? "",clickedImageUrl: clickedImageURL)
            } else {
                cell.setValues(imageViewurl: miscOverlays[indexPath.row].displayThumbnail ?? "", overlayName:  miscOverlays[indexPath.row].displayName ?? "",mendatory: miscOverlays[indexPath.row].mendatoy ?? false, exterior: false)
            }
            if vmShoot?.selectedFocusAngles == indexPath.row {
                cell.borderView.borderColor = .green
            }
        }
        cell.alpha = 0
        cell.index = indexPath.row
        cell.delegate = self
        cell.fadeIn()
        return cell
    }
}

extension SPOverlaysDrawer: SPOverlayDrawerContentUpdateDelegate {
    func updateDrawerOverlayCells(shootType: ShootType) {
        self.shootType = shootType
        self.collectionView.reloadData()
    }
}

extension SPOverlaysDrawer: CellIndexDelegate {
    func sendIndex(index: Int) {
        selectedCellDelegate?.updateSelectedCell(index: index, shootType: self.shootType)
    }
}
