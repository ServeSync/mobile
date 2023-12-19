//
//  ProofVC.swift
//  PBL6
//
//  Created by KietKoy on 29/11/2023.
//

import UIKit
import RxDataSources

class ProofVC: BaseVC<ProofVM> {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchData()
            .subscribe(onNext: {[weak self] status in
                guard let self = self else { return }
                switch status {
                case .Success:
                    return
                case .Error(let error):
                    viewModel.messageData.accept(AlertMessage(type: .error,
                                                              description: getErrorDescription(forErrorCode: error!.code)))
                }
            })
            .disposed(by: bag)
    }
    
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
        let layout = ColumnFlowLayout(cellsPerRow: 1, ratio: 48/327, minimumLineSpacing: 12, scrollDirection: .vertical)
        collectionView.collectionViewLayout = layout
    }

    override func addEventForViews() {
        super.addEventForViews()
        
        createButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                let vc = CreateProofVC()
                vc.delegate = self
                self.pushVC(vc)
            })
            .disposed(by: bag)
        
        collectionView.rx.modelSelected(ProofDto.self)
            .subscribe(onNext: {[weak self] item in
                guard let self = self else { return }
                let vc = SeeProofVC(id: item.id)
                self.pushVC(vc)
            })
            .disposed(by: bag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.proofItemsData
            .map {[SectionModel(model: (), items: $0)]}
            .bind(to: collectionView.rx.items(dataSource: getProofItemDataSource() {[weak self] proofItem in
                guard let self = self else { return }
                let popupConfirm = UIAlertController(title: "confirm".localized, message: "delete_proof_title_confirm".localized, preferredStyle: UIAlertController.Style.alert)

                popupConfirm.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: { (action: UIAlertAction!) in
                    self.viewModel.handleDeleteProof(proofItem)
                        .subscribe(onNext: {[weak self] status in
                            guard let self = self else { return }
                            switch status {
                            case .Success:
                                return
                            case .Error(let error):
                                viewModel.messageData.accept(AlertMessage(type: .error,
                                                                          description: getErrorDescription(forErrorCode: error!.code)))
                            }
                        })
                        .disposed(by: self.bag)
                  }))

                popupConfirm.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: { (action: UIAlertAction!) in
                  }))
                
                self.presentVC(popupConfirm)
            }))
            .disposed(by: bag)
    }
}

extension ProofVC: CreateProofDelegate {
    func createProofSucces() {
        self.showToast(message: "create_proof_success".localized, state: .success)
    }
}
