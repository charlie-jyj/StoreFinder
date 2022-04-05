#  

## Store Finder

### lib and design model
- RxSwift
- MVVM
- kakao map API

### iOS Fundamental

#### 📍 CLLocationManager

- Core Location
- 앱에 위치 서비스 추가하기
- CLLocationManagerDelegate
- 승인 요청/ 승인의 단계 필요 (일회성, 앱 사용 시, 항상)
- 사용자의 현재 위치에서 크거나 작은 변화 추적
- 나침반에서 방향 변경 추적
- 사용자 위치 기반 이벤트 생성
- 근거리 데이터 통신기기 (Bluetooth Beacon)와 통신

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

#### 🔑 CodingKey

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

- String protocol이 CodingKey protocol 보다 먼저 와야한다.

### kakao map api 사용하기

#### 1. 기본 셋팅
<https://apis.map.kakao.com/ios/guide/#step1>

- SDK 다운로드
- kakao API 페이지에 bundle ID 등록
- Info.plist 파일에 APP KEY 설정
- ARC No 설정

#### 2. 프레임워크, 라이브러리 추가

- 🎯 해당 프레임워크는 Objective-c 로 작성되어 있기 때문에 추가 설정 필요
- bridgingHeader.h
    ```swift
    #ifndef BridgingHeader_h
    #define BridgingHeader_h
    #import <DaumMap/MTMapView.h>
    #endif /* BridgingHeader_h */
    ```
- 🍉 Target > Build Setting > Swift Compiler - General > Objective-C Bridging Header에 헤더파일 경로 등록

#### 3. 빌드 오류 처리

- OpenGLES is deprecated : Metal instead
- Fat frame work 링크 오류 
```
Showing All Messages
/Users/yujin/Documents/practice/StoreFinder/StoreFinder.xcodeproj Building for iOS Simulator, but the linked and embedded framework 'DaumMap.framework' was built for iOS + iOS Simulator.
```
    - Target > Build Setting > Validate Workspace > Yes 로 수정

- 아키텍처 arm64 오류 
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
    - CodeSign 오류가 나는 framework를 embeded -> do not embed 로 수정하여 해결
    - embeded vs do not embeded
    <https://holyswift.app/frameworks-embed-or-not-embed-thats-the-question>
    - Mach-O Type? 
    <https://medium.com/tokopedia-engineering/a-curious-case-of-mach-o-executable-26d5ecadd995>

#### 4. MTMapView 구현

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

#### 5. 현위치 트래킹 및 나침반 모드 설정

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
