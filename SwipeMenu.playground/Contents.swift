import SwiftUI
import PlaygroundSupport
import UIKit


struct Menu: View {
    
    var body:some View{
        
        ZStack {
            Color.orange
                .opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Menu")
                    .foregroundColor(Color.white)
            }
        }
    }
    
}

struct PrevView: View {
    
    var body:some View{
        ZStack {
            Color.red
                .opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Content")
                    .foregroundColor(Color.white)
            }
        }
    }
    
}



struct ContentView : View {
    
    @State var offset: CGSize = CGSize.zero
    @State var isMenuActive: Bool = false
    
    let screenWidth = UIScreen.main.bounds.width
        
    let menuWidth: CGFloat = 250.0
    let dragContentWidth: CGFloat = 170.0
    let dragMenuWidth: CGFloat = 60.0
    let minOffsetWidth: CGFloat = 0.0
    
    var body : some View{
        GeometryReader {geo in
            ZStack{
                
                Menu()
                    .offset(x:-geo.size.width+self.offset.width)
                PrevView()
                    .offset(x: self.offset.width)
                    .opacity(1.8 - Double(self.offset.width) / 280.0)
                
            }
            .transition(.slide)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        
                        if Float(gesture.translation.width) > 0.0 && self.isMenuActive == false {
                            self.offset = gesture.translation
                            
                            // if isMenuActive true only set offset width is smaller than menu width - screen width
                        } else if gesture.translation.width < self.menuWidth - geo.size.width && self.isMenuActive == true {
                            self.offset.width = geo.size.width + gesture.translation.width
                        }
                        
                }
                .onEnded { _ in
                    
                    // check isMenuActive
                    if !self.isMenuActive {
                        
                        // if menu is not active we are in content view
                        // so next we check if we swiped far enough to show the menu
                        // set isMenuActive to true and the offset width to the menuWidth
                        if self.offset.width > self.dragContentWidth {
                            self.isMenuActive = true
                            self.offset.width = self.menuWidth
                            
                        } else if self.offset.width < self.dragContentWidth  {
                            self.offset.width = self.minOffsetWidth
                        
                        }
                        
                        
                    } else if self.isMenuActive {
                        
                        // if menu is active we are in menu view
                        // so next we check if we swiped far enough to close the menu
                        // because offset width is set to menu width we need to compare subract our desired dragMenuWidth from the menuWidth before comparing
                        // set isMenuActive to false and the offset width to the minOffsetWidth = 0
                        if self.offset.width < self.menuWidth - self.dragMenuWidth  {
                            self.offset.width = self.minOffsetWidth
                            self.isMenuActive = false
                            
                        } else if self.offset.width > self.menuWidth - self.dragMenuWidth  {
                            self.offset.width = self.menuWidth
                        }
                        
                    }
                    
                        
                
                }
                
            )
        }
        
       
    }
}

let viewController = UIHostingController(rootView: ContentView().previewDevice(PreviewDevice(rawValue: "iPhone 11")))

//let viewController = UIHostingController(rootView: ContentView().environmentObject(SwipeObserver()))

PlaygroundPage.current.liveView = viewController

