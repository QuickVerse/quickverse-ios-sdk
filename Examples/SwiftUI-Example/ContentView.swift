//
//  ContentView.swift
//  SwiftUI-Example
//
//  Created by QuickVerse on 01/05/2023.
//

import SwiftUI
import QuickVerse

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack() {
            Spacer()
            Spacer()
            Text(viewModel.titleText)
                .font(Font(Fonts.lexendMedium(size: 20)))
                .foregroundColor(Brand.Colors.darkGrey.color)
            Text(viewModel.bodyText)
                .font(Font(Fonts.lexendRegular(size: 14)))
                .foregroundColor(Brand.Colors.lightGrey.color)
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading], 40)
                .padding([.top], 8)
            Spacer()
            Text(viewModel.resultSourceText)
                .font(Font(Fonts.lexendMedium(size: 14)))
                .foregroundColor(Brand.Colors.lightGrey.color)
                .padding(.bottom, 24)
            HStack {
                FilledButton(text: "Use System Language",
                             clicked: viewModel.getDeviceLanguageLocalizations)
                
                Button("Change") {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
                .font(Font(Fonts.lexendMedium(size: 14)))
                .foregroundColor(Brand.Colors.primary.color)
            }
            .padding(.bottom, 8)
           
            FilledButton(text: "Cycle Demo Languages",
                         clicked: viewModel.getDemoLanguageLocalizations)
            .padding(.bottom, 24)
        }
        .onAppear {
            viewModel.getDeviceLanguageLocalizations()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
