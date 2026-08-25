import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.unknown))
                }
            }
            task.resume()
        }
    }
}

// https://echofm.online/_next/static/chunks/pages/_app-329ea4035f85b3ff.js


public class EchoFM {
    private let api = "https://echofm.online/api/graphql"
    private var headers: [String: String]
    
    public init() {
        self.headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Accept-Language": "en-US,en;q=0.9",
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:151.0) Gecko/20100101 Firefox/151.0"
        ]
    }
    
    private func buildRequest(query: String, variables: [String: Any] = [:]) throws -> URLRequest {
        guard let url = URL(string: api) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        let body: [String: Any] = [
            "query": query,
            "variables": variables
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        return request
    }

    public func getViews(postId: Int) async throws -> Any {
        let variables: [String: Any] = [
            "post": [
                "postId": String(postId),
                "postType": "post"
            ]
        ]
        let request = try buildRequest(
            query: "832b30a524f02754190102b0a90ae05bbaf0ae4d340a5b31e54b0ade5e7bedd3",
            variables: variables
        )
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func getEditorChoice() async throws -> Any {
        let request = try buildRequest(
            query: "83435c3812c8c0a810d5b9d31bdc50366f8a20ed569123719fb144f968b1fdc3"
        )
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func getPostByUri(uri: String) async throws -> Any {
        let variables: [String: Any] = ["uri": uri]
        let request = try buildRequest(
            query: "0632566827b2e1f354869e93daaa329b1369015327286ecbbc0fc16564c4fd26",
            variables: variables
        )
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }

    public func search(query: String, first: Int = 20) async throws -> Any {
        let variables: [String: Any] = [
            "search": query,
            "first": first
        ]
        let request = try buildRequest(
            query: "95b190a761701f1472e419d3119f69093cc42d31288f53f5fede02ef16e3ef66",
            variables: variables
        )
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    

    public func getLikes() async throws -> Any {
        let request = try buildRequest(
            query: "91d3e12597628a123afb3ebee0ed8941cc3a44822b8b6294080f19866cdcf9c4"
        )
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }

    public func getEventsData() async throws -> Any {
        let request = try buildRequest(
            query: "46c23f565487f06087144aa68ec8ae10aef402c7527c02db8d582e2b460930bb"
        )
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func getNewsWidget() async throws -> Any {
        let request = try buildRequest(
            query: "6b33dab2efc3e57dfc8567a2a853647027a50f637d036edaa81e66b102dcea6c"
        )
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func getAuthors() async throws -> Any {
        let request = try buildRequest(
            query: "48401398dda8f5541df4f1b62eb6fe9aa1ee283c3899e71c9911cf538d50b13b"
        )
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func getPageByUri(uri: String) async throws -> Any {
        let variables: [String: Any] = ["uri": uri]
        let request = try buildRequest(
            query: "15b8a36d497c0437876e8809c7fbea7257bdb24808e5e1d96356b32cf74953a7",
            variables: variables
        )
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }

    public func getPrograms() async throws -> Any {
        let request = try build_request(
            query: "79d2a2fe3d2a746d493c618d5c72c5081bc9ae91194c75eb906e497351713054"
        )
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
}
