import SwiftUI
import PlaygroundSupport




struct ContentView : View {
    
    
    
    var body : some View{
        
        Text("Hallo")
    }
    
}

let viewController = UIHostingController(rootView: ContentView().previewDevice(PreviewDevice(rawValue: "iPhone 11")))

PlaygroundPage.current.liveView = viewController


