//
//  GlobalView.swift
//  GlobalAttachedVC
//
//  Created by Karanbir Singh on 3/9/18.
//  Copyright © 2018 Abcplusd. All rights reserved.
//

import UIKit

protocol StretchGlobalProtocol:NSObjectProtocol {
    func openStretchController(frame:CGRect)
}


class GlobalView: UIView {

    @IBOutlet weak var globalLabel: UILabel!
    var stretchProtocol:StretchGlobalProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.7
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
    }
    
    @IBAction func openAnimatedVC(_ sender: UIButton) {
        stretchProtocol?.openStretchController(frame:self.frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}

extension UIView{
    
    func snapshot()->UIImage{
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIViewController:StretchGlobalProtocol{
    
    func openStretchController(frame:CGRect) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GlobalStretchedViewControllerIdentifier") as? GlobalStretchedViewController
        vc?.previousImage = self.view.snapshot()
        vc?.globalViewFrame = frame
        self.present(vc!, animated: false, completion: nil)
    }
    
    func attachGlobalView(){
        let globalView = UINib(nibName: "GlobalView", bundle: nil).instantiate(withOwner: self, options: nil).first as? GlobalView
        
        globalView?.stretchProtocol = self
        globalView?.layer.cornerRadius = 5
        globalView?.layer.shadowRadius = 2
        globalView?.layer.shadowOpacity = 0.7
        globalView?.layer.shadowColor = UIColor.black.cgColor
        globalView?.layer.shadowOffset = CGSize.zero
        
        self.view.addSubview(globalView!)
        
        
        globalView?.translatesAutoresizingMaskIntoConstraints = false
        globalView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        globalView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        globalView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        globalView?.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    
}
