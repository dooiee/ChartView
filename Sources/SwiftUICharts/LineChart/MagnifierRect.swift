//
//  MagnifierRect.swift
//  
//
//  Created by Samu András on 2020. 03. 04..
//

import SwiftUI

public struct MagnifierRect: View {
    @Binding var currentNumber: Double
    @Binding var currentStringForNumber: String
    @Binding var indicatorLocation: CGPoint
    var valueSpecifier:String
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    public var body: some View {
        ZStack {
            VStack (alignment: .leading) {
//                Text("\(self.currentNumber, specifier: valueSpecifier)")
                if (self.currentStringForNumber.count > 8 && self.currentStringForNumber.count <= 12) {
                    if self.indicatorLocation.x > 335 {
                        Text("\(self.currentStringForNumber)")
                            .font(.caption)
                            .offset(x: (self.indicatorLocation.x - 335) * -1)
                            .foregroundColor(self.colorScheme == .dark ? Color.white : Color.secondary)
                    }
                    else {
                        Text("\(self.currentStringForNumber)")
                            .font(.caption)
                            .foregroundColor(self.colorScheme == .dark ? Color.white : Color.secondary)
                    }
                }
                else if (self.currentStringForNumber.count > 12) {
                    if self.indicatorLocation.x > 315 {
                        Text("\(self.currentStringForNumber)")
                            .font(.caption)
                            .offset(x: (self.indicatorLocation.x - 315) * -1)
                            .foregroundColor(self.colorScheme == .dark ? Color.white : Color.secondary)
                    }
                    else {
                        Text("\(self.currentStringForNumber)")
                            .font(.caption)
                            .foregroundColor(self.colorScheme == .dark ? Color.white : Color.secondary)
                    }
                }
                else {
                    if self.indicatorLocation.x > 360 {
                        Text("\(self.currentStringForNumber)")
                            .font(.caption)
                            .offset(x: (self.indicatorLocation.x - 360) * -1)
                            .foregroundColor(self.colorScheme == .dark ? Color.white : Color.secondary)
                    }
                    else {
                        Text("\(self.currentStringForNumber)")
                            .font(.caption)
                            .foregroundColor(self.colorScheme == .dark ? Color.white : Color.secondary)
                    }
                }
                Spacer()
                Rectangle().frame(width: 1, height: 230).foregroundColor(Color.secondary.opacity(0.5))
            }
            .frame(height: 240)
            
            /* // Old Code
             //                .font(.system(size: 10, weight: .bold))
                             
                         
             //            if (self.colorScheme == .dark ){
             //                Rectangle().frame(width: 1, height: 225).foregroundColor(Color.secondary).offset(y: 15)
             ////                RoundedRectangle(cornerRadius: 16)
             ////                    .stroke(Color.secondary, lineWidth: self.colorScheme == .dark ? 1 : 0)
             ////                    .frame(width: 60, height: 260)
             //            }else{
             //                RoundedRectangle(cornerRadius: 16)
             //                    .frame(width: 60, height: 280)
             //                    .foregroundColor(Color.white)
             //                    .shadow(color: Colors.LegendText, radius: 12, x: 0, y: 6 )
             //                    .blendMode(.multiply)
             //            }
             */
        }
        .offset(x: max(self.indicatorLocation.x , 30), y: -15)
    }
}
