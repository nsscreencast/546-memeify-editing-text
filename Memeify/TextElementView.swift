import SwiftUI

struct TextEditorView: View {
    @Binding var text: String
    @Binding var isEditing: Bool
    @FocusState var isFocused: Bool

    var body: some View {
        if isEditing {
            TextField("Text", text: $text)
                .foregroundColor(.blue)
                .font(.system(size: 24, weight: .bold))
                .hardShadow()
                .fixedSize(horizontal: true, vertical: false)
                .focused($isFocused)
                .onSubmit {
                    isEditing = false
                }
        } else {
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .bold))
                .hardShadow()
                .onTapGesture {
                    isEditing = true
                    isFocused = true
                }
        }
    }
}

struct TextElementView: View {
    @Binding var element: TextElement
    @Binding var isEditing: Bool

    var body: some View {
        TextEditorView(text: $element.text, isEditing: $isEditing)
    }
}

extension View {
    func hardShadow() -> some View {
        self
            .shadow(color: .black, radius: 0.4)
            .shadow(color: .black, radius: 0.4)
            .shadow(color: .black, radius: 0.4)
            .shadow(color: .black, radius: 0.4)
            .shadow(color: .black, radius: 0.4)
    }
}


struct TextElementView_Previews: PreviewProvider {
    static var previews: some View {
        let text = TextElement(text: "Hello world", position: .zero)
        let colors = [Color.white, .black, .blue, .red, .green]

        VStack {
            ForEach(colors, id: \.self) { color in
                TextElementView(element: .constant(text), isEditing: .constant(false))
                    .padding()
                    .background(color)
            }
        }
    }
}
