//
//  HTMLFormatter.swift
//  TSUAbiturient
//

import Foundation

func prepareHTMLText(_ text: String) -> String {
  return """
            <html>
            <head>
                <meta name="viewport" content="width=100%, initial-scale=1" />
                <style type="text/css">
                    img {
                        max-width: 100%;
                        height: auto;
                    }
           
                    .table-wrapper {
                        max-width: 100%;
                        overflow: auto;
                    }
           
                    a {
                        word-break: break-all;
                    }
           
                    * {
                        font-family: 'Commissioner', sans-serif;
                        margin-left: 0;
                        margin-right: 0;
                    }
                </style>
            </head>
            <body>
                \(text.removeImageSizeFromHTML().replaceVideoFrames().wrapTables())
            </body>
            </html>
           """
}

// MARK: - String

private extension String {
  func removeImageSizeFromHTML() -> String {
    let regexWidth = try? NSRegularExpression(pattern: RegexConstants.imageWidth)
    let regexHeight = try? NSRegularExpression(pattern: RegexConstants.imageHeight)
    
    guard let regexWidth = regexWidth, let regexHeight = regexHeight else { return self }
    var range = NSRange(location: 0, length: self.utf16.count)
    
    let modString = regexWidth.stringByReplacingMatches(in: self, range: range, withTemplate: "")
    range = NSRange(location: 0, length: modString.utf16.count)
    
    return regexHeight.stringByReplacingMatches(in: modString, range: range, withTemplate: "")
  }
  
  func replaceVideoFrames() -> String {
    let regexVideo = try? NSRegularExpression(pattern: RegexConstants.videoFrame)
    var newHTML = self
    let matches = regexVideo?.matches(in: self, range: NSRange(location: 0, length: self.utf16.count))
    
    let videoURLs = matches?.compactMap {
      if let range = Range($0.range(at: 1), in: self) {
        let videoURL = String(self[range])
        return videoURL
      }
      return nil
    }
    
    guard let regexVideo = regexVideo else { return self }
    
    videoURLs?.forEach {
      let range = NSRange(location: 0, length: newHTML.utf16.count)
      newHTML = regexVideo.stringByReplacingMatches(in: newHTML,
                                                    range: range,
                                                    withTemplate: String(format: RegexConstants.HTMLLinkTag, $0, $0))
    }
    return newHTML
  }
  
  func wrapTables() -> String {
    let regexTable = try? NSRegularExpression(pattern: RegexConstants.tableFrame)
    var newHTML = self
    let matches = regexTable?.matches(in: self, range: NSRange(location: 0, length: self.utf16.count))
    
    let tables = matches?.compactMap {
      if let range = Range($0.range, in: self) {
        let table = String(self[range])
        return table
      }
      return nil
    }
    
    guard let regexTable = regexTable else { return self }
    
    tables?.forEach {
      let range = NSRange(location: 0, length: newHTML.utf16.count)
      newHTML = regexTable.stringByReplacingMatches(in: newHTML,
                                                    range: range,
                                                    withTemplate: String(format: RegexConstants.HTMLTableWrapper, $0))
    }
    return newHTML
  }
}

// MARK: - RegexConstant

private enum RegexConstants {
  static let imageWidth = "width: \\d+px;"
  static let imageHeight = "height: \\d+px;"
  
  static let videoFrame = "<iframe.+src=\"(.+)\" .+></iframe>"
  static let HTMLLinkTag = "<a href=\"%@\">%@</a>"
  
  static let tableFrame = "<table(.*\\R)*</table>"
  static let HTMLTableWrapper = "<div class=\"table-wrapper\">%@</div>"
}
