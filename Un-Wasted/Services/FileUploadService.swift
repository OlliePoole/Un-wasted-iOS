//
//  FileUploadService.swift
//
//  Created by Oliver Poole on 19/09/2017.
//  Copyright © 2017 E-Man. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Upload: class {

    /// The remote URL to upload to
    var url: URL { get }

    /// The data representation of the resource to upload
    var resourceData: Data { get }
    
    /// An identifier for the upload, preferably unique
    var identifier: String { get set }
    
    /// The mime type of the upload
    var mimeType: String { get }
    
    /// The name of the file being uploaded
    var fileName: String { get }
    
    /// The name of the parameter for the media upload
    var fileParameterName: String { get }
    
    /// The upload task, this is assigned once the upload is created
    var uploadTask: URLSessionUploadTask? { get set }
    
    /// The progress of the upload
    var progress: Float { get }
    
    /// The number of bytes that have been sent
    var bytesSent: Float { get set }
    
    /// The number of bytes that are expected to send
    var bytesExpected: Float { get set }
    
    /// True, if the upload was successful. This is nil if the upload has not completed
    var uploadSuccessful: Bool? { get set }
}

extension Upload {
    
    var progress: Float {
        return bytesSent / bytesExpected
    }
    
}

@objc class FileUploadService: NSObject {
    
    @objc static let sessionIdentifier = "com.un_wasted.iphone.story.upload"
    
    private lazy var uploadSession: URLSession = {
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: FileUploadService.sessionIdentifier)
        backgroundSessionConfiguration.httpMaximumConnectionsPerHost = 1
        
        return URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: nil)
    }()
    
    private var backgroundCompletionHander: (() -> ())?
    
    var activeUploads = [URL: Upload]()
    
    var onSuccessfulUpload: ((_ upload: Upload, _ response: [String: AnyObject]?) -> ())?
    var onFailedUpload: ((_ upload: Upload, _ error: Error) -> ())?
    var onProgressUpdated: ((_ upload: Upload, _ progress: Float) -> ())?
    
    // TODO: Work out a way to remove this shared
    static let shared = FileUploadService()
    
    private override init() { }
    
    func enqueue(upload: Upload) {
        let uploadTask = buildRequest(using: upload)
        
        activeUploads[upload.url] = upload
        upload.uploadTask = uploadTask
        
        uploadTask.resume()
    }
    
    func restartSession(withIdentifier identifier: String, withCompletion completion: @escaping () -> ()) {
        self.backgroundCompletionHander = completion
    }
 
    private func buildRequest(using upload: Upload) -> URLSessionUploadTask {
        let boundary = "Boundary-\(NSUUID().uuidString)"
        
        let body = NSMutableData()
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(upload.fileParameterName)\"; filename=\"\(upload.fileName)\"\r\n")
        body.appendString("Content-Type: \(upload.mimeType)\r\n\r\n")
        body.append(upload.resourceData)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--")
        
        var request = URLRequest(url: upload.url)
        
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // we need to write the upload data to a temporary path
        let path = URL(fileURLWithPath: NSTemporaryDirectory() + "media_\(upload.identifier)")
        body.write(to: path, atomically: false)
        
        return uploadSession.uploadTask(with: request, fromFile: path)
    }
    
}

extension FileUploadService: URLSessionDataDelegate, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        guard let url = task.originalRequest?.url, let upload = activeUploads[url] else {
            print("Unable to find upload for url: \(task.originalRequest?.url)")
            return
        }
        
        upload.bytesSent = Float(totalBytesSent)
        upload.bytesExpected = Float(totalBytesExpectedToSend)
        
        onProgressUpdated?(upload, upload.progress)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let url = task.originalRequest?.url, let upload = activeUploads[url], let error = error else {
            return
            
        }
        
        upload.uploadSuccessful = false
        onFailedUpload?(upload, error)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        guard data.count > 0 else {
            return
        }
        
        if let response = dataTask.response as? HTTPURLResponse, let url = dataTask.originalRequest?.url, let upload = activeUploads[url] {
            activeUploads[url] = nil
            
            if response.statusCode == 200 {
                upload.uploadSuccessful = true
                
                let response = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] ?? [:]
                onSuccessfulUpload?(upload, response)
            }
            else {
                upload.uploadSuccessful = false
                let error = NetworkError.GeneralError
                onFailedUpload?(upload, error)
            }
        }
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        backgroundCompletionHander?()
    }
    
}

private extension NSMutableData {
    
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
    
}
