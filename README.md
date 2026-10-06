# HTTP Utilities

A lightweight Swift package providing reusable building blocks for HTTP requests.

Includes request builders, headers, query parameters, JSON and form encoding, and multipart bodies. Requests are built as standard Foundation `URLRequest` values, ready to use with your preferred network client.

## Requirements

- Swift 6.2 or later
- iOS 13 or later, or macOS 10.15 or later

## Installation

Add the package to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(
        url: "https://github.com/indice-co/Indice.HTTP.Swift",
        .upToNextMajor(from: "1.0.0")
    )
]
```

Then add the `NetworkUtilities` product to the target that needs it:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(
            name: "NetworkUtilities",
            package: "Indice.HTTP.Swift"
        )
    ]
)
```

This version requirement accepts releases from `1.0.0` up to, but excluding, `2.0.0`.

## Usage

Import Foundation and the package module:

```swift
import Foundation
import NetworkUtilities
```

### GET request with query parameters

```swift
let request = URLRequest
    .get(url: URL(string: "https://api.example.com/items")!)
    .add(query: "search", value: "books")
    .add(query: "page", value: "1")
    .set(header: .accept(type: .json))
    .build()
```

Add query parameters before headers when chaining builder methods.

### JSON request

```swift
struct CreateItem: Encodable {
    let name: String
    let quantity: Int
}

let request = try URLRequest
    .post(url: URL(string: "https://api.example.com/items")!)
    .bodyJson(of: CreateItem(name: "Notebook", quantity: 2))
    .set(header: .authorization(auth: "Bearer YOUR_ACCESS_TOKEN"))
    .build()
```

The JSON body builder sets the `Content-Type` header automatically.

### Form request

```swift
let request = try URLRequest
    .post(url: URL(string: "https://api.example.com/forms")!)
    .bodyFormUTF8(params: [
        "name": "Alex",
        "message": "Hello!"
    ])
    .build()
```

The form body builder encodes the parameters and sets the appropriate `Content-Type` header.

### Multipart upload

```swift
let fileURL = URL(fileURLWithPath: "/path/to/photo.jpg")

let request = try URLRequest
    .post(url: URL(string: "https://api.example.com/uploads")!)
    .bodyMultipart { multipart in
        _ = multipart.add(key: "description", value: "Profile photo")
        _ = try multipart.add(key: "file", file: fileURL)
    }
    .build()
```

The multipart builder creates the boundary and content header automatically. The file helper uses the local filename and infers its MIME type.

### Update an existing request

```swift
var request = URLRequest(
    url: URL(string: "https://api.example.com/items")!
)

request.method = .get
request.set(header: .accept(type: .json))
request.set(header: .custom(name: "X-Request-ID", value: UUID().uuidString))
```

Use `set(header:)` to replace a header value and `add(header:)` to append a value.

### Client-independent protocols

The package also provides shared interfaces for packages that need networking without depending on a specific client implementation:

- `RequestProcessor` — asynchronous HTTP requests with optional `Decodable` response decoding.
- `StreamProcessor` — asynchronous Server-Sent Events (SSE) streams with typed payloads.

Both protocols expose HTTP response metadata and allow consumers to use any conforming networking client or test double.
