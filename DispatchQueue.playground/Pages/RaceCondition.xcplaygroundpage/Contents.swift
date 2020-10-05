//: [Previous](@previous)

import Foundation
import UIKit

var str = "Hello, playground"

//: [Next](@next)

/*
 
 I recently had to debug an issue in a code written in Swift, a variable whose value is unexpectedly changing by different threads, and as someone who has been in a similar situation before, but back then it was an Objective-C code, I used to follow the traditional approach to solve these kinds of problems, using locks to synchronize access to this shared resource. In Objective-C I used @synchronized directive to accomplish that task. So I started searching how to write @synchronized in Swift, but I couldn’t find it.
 There is still a way to create mutex locks without @synchronized in swift but while I was getting a little bit deeper into that topic, I found other approaches to handle these type of issues even without using locks at all. In this article we will explore some these approaches but let’s first have a quick refresher about concurrency.
 
 
 
 Concurrency 101
 Concurrency means running more than one task at the same time. It is a major topic that you will find almost everywhere in modern software programming. As everything else in software, the concept of concurrency appears at different levels of abstractions, you can find it in distributed-computing architectures, database systems, CPU architectures, low-level and high-level software programs. Each of these abstractions has different challenges and different approaches for solving them but across all of these abstractions there is always one common challenge, managing access to shared resources. In the rest of this article we will be addressing Concurrency from high-level programming perspective.
 once you encounter a shared resource in a concurrent software, you have to be careful while accessing this resource especially if you are writing to it.
 At the heart of concurrency lies the concept of threads, think of a thread as a path of execution, so in order for concurrency to be possible, we need to be able to execute multiple threads at the same time. For instance, in the same program (Process) there may be a thread for playing audio, another thread for accepting user input, and a thread for downloading a file from a remote server. All this threads needs to execute in the same time seamlessly without any conflict.
 Multi-Threading concurrency is possible even on hardware that is limited to a single-core processor, using techniques like time-slicing which keeps all running tasks in a tasks pool and give each one of them a specific amount of time to execute then switch to the next task even if the first one is still not finished, giving the illusion that these tasks are running simultaneously.
 Sounds great!! let’s start creating a new thread for every concurrent task we need to execute. Unfortunately writing concurrent code is not that straight forward, but the good news is, if you used the right tools for the job, things will not be quite hard also.
 Example: Building our own ATM
 Imagine we had established our own bank — our bank had only one branch as a start. One day one of the founders came with this brilliant idea of deploying an ATM machine in our bank’s single branch. Our ATM works with the following sequence:
 First we need to check if the current balance has sufficient amount of money for the withdrawal.
 If the balance is sufficient, start the withdrawal process, The withdrawal process needs to connect to our bank’s servers to do some validations, a process that normally takes up to two seconds to finish.
 After the validation process is completed, we will deduce the amount of withdrawn money from the deisgnated balance.
 
 */
var balance = 1200

struct ATM {
    let tag: String
    func withdraw(value: Int) {
        print("\(self.tag): checking if balance containing sufficent money")
        if balance > value {
            print("\(self.tag): Balance is sufficent, please wait while processing withdrawal")
            // sleeping for some random time, simulating a long process
            Thread.sleep(forTimeInterval: Double.random(in: 0...2))
            balance -= value
            print("\(self.tag): Done: \(value) has been withdrawed")
            print("\(self.tag): current balance is \(balance)")
        } else {
            print("\(self.tag): Can't withdraw: insufficent balance")
        }
    }
}


/*
 
 Everything is going as expected, our customers are happy and our bank had a massive breakthrough. Our ATM was handling more than 100 transactions per day without any issue so in order to be able to process more transactions in less time, we added another ATM. Everything went well for the first few days, until our accountant found something strange. A customer was able to withdraw an amount of money more than his total balance!!
 After reviewing the logs we were be able to find the exact scenario of how this happened, The two ATMs withdrawn from the balance at the same exact time.
 Let’s simulate the two ATMs in code to be able to understand more about how this issue did happen. Don’t worry about syntax for now, we will explain how queues work later. Just know that these two ATMs are working independently in parallel and started the withdrawal process almost at the same time.
 
 */



let queue = DispatchQueue(label: "WithdrawalQueue", attributes: .concurrent)

queue.async {
    let firstATM = ATM(tag: "firstATM")
    firstATM.withdraw(value: 1000)
}

queue.async {
    let secondATM = ATM(tag: "secondATM")
    secondATM.withdraw(value: 800)
}

/*
 firstATM: checking if balance containing sufficent money
 secondATM: checking if balance containing sufficent money
 firstATM: Balance is sufficent, please wait while processing withdrawal
 secondATM: Balance is sufficent, please wait while processing withdrawal
 firstATM: Done: 1000 has been withdrawed
 firstATM: current balance is 200
 secondATM: Done: 800 has been withdrawed
 secondATM: current balance is -600
 */

let image = UIImageView(image: UIImage(named: "rc"))


//Continued in https://medium.com/swiftcairo/avoiding-race-conditions-in-swift-9ccef0ec0b26
