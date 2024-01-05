//
//  LoadingView.swift
//  Photato
//
//  Created by Alexander Sivko on 4.01.24.
//

import SwiftUI

struct LoadingView: View {
    private let roundedRectangleCornerRadius: CGFloat = 10
    private let progressViewShadowRadius: CGFloat = 10
    
    var body: some View {
        ZStack {
            Color(uiColor: .tortilla)
                .ignoresSafeArea()
            ProgressView("Fetching Weather")
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: roundedRectangleCornerRadius)
                        .fill(Color(.systemBackground))
                )
                .shadow(radius: progressViewShadowRadius)
        }
    }
}

#Preview {
    LoadingView()
}
