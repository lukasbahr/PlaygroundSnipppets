import UIKit
import SwiftUI

class countDown {
    
    func startCountDown(minutesToAdd: Int, secondsToAdd: Int) {
        
        let secondsToAdd = secondsToAdd
        let minutesToAdd = minutesToAdd

        let currentDate = Date()

        var dateComponent = DateComponents()
        
        dateComponent.second = secondsToAdd
        dateComponent.minute = minutesToAdd

        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        let timer2 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            // create date from init
            // break loop if current date is bigger than timer set
            
            
    
            
            var nowDate = Date()
//            let calendar = Calendar.current
//
//            let seconds = calendar.component(.second, from: nowDate)
            
            print(nowDate)
            
            if(nowDate>=futureDate!) {
                timer.invalidate()
            }

        }

        
    }
}

var test = countDown()
test.startCountDown(minutesToAdd: 2, secondsToAdd: 0)

