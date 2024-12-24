//
//  FeliCaSession.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/08.
//

import CoreNFC
import Foundation

final class FeliCaSession: NSObject, ObservableObject, @unchecked Sendable {

    private var session: NFCTagReaderSession!
    private var readHandler: (([Data]?, FeliCaSessionError?) -> Void)?

    /// 読み取りを開始する
    /// - Parameter readHandler: 完了ハンドラ
    ///
    /// [Data]?：日付降順で最大20件、エラーの場合はnil
    /// 
    /// FeliCaSessionError：データを読み取れなかった場合のみ値を設定
    func startReadSession(readHandler: (([Data]?, FeliCaSessionError?) -> Void)?) {
        self.readHandler = readHandler
        startSession()
    }

    private func startSession() {
        guard NFCNDEFReaderSession.readingAvailable else {
            readHandler?(nil, .invalid)
            return
        }

        session = NFCTagReaderSession(pollingOption: .iso18092, delegate: self)
        session.alertMessage = .init(localized: "felica_session_scanning_message")
        session.begin()
    }

    private func handle(dataList: [Data]?, error: FeliCaSessionError?) {
        session.invalidate()
        Task { @MainActor in
            self.readHandler?(dataList, error)
        }
    }

    private func readWithoutEncryption(feliCaTag: NFCFeliCaTag,
                                       serviceCode: Data,
                                       blockList: [Data],
                                       completion: @escaping ([Data]?, FeliCaSessionError?) -> Void) {
        feliCaTag.readWithoutEncryption(serviceCodeList: [serviceCode], blockList: blockList)
        { status1, status2, dataList, error in
            if let error = error {
                print(error)
                completion(nil, .invalidHistories)
                return
            }

            // ステータスがどちらも「0」のときにデータ取得可能
            guard status1 == 0,
                  status2 == 0 else {
                print("ステータスフラグエラー: ", status1, " / ", status2)
                completion(nil, .invalidHistories)
                return
            }
            completion(dataList, nil)
        }
    }
}

extension FeliCaSession: NFCTagReaderSessionDelegate {

    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let tag = tags.first,
              case let .feliCa(feliCaTag) = tag else {
            handle(dataList: nil, error: .notFound)
            return
        }

        session.connect(to: tag) { [weak self] error in
            if let error = error {
                print(error)
                self?.handle(dataList: nil, error: .notConnected)
                return
            }

            // 乗降履歴情報のサービスコードは「009F」リトルエンディアンなので反転
            let historyServiceCode = Data([0x09, 0x0f].reversed())
            feliCaTag.requestService(nodeCodeList: [historyServiceCode]) { nodes, error in
                if let error = error {
                    print(error)
                    self?.handle(dataList: nil, error: .invalidService)
                    return
                }

                guard let data = nodes.first,
                      // 「FFFF」であればサービスが存在している
                      data != Data([0xff, 0xff]) else {
                    print("サービスが存在しない")
                    self?.handle(dataList: nil, error: .invalidService)
                    return
                }

                // 履歴は20件まで読み取れるが一度に12件までしか取れないので2回にわける
                let blockList1 = (0..<10).map { Data([0x80, UInt8($0)]) }
                let blockList2 = (10..<20).map { Data([0x80, UInt8($0)]) }
                self?.readWithoutEncryption(feliCaTag: feliCaTag, serviceCode: historyServiceCode, blockList: blockList1, completion: { dataList1, error in
                    if let error = error {
                        self?.handle(dataList: nil, error: error)
                        return
                    }

                    self?.readWithoutEncryption(feliCaTag: feliCaTag, serviceCode: historyServiceCode, blockList: blockList2, completion: { dataList2, error in
                        if let error = error {
                            self?.handle(dataList: nil, error: error)
                            return
                        }

                        self?.handle(dataList: (dataList1 ?? []) + (dataList2 ?? []), error: nil)
                    })
                })
            }
        }
    }
}
