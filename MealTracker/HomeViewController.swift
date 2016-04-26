//
//  HomeViewController.swift
//  MealTracker
//
//  Created by Valti Skobo on 01/04/16.
//  Copyright © 2016 Valti Skobo. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices
import Foundation
import AVFoundation

import GPUImage
import OAuthSwift
import CoreData

import AFNetworking

class HomeViewController: UIViewController{
    @IBOutlet weak var mTouchBtn: UIButton!
    @IBOutlet weak var mGalleryBtn: UIButton!
    @IBOutlet weak var mNutritionBtn: UIButton!
    @IBOutlet weak var mFlashOnOffBtn: UIButton!
    @IBOutlet weak var mRotateCameraBtn: UIButton!
    @IBOutlet weak var mHistoryBtn: UIButton!
    
    @IBOutlet weak var mCameraView : UIView!
    
    var mFlashStatus : Bool = false
    
    var mPhotoCamera : GPUImageStillCamera!
    var mCropFilter : GPUImageFilter!
    var mFilterView : GPUImageView!
    
    var mTorchModePhoto : AVCaptureTorchMode!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTorchModePhoto = AVCaptureTorchMode.Off
        
        if UIScreen.mainScreen().bounds.size.height > 730{
            iOS_String = "iPhone6Plus"
        }
        else if UIScreen.mainScreen().bounds.size.height > 568{
            iOS_String = "iPhone6"
        }
        else if UIScreen.mainScreen().bounds.size.height == 568{
            iOS_String = "iPhone5"
        }
        else{
            iOS_String = "iPhone4"
        }
        
        print(mCameraView.frame.origin.x)
        print(mCameraView.frame.origin.y)
        print(iOS_String)
        
        if iOS_String.compare("iPhone6Plus") == NSComparisonResult.OrderedSame{
            mCameraView.frame = CGRectMake(0, 0, 414.0, 606.0)
        }
        else if iOS_String.compare("iPhone6") == NSComparisonResult.OrderedSame{
            mCameraView.frame = CGRectMake(0, 0, 375.0, 537.0)
        }else if iOS_String.compare("iPhone5") == NSComparisonResult.OrderedSame{
            mCameraView.frame = CGRectMake(0, 0, 320.0, 438.0)
        }else{
            mCameraView.frame = CGRectMake(0, 0, 320.0, 350.0)
        }
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.setupCameraForPhoto()
        
        self.sendToService()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func onTouchFlashButton(){
        var imageFlash: UIImage!
        
        if mFlashStatus == true{
            mFlashStatus = false
            imageFlash = UIImage.init(named: "flashoff")
            
            mTorchModePhoto = AVCaptureTorchMode.Off
            
            print("Touched Flash Off Button")
        }else if mFlashStatus == false{
            mFlashStatus = true
            imageFlash = UIImage.init(named: "flashon")
            
            mTorchModePhoto = AVCaptureTorchMode.On
            
            print("Touched Flash On Button")
        }
        
        self.torchOnOff()
        mFlashOnOffBtn.setImage(imageFlash, forState: UIControlState.Normal)
    }
    
    @IBAction func onTouchPhotoGalleryButton(){
        self.photofromLibrary()
    }
    
    @IBAction func onTouchRotateCameraButton(){
        
        if self.mPhotoCamera == nil{
            return
            
        }
        self.mPhotoCamera.rotateCamera()
    }
    
    @IBAction func onTouchPhotoShutter(){
        print("Photo Shutter Button")
        
        if mPhotoCamera == nil{
            return
        }
        
        let devOrientation = UIDevice.currentDevice().orientation
        
        
        mPhotoCamera.capturePhotoAsJPEGProcessedUpToFilter(mCropFilter) { (processedJPEG, error) -> Void in
            if error != nil{
                print(error)
            }
            
            guard let capturedImage = UIImage(data: processedJPEG)?.fixOrientation() else {
                return
            }
            
            guard let cameraView = self.mCameraView else {
                return
            }
            
            print(capturedImage.imageOrientation.rawValue)
            
            print(capturedImage.size.width)
            print(capturedImage.size.height)

            print(cameraView.bounds.width)
            print(cameraView.bounds.height)
            
            var tempRect: CGRect!
            let cropRect: CGRect!
            
            let imageWidth: CGFloat = min(capturedImage.size.height, capturedImage.size.width)
            let viewWidth = cameraView.bounds.size.width
            let ratio: CGFloat = imageWidth / viewWidth
            
            switch devOrientation {
            case .LandscapeRight:
                tempRect = CGRectMake(
                    (capturedImage.size.width - ratio * cameraView.bounds.size.height) * 0.5,
                    0,
                    cameraView.bounds.size.height * ratio,
                    capturedImage.size.height)
            case .LandscapeLeft:
                tempRect = CGRectMake(
                    (capturedImage.size.width - ratio * cameraView.bounds.size.height) * 0.5,
                    0,
                    cameraView.bounds.size.height * ratio,
                    capturedImage.size.height)
            case .PortraitUpsideDown:
                tempRect = CGRectMake(0,
                    (capturedImage.size.height - ratio * cameraView.bounds.size.height) * 0.5,
                    capturedImage.size.width,
                    ratio * cameraView.bounds.size.height)
            default:
                tempRect = CGRectMake(0,
                    (capturedImage.size.height - ratio * cameraView.bounds.size.height) * 0.5,
                    capturedImage.size.width,
                    ratio * cameraView.bounds.size.height)
            }
            
            cropRect = tempRect;
            
            // Create bitmap image from context using the rect
            let imageRef: CGImageRef = CGImageCreateWithImageInRect(capturedImage.CGImage, cropRect)!
            
            // Create a new image based on the imageRef and rotate back to the original orientation
            let croppedImage: UIImage = UIImage(CGImage: imageRef)
            
            print(croppedImage.size.width)
            print(croppedImage.size.height)
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcAddTagViewController") as! AddTagViewController
            vc.imageData = croppedImage
            vc.width = croppedImage.size.width
            vc.height = croppedImage.size.height
            vc.delegate = self
            vc.flgSave = true
            
            vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            
            self.presentViewController(vc, animated: true, completion: nil)
//            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
        
    }
    
    func sendToService(){
        
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: "https://sheetsu.com"))
        manager.GET(
            "https://sheetsu.com/apis/f6e2ef8c",
            parameters: nil,
            progress: nil,
            success: { task, responseObject in
               
                //print(responseObject)
                let response = responseObject as! NSDictionary
                let arrObj: NSMutableArray = response.objectForKey("result") as! NSMutableArray
                
                gArrDescription = arrObj
                gGetJSON = 1
                
                print(gArrDescription[3].valueForKey("Color"))
                for item in arrObj{
                    let itemData = item as! NSDictionary
                    print(itemData)
                }
                
                NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(gArrDescription), forKey: "ArrDescription")
                
                NSUserDefaults.standardUserDefaults().synchronize()
                
                /*let resultDic : NSDictionary =  (response.result.value as? NSDictionary)!
                if resultDic.valueForKey("data")! === NSNull(){
                    self.showAlertView("Error", message: "NULL object")
                
                    return
                }
                self.myUser =  Users(userId: (resultDic.valueForKey("data")!.valueForKey("userId") as? String)!, userName: (resultDic.valueForKey("data")!.valueForKey("userName") as? String)!, userImage: (resultDic.valueForKey("data")!.valueForKey("userImage") as? String)!, userPhone: (resultDic.valueForKey("data")!.valueForKey("userPhone") as? String)!)!
                
                
                print(responseObject?.objectForKey("result"))*/
            },
            failure: { task, error in
                print("Error: " + error.localizedDescription)
        })
    }
    
    @IBAction func onTouchHistoryButton(){
        print("History Button")
        if let parentVC = self.parentViewController {
            if let parentVC = parentVC as? SnapChatPageViewController{
                parentVC.goHistory(false)
            }
        }
    }
    
    @IBAction func onTouchNutritionButton(){
        print("Nutrition Button")
        if let parentVC = self.parentViewController {
            if let parentVC = parentVC as? SnapChatPageViewController{
                gSearchBarText = ""
                parentVC.goDetail(true)
            }
        }
    }
    
    
    func torchOnOff(){
        if mPhotoCamera == nil{
            return
        }
        
        if mPhotoCamera.inputCamera.torchAvailable == true{
            do{
                try mPhotoCamera.inputCamera.lockForConfiguration()
                
                if mTorchModePhoto == AVCaptureTorchMode.On{
                    mPhotoCamera.inputCamera.torchMode = AVCaptureTorchMode.On
                    mPhotoCamera.inputCamera.flashMode = AVCaptureFlashMode.On
                }else{
                    mPhotoCamera.inputCamera.torchMode = AVCaptureTorchMode.Off
                    mPhotoCamera.inputCamera.flashMode = AVCaptureFlashMode.Off
                }
                
                mPhotoCamera.inputCamera.unlockForConfiguration()
            }catch{
                
            }
            
        }
    }
}

//MARK - Delegates
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func photofromLibrary() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String, kUTTypeVideo as String]
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("print Finish picking image")
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as? String
        
        //Send chosen image
        if mediaType == kUTTypeImage as String {
            var chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage
            if chosenImage == nil {
                chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            
            print(chosenImage!.size.width)
            print(chosenImage!.size.height)
            
            //let fileName = self.saveFileToParse(UIImageJPEGRepresentation(chosenImage!, 0.8)!)
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcAddTagViewController") as! AddTagViewController
            
            vc.imageData = chosenImage
            vc.width = chosenImage!.size.width
            vc.height = chosenImage!.size.height
            vc.delegate = self
            vc.flgSave = true
            
            vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            //picker.presentViewController(vc, animated: true, completion: nil)
            picker.pushViewController(vc, animated: true)
//            self.presentViewController(vc!, animated: true, completion: nil)
            //self.navigationController?.pushViewController(vc!, animated: true)
            //self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.dismissViewControllerAnimated(true){}
        }
    }
    
    func initCamera(){
        if mPhotoCamera != nil {
            mPhotoCamera.stopCameraCapture()
            mPhotoCamera = nil
            NSThread.sleepForTimeInterval(1.0)
        }
        
        if mCropFilter != nil {
            mCropFilter = nil
        }
        
        if mFilterView != nil {
            mFilterView = nil
        }
        
        //self.videoCaptureView.subviews
        //[[mCameraView subviews]
        //    makeObjectsPerformSelector:@selector(removeFromSuperview)];

    }
    
    func setupCameraForPhoto(){
        self.initCamera()
        
        mPhotoCamera = GPUImageStillCamera.init(sessionPreset: AVCaptureSessionPresetHigh, cameraPosition: AVCaptureDevicePosition.Back)
        
        if mPhotoCamera == nil{
            return;
        }
        mPhotoCamera.horizontallyMirrorFrontFacingCamera = true
        
        if UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait{
            mPhotoCamera.outputImageOrientation = UIInterfaceOrientation.Portrait
        }        
        else if UIDevice.currentDevice().orientation == UIDeviceOrientation.PortraitUpsideDown{
            mPhotoCamera.outputImageOrientation = UIInterfaceOrientation.PortraitUpsideDown
        } else {
            mPhotoCamera.outputImageOrientation = UIInterfaceOrientation.Portrait
        }
        
        do {
            
            try mPhotoCamera.inputCamera.lockForConfiguration()
            
            if mPhotoCamera.inputCamera.respondsToSelector("isSmoothAutoFocusSupported"){
                if mPhotoCamera.inputCamera.smoothAutoFocusSupported == true{
                    mPhotoCamera.inputCamera.smoothAutoFocusEnabled = true
                }
            }
            
            mPhotoCamera.inputCamera.unlockForConfiguration()
            
        } catch {
            
        }
        
        self.torchOnOff()
        
        mFilterView = GPUImageView.init(frame: mCameraView.frame)
        mFilterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill
        
        mCameraView.addSubview(mFilterView)
        mCameraView.sendSubviewToBack(mFilterView)
        
        
        mCropFilter = GPUImageFilter.init()
        mCropFilter.addTarget(mFilterView)
        
        mPhotoCamera.addTarget(mCropFilter)
        mPhotoCamera.startCameraCapture()
        
    }
    

}

extension HomeViewController: AddTagViewControllerDelegate {
    func addTagViewControllerDidFinish(addTagViewController: AddTagViewController) {
        self.dismissViewControllerAnimated(false) { () -> Void in
            self.onTouchHistoryButton()
        }
    }
}

extension UIImage {
    func fixOrientation() -> UIImage
    {
        
        if self.imageOrientation == UIImageOrientation.Up {
            return self
        }
        
        var transform = CGAffineTransformIdentity
        
        switch self.imageOrientation {
        case .Down, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI));
            
        case .Left, .LeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2));
            
        case .Right, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2));
            
        case .Up, .UpMirrored:
            break
        }
        
        
        switch self.imageOrientation {
            
        case .UpMirrored, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            
        case .LeftMirrored, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1);
            
        default:
            break;
        }
        
        
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx = CGBitmapContextCreate(
            nil,
            Int(self.size.width),
            Int(self.size.height),
            CGImageGetBitsPerComponent(self.CGImage),
            0,
            CGImageGetColorSpace(self.CGImage),
            UInt32(CGImageGetBitmapInfo(self.CGImage).rawValue)
        )
        
        CGContextConcatCTM(ctx, transform);
        
        switch self.imageOrientation {
            
        case .Left, .LeftMirrored, .Right, .RightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height,self.size.width), self.CGImage);
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width,self.size.height), self.CGImage);
            break;
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg = CGBitmapContextCreateImage(ctx)
        
        let img = UIImage(CGImage: cgimg!)
        
        //CGContextRelease(ctx);
        //CGImageRelease(cgimg);
        
        return img;
        
    }
}