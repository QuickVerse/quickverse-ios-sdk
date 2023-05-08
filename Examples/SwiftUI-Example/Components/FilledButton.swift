//
//  FilledButton.swift
//  SwiftUI-Example
//
//  Created by Ed Beecroft on 06/05/2023.
//

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
