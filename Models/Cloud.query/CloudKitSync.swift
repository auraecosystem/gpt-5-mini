import Foundation
import CloudKit

final class CloudKitSync {
    static let shared = CloudKitSync()
    private init() {}

    private let container = CKContainer.default()
    private let privateDB = CKContainer.default().privateCloudDatabase
    private let recordType = "Transcript"

    func upload(_ t: Transcript, completion: ((Result<Void, Error>) -> Void)? = nil) {
        let recID = CKRecord.ID(recordName: t.id.uuidString)
        let rec = CKRecord(recordType: recordType, recordID: recID)
        rec["text"] = t.text as NSString
        rec["language"] = t.language as NSString
        rec["date"] = t.date as NSDate
        if let sum = t.gptSummary { rec["gptSummary"] = sum as NSString }

        privateDB.save(rec) { _, err in
            if let e = err { completion?(.failure(e)) } else { completion?(.success(())) }
        }
    }

    func delete(_ id: UUID, completion: ((Result<Void, Error>) -> Void)? = nil) {
        let recID = CKRecord.ID(recordName: id.uuidString)
        privateDB.delete(withRecordID: recID) { _, err in
            if let e = err { completion?(.failure(e)) } else { completion?(.success(())) }
        }
    }

    func fetchAll(completion: @escaping (Result<[Transcript], Error>) -> Void) {
        let q = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        let op = CKQueryOperation(query: q)
        var results: [Transcript] = []

        op.recordFetchedBlock = { rec in
            if let text = rec["text"] as? String,
               let lang = rec["language"] as? String,
               let date = rec["date"] as? Date {
                let id = UUID(uuidString: rec.recordID.recordName) ?? UUID()
                let transcript = Transcript(id: id, text: text, language: lang, date: date, gptSummary: rec["gptSummary"] as? String)
                results.append(transcript)
            }
        }

        op.queryCompletionBlock = { _, err in
            if let e = err { completion(.failure(e)) } else { completion(.success(results)) }
        }

        privateDB.add(op)
    }
}
