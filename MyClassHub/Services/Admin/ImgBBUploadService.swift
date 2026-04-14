//
//  ImgBBUploadService.swift
//  MyClassHub
//
//  Created by SIR on 13/4/26.
//

import UIKit

final class ImgBBUploadService {
    static let shared = ImgBBUploadService()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 120
        config.timeoutIntervalForResource = 120
        return URLSession(configuration: config)
    }()

    private var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "IMGBB_API_KEY") as? String,
              !key.isEmpty else {
            fatalError("IMGBB_API_KEY missing or empty in Info.plist")
        }
        return key
    }

    func uploadImage(_ image: UIImage) async throws -> String {

        // Resize image before upload to reduce size
        let resized = resizeImage(image, maxDimension: 800)

        // Try lower compression first
        guard let data = resized.jpegData(compressionQuality: 0.5) else {
            throw URLError(.cannotDecodeContentData)
        }

        print("📤 Uploading image — size: \(data.count / 1024) KB")

        let url = URL(string: "https://api.imgbb.com/1/upload?key=\(apiKey)")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"

        let boundary = UUID().uuidString
        req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        req.httpBody = body

        let (resData, response) = try await session.data(for: req)

        // Check HTTP status
        if let httpResponse = response as? HTTPURLResponse {
            print("📥 ImgBB response status: \(httpResponse.statusCode)")
            guard httpResponse.statusCode == 200 else {
                throw NSError(
                    domain: "ImgBB",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "Upload failed. HTTP \(httpResponse.statusCode)"]
                )
            }
        }

        // Parse response
        guard let json = try? JSONSerialization.jsonObject(with: resData) as? [String: Any] else {
            throw NSError(
                domain: "ImgBB",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid response from ImgBB"]
            )
        }

        print("📦 ImgBB JSON: \(json)")

        guard
            let success = json["success"] as? Bool, success,
            let dataDict = json["data"] as? [String: Any],
            let imageUrl = dataDict["url"] as? String
        else {
            let errorMsg = (json["error"] as? [String: Any])?["message"] as? String
                ?? "Unknown ImgBB error"
            throw NSError(
                domain: "ImgBB",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: errorMsg]
            )
        }

        print("✅ Upload successful: \(imageUrl)")
        return imageUrl
    }

    // MARK: Resize helper
    private func resizeImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
        let size = image.size
        let largerSide = max(size.width, size.height)

        // No resize needed if already small
        guard largerSide > maxDimension else { return image }

        let scale = maxDimension / largerSide
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resized = UIGraphicsGetImageFromCurrentImageContext() ?? image
        UIGraphicsEndImageContext()

        return resized
    }
}
