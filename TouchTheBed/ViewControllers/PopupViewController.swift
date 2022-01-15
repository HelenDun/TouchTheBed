//
//  PopUpViewController.swift
//  TouchTheBed
//
//  Created by Helen Dun on 11/18/21.
//

import Cocoa
import AVFoundation

class PopupViewController: NSViewController {
    
    @IBOutlet weak var currentTimeText: NSTextField!
    @IBOutlet var snoozeCounterText: NSTextField!
    @IBOutlet weak var quoteText: NSTextField!
    @IBOutlet weak var authorText: NSTextField!
    
    var soundPlayer: AVAudioPlayer?
    var soundTimer: Timer? = nil
    let quotes: [[String]] = [
        ["I love sleep. My life has the tendency to fall apart when I'm awake, you know?", "Ernest Hemingway"],
        ["Each night, when I go to sleep, I die. And the next morning, when I wake up, I am reborn.", "Mahatma Gandhi"],
        ["There is a time for many words, and there is also a time for sleep.", "Homer, The Odyssey"],
        ["I’ve dreamed a lot. I’m tired now from dreaming but not tired of dreaming. No one tires of dreaming, because to dream is to forget, and forgetting does not weigh on us, it is a dreamless sleep throughout which we remain awake. In dreams I have achieved everything.", "Fernando Pessoa, The Book of Disquiet"],
        ["Even a soul submerged in sleep is hard at work and helps make something of the world.", "Heraclitus, Fragments"],
        ["It's amazing how a little tomorrow can make up for a whole lot of yesterday.", "John Guare, Landscape of the Body"],
        ["The future depends on what you do today.", "Mahatma Gandhi"],
        ["Unfortunately, the clock is ticking, the hours are going by. The past increases, the future recedes. Possibilities decreasing, regrets mounting.", "Haruki Murakami, Dance Dance Dance"],
        ["No one saves us but ourselves. No one can and no one may. We ourselves must walk the path.", "Gautama Buddha, Sayings Of Buddha"],
        ["Education is our passport to the future, for tomorrow belongs to the people who prepare for it today.", "Malcolm X"],
        ["The future is there... looking back at us. Trying to make sense of the fiction we will have become.", "William Gibson, Pattern Recognition"],
        ["You spend your whole life stuck in the labyrinth, thinking about how you'll escape one day, and how awesome it will be, and imagining that future keeps you going, but you never do it. You just use the future to escape the present.", "John Green, Looking for Alaska"],
        ["Never let the future disturb you. You will meet it, if you have to, with the same weapons of reason which today arm you against the present.", "Marcus Aurelius, Meditations"],
        ["It is by no means an irrational fancy that, in a future existence, we shall look upon what we think our present existence, as a dream.", "Edgar Allan Poe"],
        ["Optimism is a strategy for making a better future. Because unless you believe that the future can be better, you are unlikely to step up and take responsibility for making it so.", "Noam Chomsky"],
        ["The best way to predict your future is to create it.", "Abraham Lincoln"],
        ["Walk with the dreamers, the believers, the courageous, the cheerful, the planners, the doers, the successful people with their heads in the clouds and their feet on the ground. Let their spirit ignite a fire within you to leave this world better than when you found it...", "Wilferd Peterson"],
        ["The present is theirs; the future, for which I really worked, is mine.", "Nikola Tesla"],
        ["The future starts today, not tomorrow.", "Pope John Paul II"],
        ["When you make a choice, you change the future.", "Deepak Chopra"],
        ["The future you have, tomorrow, won't be the same future you had, yesterday.", "Chuck Palahniuk, Rant"],
        ["But you can build a future out of anything. A scrap, a flicker. The desire to go forward, slowly, one foot at a time. You can build an airy city out of ruins.", "Lauren Oliver, Pandemonium"],
        ["When people talk, listen completely. Most people never listen.", "Ernest Hemingway"],
        ["Self-absorption in all its forms kills empathy, let alone compassion. When we focus on ourselves, our world contracts as our problems and preoccupations loom large. But when we focus on others, our world expands. Our own problems drift to the periphery of the mind and so seem smaller, and we increase our capacity for connection - or compassionate action.", "Daniel Goleman, Social Intelligence: The New Science of Human Relationships"],
        ["Empathy isn't just something that happens to us - a meteor shower of synapses firing across the brain - it's also a choice we make: to pay attention, to extend ourselves. It's made of exertion, that dowdier cousin of impulse. Sometimes we care for another because we know we should, or because it's asked for, but this doesn't make our caring hollow. This confession of effort chafes against the notion that empathy should always rise unbidden, that genuine means the same thing as unwilled, that intentionality is the enemy of love. But I believe in intention and I believe in work. I believe in waking up in the middle of the night and packing our bags and leaving our worst selves for our better ones.","Leslie Jamison, The Empathy Exams"],
        ["To be with another in this [empathic] way means that for the time being, you lay aside your own views and values in order to enter another's world without prejudice. In some sense it means that you lay aside your self; this can only be done by persons who are secure enough in themselves that they know they will not get lost in what may turn out to be the strange or bizarre world of the other, and that they can comfortably return to their own world when they wish.\nPerhaps this description makes clear that being empathic is a complex, demanding, and strong - yet subtle and gentle - way of being.","Carl R. Rogers, A Way of Being"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let audioFileUrl = Bundle.main.url(forResource: "foghorn", withExtension: "mp3") else { return }

        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
            soundPlayer?.prepareToPlay()
        }
        catch {
            print("Sound player not available: \(error)")
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        // Play sound over and over
        if let sp = soundPlayer {
            soundTimer = Timer.scheduledTimer(withTimeInterval: sp.duration, repeats: true) { timer in
                sp.stop()
                sp.play(atTime: 0)
            }
            sp.play(atTime: 0)
        }
        
        // Display a random quote
        let rand = Int.random(in: 0..<quotes.count)
        quoteText.stringValue = quotes[rand][0]
        authorText.stringValue = quotes[rand][1]
        
        // Set the time to the current time
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        if let currHour = components.hour, let currMin = components.minute {
            currentTimeText.stringValue = stringifyTime(value: currHour) + ":" + stringifyTime(value: currMin)
        }
        
        // Count how many times the window has loaded
        snoozeCounterText.integerValue = snoozeCounterText.integerValue + 1
    }
    
    override func viewDidDisappear()
    {
        super.viewDidDisappear()
        
        soundPlayer?.stop()
        soundTimer?.invalidate()
        soundTimer = nil
    }
    
    func stringifyTime(value: Int) -> String {
        var strvalue = String(value)
        if value < 10
        {
            strvalue = "0" +  strvalue
        }
        return strvalue
    }
    
    func resetSnoozeCounter() {
        self.snoozeCounterText.integerValue = 0
    }
    
    @IBAction func closeButtonClicked(_ sender: Any)
    {
        view.window?.close()
    }
}
