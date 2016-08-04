//
//  ViewController.swift
//  pocket_style_table
//
//  Created by saldin on 04/08/16.
//  Copyright © 2016 saldin. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController
{
    @IBOutlet weak var collectionView: UICollectionView!

    internal let cellID: String = "CellReuseID"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.setCollectionViewLayout(PocketLayout(), animated: true)
        self.collectionView.backgroundColor = .whiteColor()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 7
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! DocumentItemCell
        cell.imgView.image = UIImage(named: "0\(indexPath.row+1)")
        
        return cell
    }
}

class DocumentItemCell: UICollectionViewCell
{
    @IBOutlet weak var imgView: UIImageView!

    private var blurView: UIVisualEffectView!

    override func awakeFromNib()
    {
        super.awakeFromNib()

        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
        blurView.frame = self.contentView.bounds
        self.contentView.addSubview(blurView)
        self.contentView.sendSubviewToBack(blurView)

        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSizeMake(0, 1)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5

        self.clipsToBounds = false
    }
}

class PocketLayout: UICollectionViewFlowLayout
{
    private let cellVisibleHeight: CGFloat = 150
    private let cellFullHeight: CGFloat = 300

    override func prepareLayout()
    {
        self.itemSize = CGSizeMake(self.collectionView!.bounds.width, cellVisibleHeight)
        self.sectionInset = UIEdgeInsetsZero
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        var attrs: [UICollectionViewLayoutAttributes] = []
        for attr in super.layoutAttributesForElementsInRect(rect)! {
            let newAttribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: attr.indexPath)
            newAttribute.frame = CGRectMake(0, CGFloat(attr.indexPath.row*150), attr.size.width, cellFullHeight)
            newAttribute.size = CGSizeMake(attr.size.width, cellFullHeight)
            newAttribute.zIndex = newAttribute.indexPath.row
            attrs.append(newAttribute)
        }

        return attrs
    }

    override func collectionViewContentSize() -> CGSize
    {
        let height = CGFloat(self.collectionView!.numberOfItemsInSection(0)) * cellVisibleHeight + cellVisibleHeight/2

        return CGSizeMake(self.collectionView!.frame.width, height)
    }
}