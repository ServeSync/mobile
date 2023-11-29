//
//  ProofVC.swift
//  PBL6
//
//  Created by KietKoy on 29/11/2023.
//

import UIKit

class ProofVC: BaseVC<ProofVM> {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initViews() {
        super.initViews()
        headerView.roundDifferentCorners(bottomLeft: 24, bottomRight: 24)
    }
    
    override func configureListView() {
        super.configureListView()
        
        collectionView.registerCellNib(ProofItemCell.self)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func addEventForViews() {
        super.addEventForViews()
        
        createButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                
            })
            .disposed(by: bag)
    }
}

extension ProofVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReuseable(ofType: ProofItemCell.self, indexPath: indexPath)
        cell.configure(viewModel.data[indexPath.row])
        
        return cell
    }
    
    
}

extension ProofVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = 48.0
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
