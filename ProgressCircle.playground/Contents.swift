//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import SwiftUI

struct CircleButtonStyling: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .frame(width:60, height: 60)
            .opacity(0.3)
            .foregroundColor(Color.red)
            .overlay(
                  Circle()
                      .stroke(Color.red, lineWidth: 2)
              )
    }
}

struct ImageButtonStyling: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding()
            .font(.headline)
            .foregroundColor(.white)
    }
}


struct ContenView: View {
    @State var progressValue: Float = 0.0
    
    var body: some View{
        ZStack {
            Color.black
                .opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                VStack {
                    ProgressBar(progress: self.$progressValue)
                        .frame(width: 250.0, height: 250.0)
                        .padding(40.0)
                    
                }
                
                HStack{
                    
                    Button(action: {print("Preview")})
                    {
                        ZStack{
                            Circle()
                                .modifier(CircleButtonStyling())
                            Image(systemName: "backward")
                                .modifier(ImageButtonStyling())
                        }

                        
                    }
                    .padding(.leading,30)
                    
                    Spacer()
                    
                    Button(action: {print("Preview")})
                    {
                        ZStack{
                            Circle()
                               .modifier(CircleButtonStyling())
                            Image(systemName: "stop")
                                .modifier(ImageButtonStyling())
                        }
                                                
                    }
                    .padding(.leading,20)
                    
                    Spacer()
                    
                    Button(action: {self.progressValue+=0.1})
                    {
                        ZStack{
                            Circle()
                                .modifier(CircleButtonStyling())
                            Image(systemName: "play")
                                .modifier(ImageButtonStyling())
                        }
                                                
                    }
                    .padding(.leading,20)
                    
                    Spacer()
                    
                    Button(action: {print("Preview")})
                    {
                        ZStack{
                            Circle()
                                .modifier(CircleButtonStyling())
                            Image(systemName: "forward")
                                .modifier(ImageButtonStyling())
                        }

                        
                    }
                    .padding(.leading,20)
                    .padding(.trailing,30)
                    
                    Spacer()
                    
                    
                }
                .padding(.bottom, 30)
                
                HStack{
                Text("Upcoming items:")
                    .foregroundColor(Color.white.opacity(0.4))
                    .padding(.leading, 30)
                    .font(.body)
                Spacer()
            }
                
                ScrollView(.vertical) {
                    VStack(spacing: 15) {
                        ForEach(0..<10) {
                            Text("Item \($0)")
                                .foregroundColor(.white)
                                .font(.headline)
                                .frame(width: 330, height: 30)
                                .background(Color.red.opacity(0.5))
                                .cornerRadius(5.0)
                        }
                    }
                }
                .padding(.bottom, 30)
                
                Spacer()
            }
        }
        
    }
    
}

struct ProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 18.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 18.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.red)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            VStack{
                Text("Name")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(self.progress, specifier: "%.2f")")
                    .font(.largeTitle)
                .foregroundColor(.white)
            }
            
        }
    }
}

let viewController = UIHostingController(rootView: ContenView().previewDevice("iPhone 11"))

PlaygroundPage.current.liveView = viewController


