//
//  RegisterVC.swift
//  PBL6
//
//  Created by KietKoy on 02/11/2023.
//

import UIKit
import RxDataSources

protocol RegisterEventDelegate: AnyObject {
    func updateRoleRegister(roleId: String)
}

class RegisterVC: BaseVC<RegisterVM> {

    @IBOutlet weak var collectionView: IntrinsicCollectionView!
    @IBOutlet weak var collectionViewHC: NSLayoutConstraint!
    @IBOutlet weak var textView: ITextView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private var blurEffectView: UIVisualEffectView?
    weak var delegate: RegisterEventDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.fetchData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    init(data: [EventRoleDto]) {
        super.init()
        viewModel.data = data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initViews() {
        super.initViews()
        
        textView.placeHolder("self_introduce_placeholder".localized)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionViewHC.constant = collectionView.intrinsicContentSize.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView!.frame = view.bounds
        blurEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView!, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func configureListView() {
        super.configureListView()
        
        collectionView.registerCellNib(RoleRegisterItemCell.self)
        let layout = ColumnFlowLayout(cellsPerRow: 1, ratio: 24/271, minimumLineSpacing: 10, scrollDirection: .vertical)
        collectionView.collectionViewLayout = layout
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        confirmButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                viewModel.registerEvent(eventRoleId: viewModel.selectedItem?.id ?? "", description: textView.text)
                    .subscribe(onNext: {[weak self] status in
                        guard let self = self else { return }
                        switch status {
                        case .Success:
                            self.dismissVC()
                            delegate?.updateRoleRegister(roleId: viewModel.selectedItem!.id)
                        case .Error(let error):
                            if error?.code == Configs.Server.errorCodeRequiresLogin {
                                AppDelegate.shared().windowMainConfig(vc: LoginVC())
                            } else {
                                AlertVC.showMessage(self,message: AlertMessage(type: .error,
                                                                          description: getErrorDescription(forErrorCode: error!.code))) {}
                            }
                        }
                    })
                    .disposed(by: bag)
            })
            .disposed(by: bag)
        
        cancelButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.dismissVC()
            })
            .disposed(by: bag)
        
        collectionView.rx.modelSelected(EventRoleDto.self)
            .subscribe(onNext: {[weak self] item in
                guard let self = self else { return }
                viewModel.selectedItem(item: item)
            })
            .disposed(by: bag)
        
        textView.rx.text
            .subscribe(onNext: {[weak self] text in
                guard let self = self else { return }
                if text!.isNotEmpty {
                    textView.hidePlaceHolder = true
                } else {
                    textView.hidePlaceHolder = false
                }
            })
            .disposed(by: bag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.dataS
            .map{ [SectionModel(model: (), items: $0)]}
            .bind(to: collectionView.rx.items(dataSource: getEventRoleItemDataSource()))
            .disposed(by: bag)
    }
    
    @objc override func keyboardWillShow(notification:NSNotification) {
        if self.textView.isFirstResponder == true {
                self.view.frame.origin.y -= 50
        }
    }

    @objc override func keyboardWillHide(notification:NSNotification) {
        if self.textView.isFirstResponder == true {
               self.view.frame.origin.y += 50
        }
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
}
