//
//  AnalysisVC.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import UIKit
import RxDataSources

class AnalysisVC: BaseVC<AnalysisVM> {
    
    @IBOutlet weak var charts: CircleCharts!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var educationProgramNameLabel: UILabel!
    @IBOutlet weak var requiredActivityScoreLabel: UILabel!
    @IBOutlet weak var numberOfEventsLabel: UILabel!
    @IBOutlet weak var gainScoreLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchData(isRefresh: true)
            .subscribe(onNext: {[weak self] status in
                guard let self = self else { return }
                switch status {
                case .Success:
                    return
                case .Error(error: let error):
                    if error?.code == Configs.Server.errorCodeRequiresLogin {
                        AppDelegate.shared().windowMainConfig(vc: LoginVC())
                    } else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: getErrorDescription(forErrorCode: error!.code)))
                    }
                }
            })
            .disposed(by: bag)
    }
    
    override func initViews() {
        super.initViews()
        self.charts.circleBorderColor = UIColor(hex: 0x26C6DA, alpha: 0.5)
        self.charts.circleFilledColor = UIColor(hex: 0x26C6DA, alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.charts.progressAnimation(duration: 1.5)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.educationProgramData
            .subscribe(onNext: {[weak self] data in
                guard let self = self else { return }
                educationProgramNameLabel.text = data.name
                requiredActivityScoreLabel.text = "\(data.requiredActivityScore)"
                numberOfEventsLabel.text = "\(data.numberOfEvents)"
                gainScoreLabel.text = "\(Int(data.gainScore))"
                self.charts.percentage = data.gainScore / Double(data.requiredActivityScore)
                percentageLabel.text = "\(Int(data.gainScore) / data.requiredActivityScore)%"
            })
            .disposed(by: bag)
        
        viewModel.studentNameData
            .subscribe(onNext: {[weak self] name in
                guard let self = self else { return }
                nameLabel.text = name
            })
            .disposed(by: bag)
        
        viewModel.messageData.asObservable()
            .subscribe(onNext: { [weak self] alert in
                guard let self = self else { return }
                AlertVC.showMessage(self, message: AlertMessage(type: alert.type,
                                                                description: alert.description)) {}
            })
            .disposed(by: bag)
        
        viewModel.attendanceEventsData
            .do { [weak self] data in
                guard let self = self else { return }
                if data.isEmpty {
                    collectionView.setEmptyMessage("no_attendane_student".localized)
                } else {
                    collectionView.hideEmptyMessage()
                }
            }
            .map {[SectionModel(model: (), items: $0)]}
            .bind(to: collectionView.rx.items(dataSource: getAnalysisEventItemDataSource()))
            .disposed(by: bag)
        
        collectionView.rx.willDisplayCell
            .subscribe(onNext: {[weak self] cell, indexPath in
                guard let self = self else { return }
                if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
                    self.viewModel.loadMore()
                        .subscribe(onNext: {[weak self] status in
                            guard let self = self else { return }
                            switch status {
                            case .Success:
                                return
                            case .Error(let error):
                                if error?.code == Configs.Server.errorCodeRequiresLogin {
                                    AppDelegate.shared().windowMainConfig(vc: LoginVC())
                                } else {
                                    viewModel.messageData.accept(AlertMessage(type: .error, description: getErrorDescription(forErrorCode: error!.code)))
                                }
                            }
                        })
                        .disposed(by: bag)
                }
            })
            .disposed(by: bag)
    }
    
    override func configureListView() {
        super.configureListView()
        
        let layout = ColumnFlowLayout(cellsPerRow: 2, ratio: 48/343, minimumInteritemSpacing: 8, minimumLineSpacing: 8, scrollDirection: .vertical)
        collectionView.collectionViewLayout = layout
        collectionView.registerCellNib(DetailItemCell.self)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh",
                                                            attributes: [NSAttributedString.Key.foregroundColor: "text".toUIColor()])
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.tintColor  = "Primary".toUIColor()
        collectionView.refreshControl = self.refreshControl
    }
}

extension AnalysisVC {
    @objc func refresh(_ sender: AnyObject) {
        viewModel.fetchData(isRefresh: true)
            .subscribe(onNext: {[weak self] status in
                guard let self = self else { return }
                switch status {
                case .Success:
                    return
                case .Error(let error):
                    if error?.code == Configs.Server.errorCodeRequiresLogin {
                        AppDelegate.shared().windowMainConfig(vc: LoginVC())
                    } else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: getErrorDescription(forErrorCode: error!.code)))
                    }
                }
            })
            .disposed(by: bag)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.refreshControl.endRefreshing()
        })
    }
}
