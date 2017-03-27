//
//  NewPinTypeSelectionView.swift
//  huddle
//
//  Created by Mateo Garcia on 3/26/17.
//  Copyright © 2017 Mateo Garcia. All rights reserved.
//

import UIKit

protocol NewPinTypeSelectionViewDelegate {
    func newPinTypeSelectionViewCloseButtonTapped()
}

class NewPinTypeSelectionView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    fileprivate let kItemsPerRow: Int = 3
    
    var delegate: NewPinTypeSelectionViewDelegate?

    init(frame: CGRect, exemptFrames: CGRect...) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        //
    }
    
    override func awakeFromNib() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "NewPinTypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewPinTypeCell")
    }
}


// MARK: - Collection View Delegate

extension NewPinTypeSelectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numRows = PinType.kNumPinTypes / self.kItemsPerRow
        if PinType.kNumPinTypes % self.kItemsPerRow > 0 {
            numRows += 1
        }
        return numRows
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.kItemsPerRow
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "NewPinTypeCell", for: indexPath) as! NewPinTypeCollectionViewCell
        cell.pinType = Array(PinType.pinTypeImage.keys)[indexPath.row]
        cell.delegate = self
        return cell
    }
}


// MARK: - Collection View Flow Layout

extension NewPinTypeSelectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = self.sectionInsets.left * (CGFloat(self.kItemsPerRow) + 1)
        let availableWidth = self.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(self.kItemsPerRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.sectionInsets.left
    }
}


// MARK: - Collection View Cell Delegate

extension NewPinTypeSelectionView: NewPinTypeCollectionViewCellDelegate {
    func newPinTypeCollectionViewCell(tappedWithPinType pinType: PinType.PinType) {
        // present detail view.
    }
}


// MARK: - Actions

extension NewPinTypeSelectionView {
    @IBAction func onCloseButtonTapped(_ sender: Any) {
        self.delegate?.newPinTypeSelectionViewCloseButtonTapped()
    }
}
