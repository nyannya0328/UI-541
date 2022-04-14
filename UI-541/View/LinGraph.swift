//
//  LinGraph.swift
//  UI-540
//
//  Created by nyannyan0328 on 2022/04/14.
//

import SwiftUI

struct LinGraph: View {
    let data : [Double]
    @GestureState var isDragging : Bool = false
    @State var currentPlot : String = ""
    @State var offset : CGSize = .zero
    @State var showPlot : Bool = false
    @State var traslation : CGFloat = 0
    
    @State var proFit : Bool = false
    
    @State var progress : CGFloat = 0
    var body: some View {
        GeometryReader{proxy in
            
            let height = proxy.size.height
            let width = (proxy.size.width) / CGFloat(data.count - 1)
            
            let maxPoint = (data.max() ?? 0)
            let minPoint = (data.min() ?? 0)
            
            
            let points = data.enumerated().compactMap { item -> CGPoint in
                
                let progress = (item.element - minPoint) / (maxPoint - minPoint)
                
                let pathHeight = progress * (height - 50)
                
                let pathWidth = width * CGFloat( item.offset)
                
                return CGPoint(x: pathWidth, y: -pathHeight + height)
            }
            
            ZStack{
                
            AnimatedPath(progress: progress, points: points)
                
                .fill(
                
                    
                        LinearGradient(colors: [
                        
                        
                            
                                proFit ? Color("Profit") : Color("Loss"),
                                proFit ? Color("Profit") : Color("Loss")
                        
                        ], startPoint: .leading, endPoint: .trailing)
                
                
                )
                
                
                FillBG()
                    .clipShape(
                        
                        Path{path in
                            
                            path.move(to: CGPoint(x: 0, y: 0))
                            
                            path.addLines(points)
                            
                            path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                            path.addLine(to: CGPoint(x: 0, y: height))
                            
                            
                            
                            
                        }
                    
                    
                    )
            }
          
            .overlay(alignment: .bottomLeading, content: {
                
                
                VStack(spacing:0){
                    
                    Text(currentPlot)
                        .font(.caption.weight(.thin))
                        .foregroundColor(.white)
                        .padding(.vertical,10)
                        .padding(.horizontal,13)
                        .background(
                        
                        
                        Capsule()
                            .fill(Color("Gradient1"))
                        )
                        .offset(x: traslation < 10 ? 30 : 0)
                        .offset(x: traslation > (proxy.size.width - 40) ? -30 : 0)
                    
                    
                    Rectangle()
                        .fill(Color("Gradient1"))
                        .frame(width: 1, height: 40)
                        .padding(.top)
                    
                    Circle()
                        .fill(Color("Gradient1"))
                        .frame(width: 25, height: 25)
                        .overlay(
                        
                        Circle()
                            .fill(.white)
                            .frame(width: 10, height: 10)
                        
                        )
                    
                    
                    Rectangle()
                        .fill(Color("Gradient1"))
                        .frame(width: 1, height: 50)
                      
                    
                    
                    
                    
                }
                .frame(width: 80, height: 170)
                .offset(y: 70)
                .offset(offset)
              .opacity(showPlot ? 1 : 0)
                
            })
            .contentShape(Rectangle())
            .gesture(
            
            
            
                DragGesture().updating($isDragging, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    
                    withAnimation{showPlot = true}
                    
                    let translation = value.location.x - 20
                    
                    let index = max(min(Int((translation / width).rounded() + 1), data.count - 1), 0)
                    
                    currentPlot = "$\(data[index])"
                    
                    self.traslation = translation
                    
                    offset = CGSize(width: points[index].x - 40, height: points[index].y -  height)
                })
                .onEnded({ value in
                    
                    withAnimation{showPlot = false}
                })
            
            )
            
            
            
        }
        .overlay(alignment: .leading, content: {
            VStack(spacing:20){
                
                let max = data.max() ?? 0
                let min = data.min() ?? 0
                
                Text(max.convertedToCurrency())
                    .font(.caption.weight(.bold))
                    .offset(x: -20)
                
                Spacer()
                
                
                VStack(alignment: .leading, spacing: 13) {
                    
                    
                    Text(min.convertedToCurrency())
                        .font(.caption)
                    
                    
                   Text("Last 7 Days")
                    
                
                }
                
            }
            .font(.title2.weight(.thin))
            
            
        })
        .onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                withAnimation(.easeInOut(duration: 1.2)){
                    
                    progress = 1
                }
            }
            
        }
        .onChange(of: data) { newValue in
            progress = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                withAnimation(.easeInOut(duration: 1.2)){
                    
                    progress = 1
                }
            }
            
            
        }
       
    }
    @ViewBuilder
    func FillBG()->some View{
        
        let color = proFit ? Color("Profit") : Color("Loss")

        
        
        LinearGradient(colors: [
            
            
            color.opacity(0.3),
            color.opacity(0.2),
            color.opacity(0.1),
            color.opacity(0.3),
        
        
        
        
        ] + Array(repeating: Color("Gradient1").opacity(0.1), count: 4) + Array(repeating: .clear.opacity(0.1), count: 2) , startPoint: .top, endPoint: .bottom)
        
        
    }
}

struct LinGraph_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct AnimatedPath : Shape{
    
    var progress : CGFloat
    var points : [CGPoint]
    
    var animatableData: CGFloat{
        
        get{return progress}
        set{progress = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        
        Path{path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            
            path.addLines(points)
            
            
            
            
        }
        .trimmedPath(from: 0, to: progress)
        .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
    
    }
}
