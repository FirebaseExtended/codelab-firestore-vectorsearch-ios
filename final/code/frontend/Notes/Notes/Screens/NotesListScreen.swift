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

import SwiftUI

struct NotesListScreen {
  @Environment(NotesRepository.self) private var notesRepository
  @State private var path = NavigationPath()
  @State private var searchTerm = ""

  private func deleteNote(note: Note) {
    notesRepository.delete(note: note)
  }

  private func createNote() {
    Task {
      let note = try await notesRepository.createNote()
      path.append(note)
    }
  }
}

extension NotesListScreen: View {
  var body: some View {
    @Bindable var repository = notesRepository

    NavigationStack(path: $path) {
      List(repository.notes) { note in
        NavigationLink(value: note) {
          NoteRowView(note: note)
        }
        .swipeActions {
          Button(role: .destructive, action: { deleteNote(note: note) }) {
            Label("Delete", systemImage: "trash")
          }
        }
      }
      .searchable(text: $searchTerm, prompt: "Search")
      .task(id: searchTerm, nanoseconds: 600_000_000) {
        await notesRepository.semanticSearch(searchTerm: searchTerm)
      }
      .navigationTitle("Notes")
      .navigationDestination(for: Note.self) { note in
        NoteEditScreen(note: note)
      }
      .toolbar {
        ToolbarItem(placement: .bottomBar) {
          Spacer()
        }
        ToolbarItem(placement: .bottomBar) {
          Button(action: createNote) {
            Image(systemName: "square.and.pencil")
          }
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    @State var notesRepository = NotesRepository()
    NotesListScreen()
      .environment(notesRepository)
      .onAppear {
        notesRepository.notes = Note.mocks
      }
  }
}

