//
// NotesListScreen.swift
// Notes
//
// Created by Peter Friese on 08.04.24.
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

struct NotesListScreen: View {
  @Environment(NotesRepository.self) var notesRepository

  var body: some View {
    @Bindable var repository = notesRepository

    List($repository.notes) { $note in
      NavigationLink {
        NoteEditScreen(note: $note)
          .environment(notesRepository)
      } label: {
        NoteRowView(note: note)
      }
    }
    .navigationTitle("Notes")
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

  private func createNote() {
    let note = notesRepository.createNote()
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

