//
//  Home.swift
//  UI-541
//
//  Created by nyannyan0328 on 2022/04/14.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home: View {
    @State var currentTab : String = "A"
    @Namespace var animation
    @StateObject var model = AppViewModel()
    var body: some View {
        VStack{
            
            if let coins = model.coins,let coin = model.currentCoin{
                HStack{
                    
                    AnimatedImage(url: URL(string: coin.image))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                    
                    VStack(alignment: .leading, spacing: 13) {
                        
                        Text(coin.symbol)
                            .font(.callout)
                        
                        Text(coin.last_updated)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .lLeading()
              
                
                
                CustomControl(coins:coins)
                
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    
                    Text(coin.current_price.convertedToCurrency())
                        .font(.largeTitle)
                    
                    Text("\(coin.price_change > 0 ? "+" : "")\(String(format: "%.2f", coin.price_change))")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(coin.price_change < 0 ? .white : .black)
                        .padding(.horizontal,20)
                        .padding(.vertical,5)
                        .background{
                            
                            Capsule()
                                .fill(coin.price_change < 0 ? .red : Color("LightGreen"))
                            
                        }
                        
                    
                }
                .lLeading()
                
                Graph(coin: coin)
                
                Controller()
                
            }
            else{
                
                ProgressView()
                    .tint(Color("LightGreen"))
            }
             
        }
        .padding()
        .maxTop()
      
    }
    @ViewBuilder
    func Graph(coin : CryptonModel)->some View{
        
        GeometryReader{_ in
            
            
            LinGraph(data: coin.last_7days_price.price,proFit: coin.price_change > 0)
            
        }
    }
    @ViewBuilder
    func CustomControl(coins : [CryptonModel])->some View{
        
    
        
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack(spacing:13){
                
                ForEach(coins){coin in
                    
                    Text(coin.symbol.uppercased())
                        .font(.title3.weight(.thin))
                        .foregroundColor(currentTab == coin.symbol.uppercased() ? .white : .gray)
                        .padding(.vertical,9)
                        .padding(.horizontal,15)
                        .contentShape(Rectangle())
                        .background{
                            
                            if currentTab == coin.symbol.uppercased(){
                                
                                Rectangle()
                                    .fill(Color("Tab"))
                                    .matchedGeometryEffect(id: "CUSTOMSEGNMENT", in: animation)
                                
                            }
                        }
                      
                        .onTapGesture {
                            
                            
                            withAnimation{
                                model.currentCoin = coin
                                currentTab = coin.symbol.uppercased()
                            }
                        }
                    
                    
                }
                
                
            }
        }
        .background(
        
            RoundedRectangle(cornerRadius: 5,style: .continuous)
                .stroke(.white.opacity(0.3),lineWidth:1)
        
        )
        .padding(.vertical)
        
        
    }
    
    @ViewBuilder
    func Controller()->some View{
        
        
        HStack(spacing:18){
            
            Button {
                
            } label: {
                
                Text("Sell")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.black)
                    .padding(.vertical,15)
                    .padding(.horizontal,20)
                    .lCenter()
                    .background(
                    
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                    
                    )
            }
            
            Button {
                
            } label: {
                
                Text("BUY")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.black)
                    .padding(.vertical,15)
                    .padding(.horizontal,20)
                    .lCenter()
                    .background(
                    
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color("LightGreen"))
                    
                    )
            }

        }
        
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View{
    
    func getRect()->CGRect{
        
        
        return UIScreen.main.bounds
    }
    
    func lLeading()->some View{
        
        self
            .frame(maxWidth:.infinity,alignment: .leading)
    }
    func lTreading()->some View{
        
        self
            .frame(maxWidth:.infinity,alignment: .trailing)
    }
    func lCenter()->some View{
        
        self
            .frame(maxWidth:.infinity,alignment: .center)
    }
    
    func maxHW()->some View{
        
        self
            .frame(maxWidth:.infinity,maxHeight: .infinity)
        
    
    }

 func maxTop() -> some View{
        
        
        self
            .frame(maxWidth:.infinity,maxHeight: .infinity,alignment: .top)
            
    }
    
}

extension Double{
    
    func convertedToCurrency()->String{
        
        let fotmatter = NumberFormatter()
        fotmatter.numberStyle = .currency
        
        return fotmatter.string(from: .init(value: self)) ?? ""
    }
}
