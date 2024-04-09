//
// NoteEditScreen.swift
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

@Observable fileprivate class NoteEditViewModel {
  var note: Note

  init(note: Note) {
    self.note = note
  }
}

struct NoteEditScreen {
  @Environment(NotesRepository.self) private var noteRepository
  @State fileprivate var viewModel: NoteEditViewModel
  
  init(note: Note) {
    self.viewModel = NoteEditViewModel(note: note)
  }
}

extension NoteEditScreen: View {
  var body: some View {
    TextEditor(text: $viewModel.note.text)
      .onDisappear {
        noteRepository.update(note: viewModel.note)
      }
  }
}

#Preview {
  NavigationStack {
    @State var note = Note.mock
    NoteEditScreen(note: note)
  }
}
