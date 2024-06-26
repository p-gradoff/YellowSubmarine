import Foundation
import FirebaseFirestore


protocol LoadModelProtocol : AnyObject {
    func getNote(completion: @escaping (Result<[Note], Error>) -> ())
}

final class LoadModel {
}

private extension LoadModel {
}

extension LoadModel : LoadModelProtocol {
    func getNote(completion: @escaping (Result<[Note], Error>) -> ()) {
        guard let uid = UserData.shared.userID else { return }
        
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("notes")
            .getDocuments { snap, err in
                guard err == nil else {
                    completion(.failure(err!))
                    return
                }
                
                guard let documents = snap?.documents else {
                    completion(.failure(DownloadError.snapError))
                    return
                }
            
                var notes : [Note] = [Note]()
                
                documents.forEach { [weak self] field in
                    guard let self = self else { return }
                    
                    let note = Note(
                        name: field["name"] as? String ?? "",
                        date: field["date"] as? String ?? "",
                        imgUrl: field["imgLink"] as? String ?? "",
                        text: field["text"] as? String ?? ""
                    )
                    
                    notes.append(note)
                }
                completion(.success(notes))
            }
    }
}

struct Note : Identifiable {
    var id : String = UUID().uuidString
    var name : String
    var date : String
    var imgUrl : String
    var text : String
}