import SwiftUI

struct ContentView: View {
  var body: some View {
    DefaultGeccoProvider { spotlightController in
      VStack {
        Image(systemName: "globe")
          .imageScale(.large)
          .foregroundStyle(.tint)
        Text("Hello, world!")

        Button {
          if spotlightController.isPresented {
            spotlightController.end()
          } else {
            spotlightController.start()
          }
        } label: {
          Text("Start tutorial")
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}

protocol SpotlightIndex: Hashable {
  static func begin() -> Self
  func next() -> Self?
}

extension Int: SpotlightIndex {
  static func begin() -> Self {
    0
  }

  func next() -> Self? {
    self + 1
  }
}

extension RawRepresentable where Self: SpotlightIndex, Self: CaseIterable {
  static func begin() -> Self {
    allCases.first!
  }

  func next() -> Self? {
    guard let index = Self.allCases.firstIndex(of: self) else {
      return nil
    }
    let nextIndex = Self.allCases.index(after: index)
    return nextIndex < Self.allCases.endIndex ? Self.allCases[nextIndex] : nil
  }
}

@Observable
class SpotlightController<T> where T : SpotlightIndex {
  var index = T.begin()
  var isPresented = false

  func start() {
    isPresented = true
  }

  func end() {
    isPresented = false
  }

  func show(at index: T) {
    self.index = index
  }

  func hide(at index: T) {
    self.index = index
  }

  func next() {
    hide(at: index)

    if let next = index.next() {
      show(at: next)
    } else {
      end()
    }
  }
}

struct SpotlightFullScreenOverlay<T: SpotlightIndex>: View {
  var opacity: CGFloat = 0.5
  var ignoresSafeAreaEdgeSet: Edge.Set? = .all

  var body: some View {
    Color.black.opacity(opacity)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .ignoresSafeArea(edges: ignoresSafeAreaEdgeSet ?? [])
  }
}

struct GeccoProvider<Content: View, Index: SpotlightIndex>: View {
  @ViewBuilder let content: (SpotlightController<Index>) -> Content
  @ViewBuilder let fullScreenOverlay: () -> SpotlightFullScreenOverlay<Index>

  init(
    @ViewBuilder content: @escaping ( SpotlightController<Index>) -> Content,
    @ViewBuilder fullScreenOverlay: @escaping () -> SpotlightFullScreenOverlay<Index> = { .init() }
  ) {
    self.content = content
    self.fullScreenOverlay = fullScreenOverlay
  }

  var spotlightController = SpotlightController<Index>()

  var body: some View {
    Group {
      if spotlightController.isPresented {
        content(spotlightController)
          .overlay {
            fullScreenOverlay()
          }
          .onTapGesture {
            spotlightController.next()
          }
      } else {
        content(spotlightController)
      }
    }
    .environment(spotlightController)
  }
}


struct DefaultGeccoProvider<Content: View>: View {
  @ViewBuilder let content: (SpotlightController<Int>) -> Content

  var body: some View {
    GeccoProvider(content: content)
  }
}

#Preview {
  ContentView()
}
