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

struct DebouncingTaskViewModifier<T: Equatable>: ViewModifier {
  let id: T
  let priority: TaskPriority
  let nanoseconds: UInt64
  let action: @Sendable () async -> Void

  init(id: T, 
       priority: TaskPriority = .userInitiated,
       nanoseconds: UInt64 = 0,
       action: @escaping @Sendable () async -> Void) {
    self.id = id
    self.priority = priority
    self.nanoseconds = nanoseconds
    self.action = action
  }

  func body(content: Content) -> some View {
    content.task(id: id, priority: priority) {
      do {
        try await Task.sleep(nanoseconds: nanoseconds)
        await action()
      }
      catch {
        // Debounced
      }
    }
  }
}

extension View {
  /// A version of tha task modifier that debounces changes.
  ///
  /// - Parameters:
  ///   - id: The value to observe for changes. The value must conform
  ///     to the <doc://com.apple.documentation/documentation/Swift/Equatable>
  ///     protocol.
  ///   - priority: The task priority to use when creating the asynchronous
  ///     task. The default priority is
  ///     <doc://com.apple.documentation/documentation/Swift/TaskPriority/userInitiated>.
  ///   - nanoseconds: The number of nanoseconds to suspend this task for.
  ///   - action: A closure that SwiftUI calls as an asynchronous task
  ///     before the view appears. SwiftUI can automatically cancel the task
  ///     after the view disappears before the action completes. If the
  ///     `id` value changes, SwiftUI cancels and restarts the task.
  /// - Returns: A view that runs the specified action asynchronously before
  ///   the view appears, or restarts the task when the `id` value changes.
  public func task<T>(id: T,
                      priority: TaskPriority = .userInitiated,
                      nanoseconds: UInt64 = 0,
                      _ action: @escaping @Sendable () async -> Void) -> some View where T : Equatable {
    modifier(
      DebouncingTaskViewModifier(id: id,
                                 priority: priority,
                                 nanoseconds: nanoseconds,
                                 action: action))
  }
}
