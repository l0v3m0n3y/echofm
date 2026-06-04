# echofm
api for echofm.online Здесь все, как на старом добром «Эхе»: ваши любимые ведущие и программы.

<code>Written during a study of the website echofm.online in collaboration with deepseek ai</code>

# main
```swift
import Foundation
import echofm
let echo = EchoFM()

do {
    let views = try await echo.get_views(post_id: 469191)
    print(views)
} catch {
    print("Error: \(error)")
}
```

# Launch (your script)
```
swift run
```
