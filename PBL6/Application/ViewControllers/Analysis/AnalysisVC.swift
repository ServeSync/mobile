//
//  AnalysisVC.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import UIKit
import RxSwift
import RxDataSources

class AnalysisVC: BaseVC<AnalysisVM> {
    
    @IBOutlet weak var charts: CircleCharts!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var educationProgramNameLabel: UILabel!
    @IBOutlet weak var requiredActivityScoreLabel: UILabel!
    @IBOutlet weak var numberOfEventsLabel: UILabel!
    @IBOutlet weak var gainScoreLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBOutlet weak var exportFileButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var shadowBackground: UIView!
    
    private var refreshControl = UIRefreshControl()
    private var percentage:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func initViews() {
        super.initViews()
        
        self.charts.circleBorderColor = UIColor(hex: 0x26C6DA, alpha: 0.5)
        self.charts.circleFilledColor = UIColor(hex: 0x26C6DA, alpha: 1)
        charts.bindPercentage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.educationProgramData
            .subscribe(onNext: {[weak self] data in
                guard let self = self else { return }
                educationProgramNameLabel.text = data.name
                requiredActivityScoreLabel.text = "\(data.requiredActivityScore)"
                numberOfEventsLabel.text = "\(data.numberOfEvents)"
                gainScoreLabel.text = "\(Int(data.gainScore))"
                percentage = data.gainScore / Double(data.requiredActivityScore)
                if percentage > 1 {
                    percentage = 1
                    percentageLabel.text = "complete".localized
                } else {
                    let formattedPercentage = String(format: "%.2f%%", percentage * 100)
                    percentageLabel.text = formattedPercentage
                }
                charts.percentageR.accept(percentage)
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
        
        let layout = ColumnFlowLayout(cellsPerRow: 1, ratio: 48/343, minimumInteritemSpacing: 8, minimumLineSpacing: 8, scrollDirection: .vertical)
        collectionView.collectionViewLayout = layout
        collectionView.registerCellNib(DetailItemCell.self)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh",
                                                            attributes: [NSAttributedString.Key.foregroundColor: "text".toUIColor()])
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.tintColor  = "Primary".toUIColor()
        collectionView.refreshControl = self.refreshControl
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        exportFileButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                
                shadowBackground.isHidden = false
                let vc = ExportFileVC()
                vc.delegate = self
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.presentVC(vc)
            })
            .disposed(by: bag)
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

extension AnalysisVC: DissmissExportFileDelegate {
    func dissmiss() {
        self.shadowBackground.isHidden = true
    }
    func shareExportFile(filePath: String) {
        let url = URL(string: filePath)!
        let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activity.excludedActivityTypes = [
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.openInIBooks,
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.mail,
            UIActivity.ActivityType.message,
            UIActivity.ActivityType.postToFacebook,
            UIActivity.ActivityType.print,
        ]
        present(activity, animated: true)
    }
}
