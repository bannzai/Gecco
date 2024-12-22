import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
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

          ChildView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button {

            } label: {
              Image(systemName: "gear")
                .spotlight(at: 0) {
                  RoundedRectangle(cornerRadius: 10)
                }
            }
          }
        }
      }
    }
  }

  struct ChildView: View {
    @Environment(SpotlightController<Int>.self) var spotlightController

    var body: some View {
      Text(spotlightController.index == nil ? "Not spotlighted" : "Spotlighted")
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

@Observable
class SpotlightController<Index: SpotlightIndex>: AnyObject {
  var index: Index?
  var isPresented = false

  func start() {
    isPresented = true

    show(at: Index.begin())
  }

  func end() {
    isPresented = false
    index = nil
  }

  func show(at index: Index) {
    self.index = index
  }

  func hide(at index: Index) {
    self.index = index
  }

  func next() {
    if let index {
      hide(at: index)

      if let next = index.next() {
        show(at: next)
      } else {
        end()
      }
    } else {
      start()
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

struct Spotlight<Index: SpotlightIndex>: View {
  @Environment(SpotlightController<Index>.self) var spotlightController

  var body: some View {
    EmptyView()
  }
}

struct SpotlightMask<Index: SpotlightIndex, Shape: SwiftUI.Shape>: View {
  let index: Index
  let rect: CGRect
  let spotlightController: SpotlightController<Index>
  @ViewBuilder let shape: () -> Shape

  var body: some View {
    if index == spotlightController.index {
      mask {
        Rectangle()
          .overlay {
            shape()
              .frame(width: rect.width, height: rect.height)
              .offset(x: rect.midX, y: rect.midY)
              .blendMode(.destinationOut)
          }
      }
    }
  }
}

struct SpotlightModifier<Index: SpotlightIndex, Shape: SwiftUI.Shape>: ViewModifier {
  let index: Index
  @State var rect: CGRect?
  @ViewBuilder let shape: () -> Shape

  @Environment(SpotlightController<Index>.self) var spotlightController

  func body(content: Content) -> some View {
    if index == spotlightController.index {
      Group {
        if let rect {
          content
            .mask {
              Rectangle()
                .overlay {
                  shape()
                    .frame(width: rect.width, height: rect.height)
                    .offset(x: rect.minX, y: rect.minY)
                    .blendMode(.destinationOut)
                }
            }
        } else {
          content
        }
      }
      .background {
        GeometryReader { proxy in
          Color.clear.onAppear {
            rect = .init(origin: .zero, size: proxy.size)
          }
        }
      }
    } else {
      content
    }
  }
}

extension View {
  func spotlight<Index: SpotlightIndex, Shape: SwiftUI.Shape>(
    at index: Index,
    @ViewBuilder shape: @escaping () -> Shape
  ) -> some View {
    modifier(
      SpotlightModifier(
        index: index,
        shape: shape
      )
    )
  }
}

#Preview {
  ContentView()
}
