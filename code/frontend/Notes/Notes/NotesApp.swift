//
// NotesApp.swift
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
import FirebaseCore

@main
struct NotesApp: App {
  @State var notesRepository = NotesRepository()
  
  init() {
    FirebaseApp.configure()
    notesRepository.subscribe()
  }
  
  var body: some Scene {
    WindowGroup {
      NotesListScreen()
        .environment(notesRepository)
    }
  }
}
