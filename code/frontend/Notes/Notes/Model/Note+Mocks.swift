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

extension Note: Mockable {
  static var mock: Note {
    return mocks[0]
  }

  static var mocks: [Note] {
    [
    .init(text: "Laborum consequat officia incididunt sunt incididunt ullamco nulla ad exercitation officia cupidatat ullamco.\n Lorem amet eu quis nulla qui elit dolore sit deserunt culpa sunt adipisicing esse deserunt esse."),
    .init(text: "Sit voluptate nulla ea enim fugiat quis anim aute cillum magna magna dolor. \n Quis minim ex ullamco occaecat eiusmod nostrud excepteur. Nisi magna exercitation consectetur est dolor irure reprehenderit labore laborum velit anim occaecat cupidatat duis ea."),
    .init(text: "Ea sit tempor quis labore ipsum deserunt adipisicing consequat culpa pariatur minim duis veniam elit ullamco. \n Incididunt consectetur mollit occaecat aliquip laborum et do laboris cillum dolor incididunt."),
    .init(text: "Labore in qui nisi labore reprehenderit in ad est pariatur quis. \n Velit est et magna occaecat laborum aliquip."),
    .init(text: "Officia pariatur consectetur est sit culpa et quis laboris commodo adipisicing ea. \n Incididunt sunt voluptate cillum magna duis mollit mollit incididunt id minim nisi.")
    ]
  }
}

protocol Mockable {
  associatedtype MockType

  static var mock: MockType { get }
  static var mocks: [MockType] { get }
}

extension Mockable {
  static var mocks: [MockType] {
    get { [] }
  }
}
