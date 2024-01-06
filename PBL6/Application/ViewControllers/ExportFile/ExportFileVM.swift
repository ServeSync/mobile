//
//  ExportFileVM.swift
//  PBL6
//
//  Created by KietKoy on 23/11/2023.
//

import Foundation
import RxSwift

class ExportFileVM: BaseVM {
    var startTime: Date = Date()
    var endTime: Date = Date()
    var filePath: String = ""
    
    func handleExportFile() -> Observable<HandleStatus> {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let exportStudentAttendanceEventsDto = ExportStudentAttendanceEventsDto(fromDate: formatter.string(from: startTime),
                                                                                toDate: formatter.string(from: endTime))
        return remoteRepository.exportFile(exportStudentAttendanceEventsDto: exportStudentAttendanceEventsDto)
            .trackError(errorTracker)
            .trackActivity(indicatorLoading)
            .map { response in
                if 200...299 ~= response.statusCode {
                    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let filePath = documentsPath.appendingPathComponent("student.xlsx")

                    if FileManager.default.fileExists(atPath: filePath.path) {
                        do {
                            try FileManager.default.removeItem(at: filePath)
                            print("Đã xóa tệp cũ thành công.")
                        } catch {
                            print("Lỗi khi xóa tệp cũ: \(error)")
                        }
                    }

                    if FileManager.default.createFile(atPath: filePath.path, contents: nil, attributes: nil) {
                        print("Đã tạo tệp mới thành công.")
                    } else {
                        print("Lỗi khi tạo tệp mới.")
                    }
                    do {
                        try response.data.write(to: filePath)
                        self.filePath = filePath.absoluteString
                        print("File saved successfully at: \(filePath)")
                    } catch {
                        print("Error saving file: \(error)")
                    }
                    return .Success
                } else {
                    let errorCode = try response.mapString(atKeyPath: "code")
                    let message = try response.mapString(atKeyPath: "message")
                    return .Error(error: ErrorResponse(code: errorCode, message: message))
                }
            }
            .catch { error in
                return Observable.just(.Error(error: error as? ErrorResponse))
            }
    }
}
