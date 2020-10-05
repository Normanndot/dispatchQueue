import UIKit

var str = "Hello, playground"

/*Examples of Dead Lock*/
let queue = DispatchQueue(label: "label")
queue.async {
    queue.sync {
        // outer block is waiting for this inner block to complete,
        // inner block won't start before outer block finishes
        // => deadlock
    }
    // this will never be reached
}














//If anyone is curious, a concurrent queue does NOT deadlock if sync is called targeting the same queue. I know it's obvious but I needed to confirm only serial queues behave that way 😅
let q = DispatchQueue(label: "myQueue", attributes: .concurrent)

q.async {
    print("work async start")
    q.sync {
        print("work sync in async")
    }
    print("work async end")
}

q.sync {
    print("work sync")
}

print("done")

//Fails:

//Initialize q as let q = DispatchQueue(label: "myQueue") // implicitly serial queue











let aSerialQueue = DispatchQueue(label: "my.label")

aSerialQueue.sync {
    // The code inside this closure will be executed synchronously.
    aSerialQueue.sync {
        // The code inside this closure should also be executed synchronously and on the same queue that is still executing the outer closure ==> It will keep waiting for it to finish ==> it will never be executed ==> Deadlock.
    }
}












