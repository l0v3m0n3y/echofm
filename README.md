# echofm
api for echofm.online Здесь все, как на старом добром «Эхе»: ваши любимые ведущие и программы.

# main
```swift
import Foundation
import echofm
let echo = EchoFM()

do {
    let views = try await echo.getViews(postId: 469191)
    print(views)
} catch {
    print("Error: \(error)")
}
```

# Launch (your script)
```
swift run
```
