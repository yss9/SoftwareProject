//
//  SecondViewController.swift
//  TestSwift
//
//  Created by 서영석 on 2023/04/07.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    guard let uvc = self.storyboard?.instantiateViewController(identifier: "SecondViewController") else {
                          return
                        } //스토리보드 내 MainWebView 뷰컨트롤러를 찾음
                    uvc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve //화면 전환 속성
                    uvc.modalPresentationStyle = .fullScreen // 전체화면으로 화면 전환, 불필요 시 제거
                    self.present(uvc, animated: true) //애니메이션을 사용한다면 True 안하면 False
                }

    }
    
}

