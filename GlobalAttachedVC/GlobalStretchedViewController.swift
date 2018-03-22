//
//  GlobalStretchedViewController.swift
//  GlobalAttachedVC
//
//  Created by Karanbir Singh on 3/9/18.
//  Copyright © 2018 Abcplusd. All rights reserved.
//

import UIKit

class GlobalStretchedViewController: UIViewController {

    @IBOutlet weak var previousControllerScreenShotImageView: UIImageView!

    @IBOutlet weak var previousControllerImageLeading: NSLayoutConstraint!
    @IBOutlet weak var previousControllerImageTop: NSLayoutConstraint!
    @IBOutlet weak var previousControllerImageTrailing: NSLayoutConstraint!
    @IBOutlet weak var previousControllerImageBottom: NSLayoutConstraint!
    
    @IBOutlet weak var scrollViewTopInset: NSLayoutConstraint!
    @IBOutlet weak var mainViewControllerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    
    var previousImage:UIImage?
    var globalViewFrame:CGRect?
    let animationDuration = 1.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        scrollView.delegate = self
        setupBackgroundImageView()
        setupMainView()
    }

    func setupBackgroundImageView(){
        previousControllerScreenShotImageView.image = previousImage
        previousControllerScreenShotImageView.layer.cornerRadius = 10
        previousControllerScreenShotImageView.clipsToBounds = true
    }
    
    func setupMainView(){
        scrollViewTopInset.constant = (globalViewFrame?.minY)!
        mainViewControllerView.layer.cornerRadius = 10
        mainViewControllerView.layer.shadowRadius = 2
        mainViewControllerView.layer.shadowOpacity = 0.5
        mainViewControllerView.layer.shadowColor = UIColor.black.cgColor
        mainViewControllerView.layer.shadowOffset = CGSize.zero
        if #available(iOS 11.0, *) {
            mainViewControllerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animatePreviousControllerImage()
        animateMainView()
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 2000)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dismissController(_ sender: Any) {
        dismissAnimations { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}

extension GlobalStretchedViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print(scrollView.contentOffset)
        if scrollView.contentOffset.y < 0{
            dynamicScrollAnimations(minY: scrollView.contentOffset.y)
        }
    }
}

// animations

extension GlobalStretchedViewController{
    func animatePreviousControllerImage(){
        UIView.animate(withDuration: animationDuration) {
            self.previousControllerImageTop.constant = 20
            self.previousControllerImageBottom.constant = 20
            self.previousControllerImageLeading.constant = 20
            self.previousControllerImageTrailing.constant = 20
            self.view.layoutSubviews()
        }
    }
    
    func animateMainView(){
        UIView.animate(withDuration: animationDuration) {
            self.scrollViewTopInset.constant = 60
            self.scrollView.layoutSubviews()
        }
    }
    
    func dismissAnimations(completion:@escaping (_ value:Bool)->Void){
        UIView.animate(withDuration: animationDuration) {
            self.previousControllerImageTop.constant = 0
            self.previousControllerImageBottom.constant = 0
            self.previousControllerImageLeading.constant = 0
            self.previousControllerImageTrailing.constant = 0
            self.view.layoutSubviews()
        }
        UIView.animate(withDuration: animationDuration, animations: {
            self.scrollViewTopInset.constant = (self.globalViewFrame?.minY)!
            self.scrollView.layoutSubviews()
        }) { (_) in
            completion(true)
        }
    }
    
    func dynamicScrollAnimations(minY:CGFloat){
        
        let stretchPercent = (abs(minY)/((UIApplication.shared.keyWindow?.bounds.height)! - 100)) * 100
        
        //print(stretchPercent)
        if stretchPercent > 23{
            scrollView.delegate = nil
            dismissController(UIButton())
            return
        }
        
        let previousImageValue = 20 - (stretchPercent * 20)/100
        self.previousControllerImageTop.constant = previousImageValue
        self.previousControllerImageBottom.constant = previousImageValue
        self.previousControllerImageLeading.constant = previousImageValue
        self.previousControllerImageTrailing.constant = previousImageValue
        self.view.layoutSubviews()
    }
}
