import Cocoa
import Vision

// https://developer.apple.com/documentation/vision/vnrecognizetextrequest

let MODE = VNRequestTextRecognitionLevel.accurate // or .fast
let USE_LANG_CORRECTION = false
var REVISION:Int
if #available(macOS 11, *) {
    REVISION = VNRecognizeTextRequestRevision2
} else {
    REVISION = VNRecognizeTextRequestRevision1
}

func main(args: [String]) -> Int32 {
    guard CommandLine.arguments.count == 3 else {
        fputs(String(format: "usage: %1$@ image dst\n", CommandLine.arguments[0]), stderr)
        return 1
    }

    // Flag ideas:
    // --version
    // Print REVISION
    // --langs
    // guard let langs = VNRecognizeTextRequest.supportedRecognitionLanguages(for: .accurate, revision: REVISION)
    // --fast (default accurate)
    // --fix (default no language correction)

    let (src, dst) = (args[1], args[2])

    guard let img = NSImage(byReferencingFile: src) else {
        fputs("Error: failed to load image '\(src)'\n", stderr)
        return 1
    }

    guard let imgRef = img.cgImage(forProposedRect: &img.alignmentRect, context: nil, hints: nil) else {
        fputs("Error: failed to convert NSImage to CGImage for '\(src)'\n", stderr)
        return 1
    }


    let request = VNRecognizeTextRequest { (request, error) in
        let observations = request.results as? [VNRecognizedTextObservation] ?? []
        let obs : [String] = observations.map { $0.topCandidates(1).first?.string ?? ""}
        try? obs.joined(separator: "\n").write(to: URL(fileURLWithPath: dst), atomically: true, encoding: String.Encoding.utf8)
    }
    request.recognitionLevel = MODE
    request.usesLanguageCorrection = USE_LANG_CORRECTION
    request.revision = REVISION

    var recognitionLanguages = ["zh-Hans", "en-US"]
    request.recognitionLanguages = recognitionLanguages
       
    
    //request.minimumTextHeight = 0
    //request.customWords = [String]

    try? VNImageRequestHandler(cgImage: imgRef, options: [:]).perform([request])

    return 0
}
exit(main(args: CommandLine.arguments))
