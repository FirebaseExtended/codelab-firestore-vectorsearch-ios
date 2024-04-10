//
// Copyright © 2024 Google LLC. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import Observation
import FirebaseFirestore

@Observable class NotesRepository {
  var notes: [Note] = [Note]()

  @ObservationIgnored
  private lazy var db: Firestore = Firestore.firestore()
  private let notesCollection = "notes"

  @ObservationIgnored
  private var listenerRegistration: ListenerRegistration?
}

extension NotesRepository {
  func createNote() async throws -> Note {
    var note = Note()

    let ref = try? db.collection(notesCollection).addDocument(from: note)
    note.id = ref?.documentID

//    if let documentId = ref?.documentID {
//      return try await db.collection(notesCollection).document(documentId).getDocument(as: Note.self)
//    }

    return note
  }

  func update(note: Note) {
    if let documentID = note.id {
      try? db.collection(notesCollection).document(documentID).setData(from: note, merge: true)
    }
  }

  func delete(note: Note) {
    if let documentID = note.id {
      db.collection(notesCollection).document(documentID).delete()
    }
  }

  func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }

  func subscribe() {
    if listenerRegistration == nil {
      listenerRegistration = db.collection(notesCollection)
        .addSnapshotListener { [weak self] querySnapshot, error in
          guard let documents = querySnapshot?.documents else { return }
          self?.notes = documents.compactMap { queryDocumentSnapshot in
            try? queryDocumentSnapshot.data(as: Note.self)
          }
        }
    }
  }
}
