//
//  LineGraph.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 10/6/22.
//

import SwiftUI

struct LineGraph: View {
    @State var valuePoint = ""
    @State var valueDate = ""
    @State var offset: CGSize = .zero
    @State var showPlot = false
    @State var translation: CGFloat = 0
    
    var data: [CGFloat]
    var parameters: [Parameter]
    var parameterType: ParameterType
    
    var body: some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            let width = (proxy.size.width) / CGFloat(data.count - 1)
            
            let maxPoint = (data.max() ?? 0) + 100
            
            let points = data.enumerated().compactMap { item -> CGPoint  in
                let progress = item.element / maxPoint
                let pathHeight = progress * height
                let pathWidth = width * CGFloat(item.offset)
                
                return CGPoint(x: pathWidth, y: -pathHeight + height)
            }
            
            VStack {
                HStack {
                    Text("Minimum value:")
                        .font(.caption.bold())
                    Text("\(parameterType.minValue, specifier: "%.2f") \(parameterType.unit)")
                        .font(.caption.bold())
                    Spacer()
                    Text("Maximum value:")
                        .font(.caption.bold())
                    Text("\(parameterType.maxValue, specifier: "%.2f") \(parameterType.unit)")
                        .font(.caption.bold())
                }
                ZStack {
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLines(points)
                    }
                    .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                    .fill(
                        Color("MainColor")
                    )
                    
                    FillBG()
                        .clipShape(
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: 0))
                                path.addLines(points)
                                path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                                path.addLine(to: CGPoint(x: 0, y: height))
                            }
                        )
                }
                .overlay(
                    VStack(spacing: 0) {
                        VStack {
                            Text(valuePoint + " " + parameterType.unit)
                                .font(.caption)
                            
                            Text(valueDate)
                                
                        }
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 8)
                        .background(Color("MainColor"), in:Capsule())
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                        
                        
                        Rectangle()
                            .fill(Color("MainColor"))
                            .frame(width: 1, height: 45)
                            .padding(.top)
                        
                        Circle()
                            .fill(Color("MainColor"))
                            .frame(width: 22, height: 22)
                            .overlay(
                                Circle()
                                    .fill(.white)
                                    .frame(width: 10, height: 10)
                            )
                        
                        Rectangle()
                            .fill(Color("MainColor"))
                            .frame(width: 1, height: 50)
                            .opacity(0)
                    }
                        .frame(width: 80, height: 170)
                        .offset(y: 80)
                        .offset(offset)
                        .opacity(showPlot ? 1 : 0 ),
                    alignment: .bottomLeading
                )
                .contentShape(Rectangle())
                .gesture(DragGesture().onChanged({ value in
                    withAnimation{showPlot = true}
                    
                    let translation = value.location.x - 40
                    
                    let index = (min(Int((translation / width).rounded()), data.count - 1))
                    
                    valuePoint = "\(parameters[index].value)"
                    valueDate = (parameters[index].date ?? Date.now).extractDate(format: "MMM-yyyy")
                    
                    self.translation = translation
                    
                    offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
                }).onEnded({ value in
                    withAnimation{showPlot = false}
                }))
            }
        }
        .padding(.horizontal, 10)
    }
}

@ViewBuilder
func FillBG() -> some View {
    LinearGradient(colors: [
        .red.opacity(0.3),
        .orange.opacity(0.2),
        .white.opacity(0.1)
    ] + Array(repeating: Color("MainColor").opacity(0.1), count: 4)
                   + Array(repeating: Color.clear, count: 2)
                   , startPoint: .top, endPoint: .bottom)
}

struct LineGraph_Previews: PreviewProvider {
    static var previews: some View {
        LineGraph(data: [], parameters: [PersistenceController.testParameter], parameterType: PersistenceController.testParameterType)
    }
}
