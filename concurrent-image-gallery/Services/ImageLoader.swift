//
//  File.swift
//  concurrent-image-gallery
//
//  Created by Pranav Patil on 30/09/25.
//

import UIKit

class ImageLoader {

    typealias completionResult = (Result<UIImage, Error>) -> Void

    static let shared = ImageLoader()

    let cache = NSCache<NSURL, UIImage>()
    var ongoingRequests = [URL: [completionResult]]()

    // For thread safety
    let serialQueue = DispatchQueue(label: "com.queue.completionHandlerQueue")

    private init() {}

    func fetchImage(for url: URL, completion: @escaping completionResult) {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            completion(.success(cachedImage))
            return
        }

        var shouldMakeRequest = false
        serialQueue.sync {
            var completions = [completion]
            if let completionHandlers = ongoingRequests[url] {
                completions.append(contentsOf: completionHandlers)
                ongoingRequests[url] = completions
            } else {
                ongoingRequests[url] = completions
                shouldMakeRequest = true
            }
        }

        guard shouldMakeRequest else {
            return
        }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            guard let self else {
                completion(.failure(NSError(domain: "Nil self", code: 0)))
                return
            }

            if let error {
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion(.failure(NSError(
                    domain: "Invalid response. Status code: \(httpResponse.statusCode)",
                    code: 0)))
                return
            }

            if let data, let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: url as NSURL)

                var completions = [completionResult]()
                self.serialQueue.sync {
                    completions = self.ongoingRequests[url] ?? []
                    self.ongoingRequests.removeValue(forKey: url)
                }

                for handler in completions {
                    handler(.success(image))
                }
            } else {
                completion(.failure(NSError(domain: "Unable to parse data", code: 0)))
            }
        }

        task.resume()
    }
}
