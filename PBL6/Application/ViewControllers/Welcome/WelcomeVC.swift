//
//  WelcomeVC.swift
//  PBL6
//
//  Created by KietKoy on 11/09/2023.
//

import UIKit
import RxSwift

class WelcomeVC: BaseVC<WelcomeVM> {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        startButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.pushVC(HomeVC())
                UserDefaultHelper.shared.firstLaunchApp.toggle()
            })
            .disposed(by: bag)
    }
    
    override func configureListView() {
        super.configureListView()
        
        collectionView.registerCellNib(WelcomeSlideCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension WelcomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfSlides()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WelcomeSlideCell.identifier, for: indexPath) as! WelcomeSlideCell
        cell.configure(viewModel.slide(at: indexPath.row))
        
        return cell
    }
}

extension WelcomeVC: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = currentPage
    }
}

extension WelcomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        
        return CGSize(width: width, height: height)
    }
}
