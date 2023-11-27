# macocr

OCR command line utility for macOS 10.15+. Utilizes the [VNRecognizeTextRequest](https://developer.apple.com/documentation/vision/vnrecognizetextrequest) API.

2023 Nov. Now support Chinese OCR

## Build and Run

```
swift build
swift run
```

If `-c release` is not used, then the executable may be located at: `./.build/debug/macocr`
