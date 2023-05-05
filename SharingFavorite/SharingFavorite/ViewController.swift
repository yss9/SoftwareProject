//
//  ViewController.swift
//  SharingFavorite
//
//  Created by 서영석 on 2023/03/28.
//

import UIKit

class ViewController: UIViewController {
    
    
    func swipeRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.right:
                self.dismiss(animated: true, completion: nil)
            default: break
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        swipeRecognizer()
        
    }


    }

