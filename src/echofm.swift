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

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}


public class EchoFM {
    private let api = "https://echofm.online/api/graphql"
    private let api2 = "https://echofm.online/_next/data"
    private var headers: [String: String]

    public var buildId: String

    public init(buildId: String = "JIAKzjirGOqyjt-B8L1BF") {
        self.buildId = buildId
        self.headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Accept-Language": "en-US,en;q=0.9",
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:151.0) Gecko/20100101 Firefox/151.0"
        ]
    }

    
    private func fetchJSON(from urlString: String,method: HTTPMethod = .get,body: Data? = nil,queryParameters: [String: String]? = nil) async throws -> Any {
        var urlComponents = URLComponents(string: urlString)
        if let queryParameters = queryParameters {
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents?.url else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    private func fetchPage(_ path: String, query: [String: String] = [:]) async throws -> Any {
        let url = "\(api2)/\(buildId)/ru\(path).json"
        return try await fetchJSON(from: url, queryParameters: query)
    }

    private func graphQL(hash: String, variables: [String: Any] = [:]) async throws -> Any {
        let body: [String: Any] = [
            "operationName": NSNull(),
            "variables": variables,
            "extensions": [
                "persistedQuery": [
                    "version": 1,
                    "sha256Hash": hash
                ]
            ]
        ]
        let bodyData = try JSONSerialization.data(withJSONObject: body)
        return try await fetchJSON(from: api, method: .post, body: bodyData)
    }

    public func getMainPage() async throws -> Any {
        try await fetchPage("")
    }

    public func getArchive() async throws -> Any {
        try await fetchPage("/archive")
    }

    public func getPrograms() async throws -> Any {
        try await fetchPage("/programs")
    }

    public func getAuthors() async throws -> Any {
        try await fetchPage("/author")
    }

    public func getCategory(_ category: String) async throws -> Any {
        try await fetchPage("/\(category)", query: ["category": category])
    }

    public func getCategoryItem(category: String, slug: String) async throws -> Any {
        try await fetchPage(
            "/\(category)/\(slug)",
            query: ["category": category, "slug": slug]
        )
    }

    public func search(in category: String, query: String) async throws -> Any {
        try await fetchPage("/\(category)/search", query: ["q": query])
    }

    public func getNews() async throws -> Any {
        try await getCategory("news")
    }

    public func getNewsItem(slug: String) async throws -> Any {
        try await getCategoryItem(category: "news", slug: slug)
    }

    public func getOpinions() async throws -> Any {
        try await getCategory("opinions")
    }

    public func getOpinionItem(slug: String) async throws -> Any {
        try await getCategoryItem(category: "opinions", slug: slug)
    }

    public func getDocuments() async throws -> Any {
        try await getCategory("documents")
    }

    public func getDocumentItem(slug: String) async throws -> Any {
        try await getCategoryItem(category: "documents", slug: slug)
    }

    public func getMeetings() async throws -> Any {
        try await getCategory("vstrechi-s-ehom")
    }

    public func getMeetingItem(slug: String) async throws -> Any {
        try await getCategoryItem(category: "vstrechi-s-ehom", slug: slug)
    }


    public func getAuthor(slug: String) async throws -> Any {
        try await fetchPage("/author/\(slug)", query: ["slug": slug])
    }

    public func getAuthorsByLetter(_ letter: String) async throws -> Any {
        try await fetchPage("/author/page/\(letter)", query: ["letter": letter])
    }

    public func getProgram(slug: String) async throws -> Any {
        try await fetchPage("/programs/\(slug)", query: ["slug": slug])
    }

    public func getProgramEvent(slug: String, eventSlug: String) async throws -> Any {
        try await fetchPage(
            "/programs/\(slug)/\(eventSlug)",
            query: ["slug": slug, "eventSlug": eventSlug]
        )
    }

    public func getArchiveByProgram(programSlug: String) async throws -> Any {
        try await fetchPage("/archive/\(programSlug)", query: ["programSlug": programSlug])
    }

    public func getViews(postId: Int) async throws -> Any {
        let variables: [String: Any] = [
            "post": [
                "postId": String(postId),
                "postType": "post"
            ]
        ]
        return try await graphQL(
            hash: "832b30a524f02754190102b0a90ae05bbaf0ae4d340a5b31e54b0ade5e7bedd3",
            variables: variables
        )
    }
    
    public func getEditorChoice() async throws -> Any {
        try await graphQL(hash: "83435c3812c8c0a810d5b9d31bdc50366f8a20ed569123719fb144f968b1fdc3")
    }

    public func getPostByUri(uri: String) async throws -> Any {
        try await graphQL(
            hash: "0632566827b2e1f354869e93daaa329b1369015327286ecbbc0fc16564c4fd26",
            variables: ["uri": uri]
        )
    }

    public func search(query: String, first: Int = 20) async throws -> Any {
        try await graphQL(
            hash: "95b190a761701f1472e419d3119f69093cc42d31288f53f5fede02ef16e3ef66",
            variables: ["search": query, "first": first]
        )
    }

    public func getLikes(ids: [String]) async throws -> Any {
        try await graphQL(
            hash: "91d3e12597628a123afb3ebee0ed8941cc3a44822b8b6294080f19866cdcf9c4",
            variables: ["ids": ids]
        )
    }

    public func getEventsData(columnDate: String = "current") async throws -> Any {
        try await graphQL(
            hash: "46c23f565487f06087144aa68ec8ae10aef402c7527c02db8d582e2b460930bb",
            variables: ["columnDate": columnDate]
        )
    }

    public func getNewsWidget() async throws -> Any {
        try await graphQL(hash: "6b33dab2efc3e57dfc8567a2a853647027a50f637d036edaa81e66b102dcea6c")
    }

    public func getPageByUri(uri: String) async throws -> Any {
        try await graphQL(
            hash: "15b8a36d497c0437876e8809c7fbea7257bdb24808e5e1d96356b32cf74953a7",
            variables: ["uri": uri]
        )
    }
}
