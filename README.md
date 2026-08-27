# echofm
api for echofm.online Здесь все, как на старом добром «Эхе»: ваши любимые ведущие и программы.

# main
```swift
import Foundation
import echofm

@preconcurrency
func fetchViews() async throws {
    let echo = EchoFM()
    let views = try await echo.getViews(postId: 469191)
    print(views)
}

do {
    try await fetchViews()
} catch {
    print("Error: \(error)")
}
```

# Launch (your script)
```
swift run
```
