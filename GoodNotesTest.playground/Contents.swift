func getRejectedRequests(requests: [String], limitPerSecond: Int) -> [Int] {
    var rejectedRequests = [Int]()
    var requestCounts = [String: Int]()
    var lastTimestamps = [String: Int]()

    for request in requests {
        let components = request.split(separator: " ")
        let requestId = Int(components[0])!
        let ipAddress = String(components[1])
        let timestamp = Int(components[2])!

        if requestCounts[ipAddress] == nil {
            requestCounts[ipAddress] = 0
        }
        if lastTimestamps[ipAddress] == nil {
            lastTimestamps[ipAddress] = 0
        }

        if timestamp - lastTimestamps[ipAddress]! >= 1000 {
            // The time window has elapsed, reset the request count.
            requestCounts[ipAddress] = 0
            lastTimestamps[ipAddress] = timestamp
        }

        if requestCounts[ipAddress]! < limitPerSecond {
            // The request is accepted.
            requestCounts[ipAddress]! += 1
        } else {
            // The request is rejected.
            rejectedRequests.append(requestId)
        }
    }

    return rejectedRequests
}
