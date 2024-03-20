//
//  IndicatorPoint.swift
//  LineChart
//
//  Created by András Samu on 2019. 09. 03..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

extension Colors {
    public static let ColorThemeBackground:Color = Color("BackgroundColor")
    public static let ColorThemeAccent:Color = Color("AccentColor")
}

struct IndicatorPoint: View {

    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack{
            Circle()
                .fill(Colors.ColorThemeBackground)
                .shadow(color: Colors.ColorThemeAccent, radius: 4, x: 0, y: -3)
            Circle()
                .stroke(colorScheme == .light ? Color.white : Color.secondary.opacity(0.5), style: StrokeStyle(lineWidth: 5))
        }
        .frame(width: 14, height: 14)
    }
}

struct IndicatorPoint_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorPoint()
    }
}
