import SwiftUI

struct FilledButton: View {
    var text: String
    var clicked: (() -> Void)
    
    var body: some View {
        Button(action: clicked) {
            Text(text)
                .font(Font(Fonts.lexendMedium(size: 14)))
                .padding(14)
        }
        .background(Brand.Colors.primary.color)
        .foregroundColor(.white)
        .cornerRadius(4)
    }
}
