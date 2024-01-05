//
//  LocationNameTitleView.swift
//  Photato
//
//  Created by Alexander Sivko on 4.01.24.
//

import SwiftUI

struct LocationNameTitleView: View {
    private let zStackLocationFrameHeight: CGFloat = 50
    private let vStackSpacing: CGFloat = 0
    private let roundedRectangleCornerRadius: CGFloat = 3
    private let roundedRectangleFrameWidth: CGFloat = 70
    private let roundedRectangleFrameHeight: CGFloat = 5
    private let zStackBarFrameHeight: CGFloat = 30
    
    let locationName: String
    
    var body: some View {
        VStack(spacing: vStackSpacing) {
            ZStack {
                Color(uiColor: .tortilla)
                    .ignoresSafeArea()
                RoundedRectangle(cornerRadius: roundedRectangleCornerRadius)
                    .foregroundStyle(Color(uiColor: .lightTortilla))
                    .frame(width: roundedRectangleFrameWidth, height: roundedRectangleFrameHeight)
            }
            .frame(height: zStackBarFrameHeight)
            ZStack {
                Color(uiColor: .tortilla)
                    .ignoresSafeArea()
                Text(locationName)
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .frame(alignment: .top)
            }
            .frame(height: zStackLocationFrameHeight)
        }
    }
}

#Preview {
    LocationNameTitleView(locationName: "Location name")
}
