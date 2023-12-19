//
//  ExportFileVC.swift
//  PBL6
//
//  Created by KietKoy on 23/11/2023.
//

import UIKit

protocol DissmissExportFileDelegate: AnyObject {
    func dissmiss()
    func shareExportFile(filePath: String)
}

class ExportFileVC: BaseVC<ExportFileVM> {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var exportFileButton: UIButton!
    
    @IBOutlet weak var startTimeTextfield: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    
    weak var delegate: DissmissExportFileDelegate? = nil
    
    var documentController: UIDocumentInteractionController!
    
    override func initViews() {
        super.initViews()
        
        makeDatePickerForStartTime()
        makeDatePickerForEndTime()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.dissmiss()
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        closeButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                
                self.dismissVC()
            })
            .disposed(by: bag)
        
        exportFileButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                
                if viewModel.endTime < viewModel.startTime {
                    AlertVC.showMessage(self, message: AlertMessage(type: .error,
                                                                    description: "pick_date_error".localized)) {}
                } else {
                    viewModel.handleExportFile()
                        .subscribe(onNext: {[weak self] status in
                            guard let self = self else { return }
                            switch status {
                            case .Success:
                                self.dismissVC()
                                delegate?.shareExportFile(filePath: viewModel.filePath)
                            case .Error(let error):
                                if error?.code == Configs.Server.errorCodeRequiresLogin {
                                    AppDelegate.shared().windowMainConfig(vc: LoginVC())
                                }  else {
                                    self.showToast(message: getErrorDescription(forErrorCode: error?.code ?? ""), state: .error)
                                }
                            }
                        })
                        .disposed(by: bag)
                }
            })
            .disposed(by: bag)
    }
    
    @objc func handleDatePickerForStartTime(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        startTimeTextfield.text = formatter.string(from: sender.date)
        viewModel.startTime = sender.date
    }
    
    @objc func handleDatePickerForEndTime(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        endTimeTextField.text = formatter.string(from: sender.date)
        viewModel.endTime = sender.date
    }
    
    @objc func handleDoneButtonStartTime(sender: UIButton) {
        startTimeTextfield.resignFirstResponder()
    }
    
    @objc func handleDoneButtonEndTime(sender: UIButton) {
        endTimeTextField.resignFirstResponder()
    }
    
    func datePickerForStartTimeValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        startTimeTextfield.text = formatter.string(from: sender.date)
    }
}

extension ExportFileVC {
    func makeDatePickerForStartTime() {
        let inputView = UIView(frame: CGRectMake(0,0, self.view.frame.width, 350))
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .inline
        inputView.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(handleDatePickerForStartTime(sender:)), for: .valueChanged)
        
        let doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width/2) - (100/2), y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor("#049300".toUIColor(), for: .normal)
        inputView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(handleDoneButtonStartTime(sender:)), for: .touchUpInside)
        
        handleDatePickerForStartTime(sender: datePicker)
        
        startTimeTextfield.inputView = inputView
    }
    
    func makeDatePickerForEndTime() {
        let inputView = UIView(frame: CGRectMake(0,0, self.view.frame.width, 350))
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .inline
        inputView.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(handleDatePickerForEndTime(sender:)), for: .valueChanged)
        
        let doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width/2) - (100/2), y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor("#049300".toUIColor(), for: .normal)
        inputView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(handleDoneButtonEndTime(sender:)), for: .touchUpInside)
        
        handleDatePickerForEndTime(sender: datePicker)
        
        endTimeTextField.inputView = inputView
    }
    
}

extension ExportFileVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
