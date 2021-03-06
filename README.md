#  

## Store Finder

### lib and design model
- RxSwift
- MVVM
- kakao map API

### iOS Fundamental

#### ๐ CLLocationManager

- Core Location
- ์ฑ์ ์์น ์๋น์ค ์ถ๊ฐํ๊ธฐ
- CLLocationManagerDelegate
- ์น์ธ ์์ฒญ/ ์น์ธ์ ๋จ๊ณ ํ์ (์ผํ์ฑ, ์ฑ ์ฌ์ฉ ์, ํญ์)
- ์ฌ์ฉ์์ ํ์ฌ ์์น์์ ํฌ๊ฑฐ๋ ์์ ๋ณํ ์ถ์ 
- ๋์นจ๋ฐ์์ ๋ฐฉํฅ ๋ณ๊ฒฝ ์ถ์ 
- ์ฌ์ฉ์ ์์น ๊ธฐ๋ฐ ์ด๋ฒคํธ ์์ฑ
- ๊ทผ๊ฑฐ๋ฆฌ ๋ฐ์ดํฐ ํต์ ๊ธฐ๊ธฐ (Bluetooth Beacon)์ ํต์ 

##### Core Location
> Obtain the geographic location and orientation of a device

- provides services that determine a device's geographic location, altitude, and orientation, or its position relative to a nearby iBeacon device
- gathers data using all available components on the device, including the Wi-Fi, GPS, Bluetooth, magnetometer, barometer, and cellular hardware
- You use instance of the CLLocationmanager class to configure, start, and stop the Core Location services

##### CLLocationManager
> supports location-related activities: standard and significant location updates, region monitoring, beacon ranging, compass headings

- your app requests authorization and the system prompts the user to grant or deny the request
- receives events, including authorization changes, in your location manager's delegate object
- create an instance of the CLLocationManager class and store a strong reference to it somewhere in your app
- which conforms to the `CLLocationManagerDelegate` protocol
- assign your delegate object to the delegate property of the CLLocationManager object (before starting any services)
    - the system calls your delegate object's methods from the thread in which you started the corresponding location services
    - that thread must itself have an active run loop, like the one found in your app's main thread

<https://developer.apple.com/documentation/corelocation>
<https://developer.apple.com/documentation/corelocation/adding_location_services_to_your_app>

##### ์ฌ์ฉ์ ์น์ธ ์ป๊ธฐ
- info.plist
- Privacy- Location When In Use Usage Description

#### ๐ CodingKey

```swift
struct Landmark: Codable {
    var name: String
    var foundingYear: Int
    var location: Coordinate
    var vantagePoints: [Coordinate]
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case foundingYear = "founding_date"
        
        case location
        case vantagePoints
    }
}
```

- String protocol์ด CodingKey protocol ๋ณด๋ค ๋จผ์  ์์ผํ๋ค.

#### ๐งฉ where clause ์ฌ์ฉํ๊ธฐ

```swift

switch data {
case let .success(data) where data.documents.isEmpty:

extension Reactive where Base: MTMapView {
///
```
- switch case ํจํด๊ณผ ๊ฒฐํฉํ์ฌ ์กฐ๊ฑด ์ถ๊ฐ 
- ํ์์ ๋ํ ํ๋กํ ์ฝ ์ ์ฝ ์ถ๊ฐ
- to create dynamic filter

<https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html>

### kakao map api ์ฌ์ฉํ๊ธฐ

#### 1. ๊ธฐ๋ณธ ์ํ
<https://apis.map.kakao.com/ios/guide/#step1>

- SDK ๋ค์ด๋ก๋
- kakao API ํ์ด์ง์ bundle ID ๋ฑ๋ก
- Info.plist ํ์ผ์ APP KEY ์ค์ 
- ARC No ์ค์ 

#### 2. ํ๋ ์์ํฌ, ๋ผ์ด๋ธ๋ฌ๋ฆฌ ์ถ๊ฐ

- ๐ฏ ํด๋น ํ๋ ์์ํฌ๋ Objective-c ๋ก ์์ฑ๋์ด ์๊ธฐ ๋๋ฌธ์ ์ถ๊ฐ ์ค์  ํ์
- bridgingHeader.h
    ```swift
    #ifndef BridgingHeader_h
    #define BridgingHeader_h
    #import <DaumMap/MTMapView.h>
    #endif /* BridgingHeader_h */
    ```
- ๐ Target > Build Setting > Swift Compiler - General > Objective-C Bridging Header์ ํค๋ํ์ผ ๊ฒฝ๋ก ๋ฑ๋ก

#### 3. ๋น๋ ์ค๋ฅ ์ฒ๋ฆฌ

- OpenGLES is deprecated : Metal instead
- Fat frame work ๋งํฌ ์ค๋ฅ 
```
Showing All Messages
/Users/yujin/Documents/practice/StoreFinder/StoreFinder.xcodeproj Building for iOS Simulator, but the linked and embedded framework 'DaumMap.framework' was built for iOS + iOS Simulator.
```
    - Target > Build Setting > Validate Workspace > Yes ๋ก ์์ 

- ์ํคํ์ฒ arm64 ์ค๋ฅ 
```
DaumMap.embeddedframework/DaumMap.framework/DaumMap(MTMapView.o), building for iOS Simulator, but linking in object file built for iOS, for architecture arm64
```
    - Target > Build Setting > add Any iOS Simulator SDK with value arm64 inside Excluded Architecture
    <img src="https://i.stack.imgur.com/XGVJM.png">
    <https://stackoverflow.com/questions/63607158/xcode-building-for-ios-simulator-but-linking-in-an-object-file-built-for-ios-f>

- CodeSign Failed
```
Command CodeSign failed with a nonzero exit code
```
    - CodeSign ์ค๋ฅ๊ฐ ๋๋ framework๋ฅผ embeded -> do not embed ๋ก ์์ ํ์ฌ ํด๊ฒฐ
    - embeded vs do not embeded
    <https://holyswift.app/frameworks-embed-or-not-embed-thats-the-question>
    - Mach-O Type? 
    <https://medium.com/tokopedia-engineering/a-curious-case-of-mach-o-executable-26d5ecadd995>
    
- Could not find or use auto-linked library 'XCTestSwiftSupport'
recently I met often unfamiliar errors when I build the project,
I don't know why it works then but fails now

- Build Settings > Build Options > Enable Testing Search Paths > YES

- dyld Library not loaded @rpath/lib XCTest Swift Support.dylib
    - Build Settings > Always Embed Swift Standard Libraries > YES
    - RxTest lib ์ ๊ฑฐ => RxTest์ target ๋ณ๊ฒฝ!
    - M1์ผ๋ก pod install ํ๋ ค๋ฉด, terminal์ rosetta mode๋ก! 

```swift
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    pod 'RxSwift', '6.5.0'
    pod 'RxCocoa', '6.5.0'
end

# RxTest and RxBlocking make the most sense in the context of unit/integration tests
target 'YOUR_TESTING_TARGET' do
    pod 'RxBlocking', '6.5.0'
    pod 'RxTest', '6.5.0'
end
```
<https://github.com/ReactiveX/RxSwift>


#### 4. MTMapView ๊ตฌํ

```objective-c
#import <DaumMap/MTMapView.h>
- (void)viewDidLoad {
    [super viewDidLoad];
    _mapView = [[MTMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _mapView.delegate = self;
    _mapView.baseMapType = MTMapTypeHybrid;
    [self.view addSubview:_mapView];

}
```

#### 5. ํ์์น ํธ๋ํน ๋ฐ ๋์นจ๋ฐ ๋ชจ๋ ์ค์ 

```objective-c

- (void)mapView:(MTMapView*)mapView updateCurrentLocation:(MTMapPoint*)location withAccuracy:(MTMapLocationAccuracy)accuracy {
    MTMapPointGeo currentLocationPointGeo = location.mapPointGeo;
    NSLog(@"MTMapView updateCurrentLocation (%f,%f) accuracy (%f)",
    currentLocationPointGeo.latitude,
    currentLocationPointGeo.longitude,
    accuracy);
}

- (void)mapView:(MTMapView*)mapView updateDeviceHeading:(MTMapRotationAngle)headingAngle {
    NSLog(@"MTMapView updateDeviceHeading (%f) degrees", headingAngle);
}

```

### ๐ RxSwift

#### withLatestFrom(_ second: Source)

```swift
        //MARK: ์ง๋ ์ค์ฌ์  ์ค์ 
        let moveToCurrentLocation = currentLocationButtonTapped // button์ด tapped ๋์์ ๋์
            .withLatestFrom(currentLocation) // current location์ ํ ๋ฒ์ด๋ผ๋ ๋ฐ์ ์ด ํ์
```
- Merges two observable sequences into one observable sequence 
- by using latest element from the second sequence every time when self emits an element.
- Elements emitted by self before the second source has emitted any values will be omitted.
- An observable sequence containing the result of combining each element of the self with the latest element from the second source
- if any, using the specified result selector function.

#### accept()

```swift
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
         viewModel?.mapCenterPoint.accept(mapCenterPoint)
    }
```
- Accepts `event` and emits it to subscribers
- onNext ๋์ , Relay๋ accept
- Relay๋ error๋ completed ๋ฅผ ๋ฐ์ง ์๊ธฐ ๋๋ฌธ์


#### extension Reactive where Base: 

```swift
public struct Binder<Value>: ObserverType {
    public typealias Element = Value
    
    private let binding: (Event<Value>) -> Void

    /// Initializes `Binder`
    ///
    /// - parameter target: Target object.
    /// - parameter scheduler: Scheduler used to bind the events.
    /// - parameter binding: Binding logic.
    public init<Target: AnyObject>(_ target: Target, scheduler: ImmediateSchedulerType = MainScheduler(), binding: @escaping (Target, Value) -> Void) {
    
extension Reactive where Base: MTMapView {
    var setMapCenterPoint: Binder<MTMapPoint> {
        return Binder(base) { base, point in
            base.setMapCenter(point, animated: true)
        }
    }
}
```

#### share()
```swift

    let cvsLocationDataResult = mapCenterPoint  // finishedMapMoveAnimation -> mapCenterPoint.accept
        .flatMapLatest(model.getLocation)
        .share()

```
- Returns an observable sequence that shares a single subscription to the underlying sequence, 
- and immediately upon subscription replays elements in buffer.

