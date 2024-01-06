//
//  MainVC.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import UIKit
 

class MainVC: BaseVC<BaseVM> {
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var pageView: UIView!
    
    @IBOutlet weak var navHomeImageView: UIImageView!
    @IBOutlet weak var navHomeButton: UIButton!
    
    @IBOutlet weak var navEventImageView: UIImageView!
    @IBOutlet weak var navEventButton: UIButton!
    
    @IBOutlet weak var navAnalysisImageView: UIImageView!
    @IBOutlet weak var navAnalysisButton: UIButton!
    
    @IBOutlet weak var navProofImageView: UIImageView!
    @IBOutlet weak var navProofButton: UIButton!
    
    @IBOutlet weak var navProfileImageView: UIImageView!
    @IBOutlet weak var navProfileButton: UIButton!
    
    private var pageVC: PageVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectNavHome()
    }
    
    override func initViews() {
        super.initViews()
        
        setupPageView()
        
        navView.addDropShadow(shadowRadius: 4, offset: CGSize(width: 0, height: 0), color: UIColor(hex: 0x000000, alpha: 0.25))
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        navHomeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                selectNavHome()
            })
            .disposed(by: bag)
        
        navEventButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                selectNavEvent()
            })
            .disposed(by: bag)
        
        navAnalysisButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                selectNavAnalysis()
            })
            .disposed(by: bag)
        
        navProofButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                selectNavProof()
            })
            .disposed(by: bag)
        
        navProfileButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                selectNavProfile()
            })
            .disposed(by: bag)
    }

}

extension MainVC {
    
    private func selectNavHome() {
        selectNavItem(index: 0)
    }

    private func selectNavEvent() {
        selectNavItem(index: 1)
    }

    private func selectNavAnalysis() {
        selectNavItem(index: 2)
    }

    private func selectNavProof() {
        selectNavItem(index: 3)
    }

    private func selectNavProfile() {
        selectNavItem(index: 4)
    }

    
    private func selectNavItem(index: Int) {
        
        navHomeImageView.isHighlighted = false
        navEventImageView.isHighlighted = false
        navAnalysisImageView.isHighlighted = false
        navProofImageView.isHighlighted = false
        navProfileImageView.isHighlighted = false

        switch index {
        case 0:
            navHomeImageView.isHighlighted = true
        case 1:
            navEventImageView.isHighlighted = true
        case 2:
            navAnalysisImageView.isHighlighted = true
        case 3:
            navProofImageView.isHighlighted = true
        case 4:
            navProfileImageView.isHighlighted = true
        default:
            break
        }

        pageVC.handleUIChangePage(pageIndex: index)
    }

    
    private func setupPageView() {
        pageVC = PageVC()
        
        addChild(pageVC)
        pageVC.view.frame = pageView.bounds
        pageView.addSubview(pageVC.view)
        
        pageVC.didMove(toParent: self)
    }
}
