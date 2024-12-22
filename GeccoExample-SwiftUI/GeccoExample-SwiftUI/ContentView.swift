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
              .spotlight(at: 0)
          }

          ChildView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button {

            } label: {
              Image(systemName: "gear")
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

struct SpotlightFullScreenOverlay<Index: SpotlightIndex>: View {
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
          .overlayPreferenceValue(SpotlightAnchorPreferenceKey<Index>.self) { values in
            if let preference = values.first(where: { $0.key == spotlightController.index }) {
              GeometryReader { proxy in
                let rect = proxy[preference.value.anchor]

                fullScreenOverlay()
                  .reverseMask(rect: rect) {
                    switch preference.value.kind {
                    case .oval:
                      Circle()
                    case .rect:
                      Rectangle()
                    case .roundedRectangle:
                      RoundedRectangle(cornerRadius: 8)
                    }
                  }
              }
            }
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

enum SpotlightKind: Hashable {
  case oval
  case rect
  case roundedRectangle(cornerRadius: CGFloat)
}

struct SpotlightAnchorPreferenceKey<Index: SpotlightIndex>: PreferenceKey {
  struct Info: Hashable {
    let kind: SpotlightKind
    let anchor: Anchor<CGRect>
  }

  static var defaultValue: [Index: Info] { [:] }

  static func reduce(
    value: inout [Index: Info],
    nextValue: () -> [Index: Info]
  ) {
    value.merge(nextValue()) { $1 }
  }
}

extension View {
  func spotlight<Index: SpotlightIndex>(at index: Index, kind: SpotlightKind = .rect) -> some View {
    anchorPreference(key: SpotlightAnchorPreferenceKey<Index>.self, value: .bounds) { [index: .init(kind: kind, anchor: $0)] }
  }
}

extension View {
  func reverseMask<Shape: SwiftUI.View>(
    rect: CGRect,
    @ViewBuilder shape: @escaping () -> Shape
  ) -> some View {
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

#Preview {
  ContentView()
}
