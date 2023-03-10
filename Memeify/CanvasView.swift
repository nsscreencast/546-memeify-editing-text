import SwiftUI

struct CanvasView: View {
    @State var image: NSImage? = NSImage(named: "decision")
    @State var textElements: [TextElement] = []
    @GestureState var dragStart: CGPoint?
    @State var editingTextElement: TextElement?

    var body: some View {
        GeometryReader { proxy in
            Color(nsColor: .windowBackgroundColor)
                .overlay(
                    canvasBackground
                )
                .onTapGesture {
                    editingTextElement = nil
                }
                .overlay(textElementsLayer)
                .dropDestination(for: Data.self) { items, _location in
                    guard let image = items.lazy.compactMap({
                        NSImage(data: $0)
                    }).first else { return false }

                    self.image = image

                    return true
                }
                .toolbar {
                    Button(action: {
                        let offset = CGFloat(textElements.count) * 10
                        let textElement = TextElement(
                            text: "Hello there",
                            position: .init(x: proxy.size.width / 2 + offset, y: proxy.size.height / 2 + offset))
                        textElements.append(textElement)
                    }) {
                        Image(systemName: "note.text.badge.plus")
                    }
                }
        }
    }

    @ViewBuilder
    private var canvasBackground: some View {
        if let image {
            Image(nsImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.secondary, style: .init(
                        lineWidth: 2,
                        dash: [10]
                    ))
                Text("Drop an image here")
                    .font(.caption)
            }
            .padding()
        }
    }

    @ViewBuilder
    private var textElementsLayer: some View {
        ZStack {
            ForEach($textElements) { $element in
                TextElementView(element: $element, isEditing: editingBinding(for: element))
                    .position(element.position)
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .updating($dragStart, body: { value, state, tx in
                                if state == nil {
                                    state = element.position
                                }
                            })
                            .onChanged({ value in
                                guard let dragStart else { return }
                                var pos = dragStart
                                pos += value.translation
                                element.position = pos
                            })
                    )
            }
        }
    }

    private func editingBinding(for element: TextElement) -> Binding<Bool> {
        .init(
            get: { element.id == editingTextElement?.id },
            set: { newValue in
                editingTextElement = newValue ? element : nil
            }
        )
    }
}

extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGSize) -> CGPoint {
        .init(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
    }

    static func += (lhs: inout CGPoint, rhs: CGSize) {
        lhs = lhs + rhs
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
