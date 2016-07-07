//
//  MYPhotoSelectorViewController.swift
//  图片选择器
//
//  Created by Melody Chan on 16/6/29.
//  Copyright © 2016年 canlife. All rights reserved.
//

import UIKit
private let PhotoCollectionCellReuseIdentifier = "PhotoCollectionCellReuseIdentifier"
class MYPhotoSelectorViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    private func setUpUI(){        //添加

        view.addSubview(collectionView)
        //布局
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["collectionView":collectionView])
         cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["collectionView":collectionView])
        view.addConstraints(cons)
        
    }
    //MARK: 懒加载
    private lazy var collectionView:UICollectionView = {
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: MYPhotoSelectorViewLayout())
        cv.backgroundColor = UIColor.darkGrayColor()
        cv.registerClass(MYPhotoSelectorCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionCellReuseIdentifier)
        cv.dataSource = self
        return cv
    }()
    
    private lazy var pictureImages = [UIImage]()
}

extension MYPhotoSelectorViewController: UICollectionViewDataSource,PhotoSelectorCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureImages.count+1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCollectionCellReuseIdentifier, forIndexPath: indexPath) as! MYPhotoSelectorCollectionViewCell
        cell.image = (pictureImages.count == indexPath.item) ? nil : pictureImages[indexPath.item]
        cell.photoSelectorCellDelegate = self
        return cell
    }
    //MARK: - PhotoSelectorCellDelegate
    func photoDidAddSelect(cell:MYPhotoSelectorCollectionViewCell){
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            return
        }
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true //允许编辑
        presentViewController(vc, animated: true, completion: nil)
        
    }
    func photoDidDeleteSelect(cell:MYPhotoSelectorCollectionViewCell){
        if pictureImages.count > 0 {
            let indexPath = collectionView.indexPathForCell(cell)!
            pictureImages.removeAtIndex(indexPath.item)
            collectionView.reloadData()
        }
    }

    //MARK: - UIImagePickerControllerDelegate
    /**
     <#Description#>
     
     - parameter picker:      照片控制器
     - parameter image:       当前选中的照片
     - parameter editingInfo: 编辑之后的图片
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print(info)
        picker.dismissViewControllerAnimated(true, completion: nil)
        //一般情况从相册获取图片都要处理内存
        //编辑后的图片
        if info["UIImagePickerControllerEditedImage"] != nil  {
            let selectImage = info["UIImagePickerControllerEditedImage"] as! UIImage
            
            let currentImage = selectImage.imageWithScale(300)
            pictureImages.append(currentImage)
            
            collectionView.reloadData()
        }
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
    }
}
@objc
protocol PhotoSelectorCellDelegate:NSObjectProtocol {
    optional func photoDidAddSelect(cell:MYPhotoSelectorCollectionViewCell)
    optional func photoDidDeleteSelect(cell:MYPhotoSelectorCollectionViewCell)
}

class MYPhotoSelectorCollectionViewCell: UICollectionViewCell {
    
    weak var photoSelectorCellDelegate:PhotoSelectorCellDelegate?
    
    var image:UIImage?{
        didSet{
            if image != nil {
                deleteButton.hidden = false
                addButton.userInteractionEnabled = false
                addButton.setBackgroundImage(image, forState: UIControlState.Normal)
            }else{
                addButton.userInteractionEnabled = true
                deleteButton.hidden = true
                addButton.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    private func setUpUI(){
        //添加子控件
        contentView.addSubview(addButton)
        contentView.addSubview(deleteButton)
        
        //布局子控件
        addButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        

        var cons = [NSLayoutConstraint]()
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[addButton]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["addButton":addButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[addButton]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["addButton":addButton])
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:[deleteButton]-2-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["deleteButton":deleteButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-2-[deleteButton]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["deleteButton":deleteButton])
        
        contentView.addConstraints(cons)
    }
    
    //MARK: -懒加载
    private lazy var addButton:UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "compose_pic_add_highlighted"), forState: UIControlState.Highlighted)
        button.contentMode = UIViewContentMode.ScaleAspectFill
        button.addTarget(self, action: #selector(MYPhotoSelectorCollectionViewCell.addButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    private lazy var deleteButton:UIButton = {
        let button = UIButton()
        button.hidden = true
        button.setBackgroundImage(UIImage(named: "compose_photo_close"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(MYPhotoSelectorCollectionViewCell.deleteButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()

    func addButtonClick(sender:UIButton){
        photoSelectorCellDelegate?.photoDidAddSelect!(self)
    }
    func deleteButtonClick(sender:UIButton){
        photoSelectorCellDelegate?.photoDidDeleteSelect!(self)
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//自定义布局
class MYPhotoSelectorViewLayout:UICollectionViewFlowLayout{
    override func prepareLayout() {
        super.prepareLayout()
        itemSize = CGSize(width: 80, height: 80)
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
        sectionInset = UIEdgeInsetsMake(20, 10, 10, 10)
    }
}

