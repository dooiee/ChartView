//
//  LineView.swift
//  LineChart
//
//  Created by András Samu on 2019. 09. 02..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct LineView: View {
    @ObservedObject var data: ChartData
    public var title: String?
    public var legend: String?
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle
    public var valueSpecifier: String
    public var legendSpecifier: String
    @ObservedObject var dataKeys: ChartDataKeys // added
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var showLegend = false
    @State private var dragLocation:CGPoint = .zero
    @State private var indicatorLocation:CGPoint = .zero
    @State private var closestPoint: CGPoint = .zero
    @State private var opacity:Double = 0
    @State private var currentDataNumber: Double = 0
    @State private var hideHorizontalLines: Bool = false
    @State private var currentDataString: String = "N/A" // added
    
    public init(data: [Double],
                title: String? = nil,
                legend: String? = nil,
                style: ChartStyle = Styles.lineChartStyleOne,
                valueSpecifier: String? = "%.1f",
                legendSpecifier: String? = "%.1f", // changed from "%.2f"
                dataKeys: [String])
    {
        self.data = ChartData(points: data)
        self.title = title
        self.legend = legend
        self.style = style
        self.valueSpecifier = valueSpecifier!
        self.legendSpecifier = legendSpecifier!
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
        self.dataKeys = ChartDataKeys(points: dataKeys)
    }
    
    public var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .leading, spacing: 8) {
                Group{
                    if (self.title != nil){
                        Text(self.title!)
                            .font(.title)
                            .bold().foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.textColor : self.style.textColor)
                    }
                    if (self.legend != nil) && (!self.data.points.isEmpty){
                        if self.currentDataNumber == 0 {
                            Text(" \(self.data.onlyPoints().last!, specifier: valueSpecifier)\(self.legend!)")
                                .font(.callout)
                                .bold()
                                .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.legendTextColor : self.style.legendTextColor)
                        }
                        else {
                            Text(" \(self.currentDataNumber, specifier: valueSpecifier)\(self.legend!)")
    //                        Text(self.legend!) // commented out
                                .font(.callout)
                                .bold()
                                .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.legendTextColor : self.style.legendTextColor)
                        }
                    }
                }.offset(x: 0, y: 20)
                ZStack {
                    GeometryReader{ reader in
                        Rectangle()
                            .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.backgroundColor : self.style.backgroundColor)
                        if(self.showLegend){
                            Legend(data: self.data,
                                   frame: .constant(reader.frame(in: .local)), hideHorizontalLines: self.$hideHorizontalLines, specifier: legendSpecifier)
                                .transition(.opacity)
                                .animation(Animation.easeOut(duration: 1).delay(1))
                        }
                        /*
//                        HStack {
//                            if(self.showLegend){
//                                Legend(data: self.data,
//                                       frame: .constant(reader.frame(in: .local)), hideHorizontalLines: self.$hideHorizontalLines, specifier: legendSpecifier)
//                                    .transition(.opacity)
//                                    .animation(Animation.easeOut(duration: 1).delay(1))
//                            }
//                        }
                         */
                        MagnifierRect(currentNumber: self.$currentDataNumber, currentStringForNumber: self.$currentDataString, indicatorLocation: self.$dragLocation, valueSpecifier: self.valueSpecifier)
                            .opacity(self.opacity)
//                            .offset(x: self.dragLocation.x - 30)
                        Line(data: self.data,
                             frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width - 30, height: reader.frame(in: .local).height + 25)),
                             touchLocation: self.$indicatorLocation,
                             showIndicator: self.$hideHorizontalLines,
                             minDataValue: .constant(nil),
                             maxDataValue: .constant(nil),
                             showBackground: false,
                             gradient: self.style.gradientColor
                        )
                        .offset(x: 30, y: 0)
                        .onAppear(){
                            self.showLegend = true
                        }
                        .onDisappear(){
                            self.showLegend = false
                        }
                    }
                    .frame(width: geometry.frame(in: .local).size.width, height: 240)
                    .offset(x: 0, y: 40 )
                    /* // Old Code
                     MagnifierRect(currentNumber: self.$currentDataNumber, currentStringForNumber: self.$currentDataString, valueSpecifier: self.valueSpecifier)
                         .opacity(self.opacity)
                         .offset(x: self.dragLocation.x - geometry.frame(in: .local).size.width/2, y: 36)
                     */
                }
//                .frame(width: geometry.frame(in: .local).size.width, height: 240)
                .gesture(DragGesture()
                .onChanged({ value in
                    self.dragLocation = value.location
                    self.indicatorLocation = CGPoint(x: max(value.location.x-30,0), y: 32)
                    self.opacity = 1
                    self.closestPoint = self.getClosestDataPoint(toPoint: value.location, width: geometry.frame(in: .local).size.width-30, height: 240)
                    self.hideHorizontalLines = true
                })
                    .onEnded({ value in
                        self.opacity = 0
                        self.hideHorizontalLines = false
                        self.currentDataNumber = 0
                    })
                )
            }
        }
    }
    
    func getClosestDataPoint(toPoint: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points = self.data.onlyPoints()
        let pointsKeys = self.dataKeys.onlyPointsAsString()
        let stepWidth: CGFloat = width / CGFloat(points.count-1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        
        let index:Int = Int(floor((toPoint.x-15)/stepWidth))
        if (index >= 0 && index < points.count){
            self.currentDataNumber = points[index]
            self.currentDataString = pointsKeys[index]
            return CGPoint(x: CGFloat(index)*stepWidth, y: CGFloat(points[index])*stepHeight)
        }
        return .zero
    }
}

struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineView(data: [8,23,54,32,12,37,7,23,43], title: "Full chart", style: Styles.lineChartStyleOne, dataKeys: ["1","2","3","4","5","6","7","8","9"])
        }
    }
}

