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
import FirebaseFunctions
import FirebaseAuth

@Observable class NotesRepository {
  private var allNotes: [Note] = [Note]()
  var notes: [Note] = [Note]()

  @ObservationIgnored
  private lazy var db: Firestore = Firestore.firestore()
  private let notesCollection = "notes"

  @ObservationIgnored
  private lazy var functions: Functions = Functions.functions()

  @ObservationIgnored
  private lazy var vectorSearchQueryCallable: Callable<String, String> = functions.httpsCallable("")

  @ObservationIgnored
  private var listenerRegistration: ListenerRegistration?

  private var user: User?
}

extension NotesRepository {
  func createNote() async throws -> Note {
    var note = Note()
    note.userId = user?.uid

    let ref = try? db.collection(notesCollection).addDocument(from: note)
    note.id = ref?.documentID

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

  func subscribe() {
    if listenerRegistration == nil {
      var query: Query = db.collection(notesCollection)
      if let uid = user?.uid {
        query = query.whereField("userId", isEqualTo: uid)
      }

      listenerRegistration = query
        .addSnapshotListener { [weak self] querySnapshot, error in
          guard let documents = querySnapshot?.documents else { return }
          self?.allNotes = documents.compactMap { queryDocumentSnapshot in
            try? queryDocumentSnapshot.data(as: Note.self)
          }
          self?.notes = self?.allNotes ?? []
        }
    }
  }

  func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }
}

extension NotesRepository {
  func semanticSearch(searchTerm: String) async {
    if searchTerm.isEmpty {
      notes = allNotes
    }
    else {
      let documentIds = await performQuery(searchTerm: searchTerm)
      self.notes = documentIds.compactMap { documentId in
        notes.first {$0.id == documentId }
      }
    }
  }

  private func performQuery(searchTerm: String) async -> [String] {
    return []
  }
}

extension NotesRepository {
  func registerAuthChangeListener() {
    Auth.auth().addStateDidChangeListener { auth, user in
      self.user = user
      self.unsubscribe()
      self.subscribe()
    }
  }
}
