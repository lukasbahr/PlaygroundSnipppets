import PlaygroundSupport
import SwiftUI


struct ContenView: View {
    
    @ObservedObject var tm:TimerModel
    
    init(timerModel: TimerModel) {
        self.tm = timerModel
    }
    
    var body: some View {
        VStack {
            
            Text(self.tm.timerMode == .initial ?  "00:00" : "\(self.tm.itemRemainingTime)")
            Text(self.tm.timerMode == .initial ?  "Start Timer" : "\(self.tm.itemName)")
            Text("\(self.tm.itemRTPercentage)")
            
            HStack {
                
                Button(action: {
                    self.tm.backward()
                })
                {
                    Image(systemName: "backward.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    switch self.tm.timerMode {
                    case .initial:
                        self.tm.setTimer()
                        self.tm.start()
                    case .running:
                        self.tm.pause()
                    case .paused:
                        self.tm.start()
                    }
                })
                {
                    Image(systemName: tm.timerMode == .running ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    self.tm.reset()
                })
                {
                    Image(systemName: "stop")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    self.tm.forward()
                })
                {
                    Image(systemName: "forward.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.red)
                }
                
                
            }
        }
    }
}


enum ItemType {
      case timer
      case audio
  }

struct Item {
    let id = UUID()
    let type: ItemType
    var name:String
    
    var seconds:Int?
    var minutes:Int?
    
    
    init(type: ItemType, name: String) {
        self.name = name
        self.type = type
    }
    
    mutating func setTime(type: ItemType, seconds: Int, minutes: Int) {
        if type == .timer {
            self.seconds = seconds
            self.minutes = minutes
        }
    }
    
}
    


enum TimerMode {
    case running
    case paused
    case initial
}

class TimerModel: ObservableObject {
    
    @Published var itemRemainingTime: String = ""
    @Published var itemName: String = ""
    @Published var itemRTPercentage: Float = 0.0
    
    @Published var timerMode: TimerMode = .initial
    var secondsLeft = UserDefaults.standard.integer(forKey: "timerLength")
    
    var itemArray : [Item]
    
    var totalTime: Int = 0
    var idx: Int = 0
    var timer:Timer = Timer()
    
    init(timerItemArray: [Item]) {
        self.itemArray = timerItemArray
    }
    
    // MARK - Update user interface
    func setItemName(name: String) {
        self.itemName = name
    }
    
    func setItemRT(){
        self.itemRemainingTime = String(format: "%02d:%02d", Int(self.secondsLeft/60), self.secondsLeft%60)
        self.itemRTPercentage = 1.0  -  Float(self.secondsLeft)/Float(self.totalTime)
    }
    
    // MARK - Timer logic
    func selectNextItem() {
        if self.itemArray[idx].type == .timer {
            setTimer()
            start()
        } else if self.itemArray[idx].type == .audio {
            playAudio()
        }
    }
    
    func setTimerLength(minutes: Int, seconds: Int) {
        self.totalTime = minutes * 60 + seconds
        let defaults = UserDefaults.standard
        defaults.set(self.totalTime, forKey: "timerLength")
        self.secondsLeft = self.totalTime
    }
    
    func setTimer(){
        setItemName(name: itemArray[idx].name)
        setTimerLength(minutes: itemArray[idx].minutes!, seconds: itemArray[idx].seconds!)
        setItemRT()
    }
    
    func start() {
        self.timerMode = .running
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    func reset() {
        self.timerMode = .initial
        self.idx = 0
        self.secondsLeft = UserDefaults.standard.integer(forKey: "timerLength")
        self.timer.invalidate()
        setTimer()
    }
    
    func pause() {
        self.timerMode = .paused
        self.timer.invalidate()
    }
    
    func backward(){
        if self.idx > 0 {
            self.timer.invalidate()
            self.idx -= 1
            selectNextItem()
        }
    }
    
    func forward() {
        if self.idx < self.itemArray.count - 1 {
            self.timer.invalidate()
            self.idx += 1
            selectNextItem()
        }
    }
    
    @objc func update() {
        if self.secondsLeft == 0 {
            if self.idx < self.itemArray.count-1 {
                self.timer.invalidate()
                forward()
            } else {
                self.reset()
                print("reset")
            }
        } else {
            self.secondsLeft -= 1
            setItemRT()
        }
    }
    
    func playAudio() {
        print("Audio")
        self.idx += 1
        selectNextItem()
    }
}

let timerItem1 = Item(type: .timer, name: "Workout")
let timerItem2 = Item(type: .timer, name: "Stretching")
let audioItem1 = Item(type: .audio, name: "Pause")

let timerItemArray = [timerItem1, timerItem2, audioItem1]
var tm = TimerModel(timerItemArray: timerItemArray)


let viewController = UIHostingController(rootView: ContenView(timerModel: tm).previewDevice("iPhone 11"))

PlaygroundPage.current.liveView = viewController
