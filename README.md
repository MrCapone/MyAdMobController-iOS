Cocos2d/Spritebuilder AdMob controller for iOS

IMPORTANT! This controller works only with iOS and AdMob iOS SDK. If you develop for android use #if __CC_PLATFORM_IOS for it methods. Also dont add it files to Android target.

HowTo use.

Download AdMob iOS SDK and add it to your project https://developers.google.com/mobile-ads-sdk/download

change `MY_INTERSTITIAL_ID @"ca-app-pub-*/*` and `MY_BANNER_ID @"ca-app-pub-*/*` on header to your.

At first you need to load ad. I recommend do it on AppDelegate:
```
  [[MyAdMobController sharedController] loadBannerView];
  
  [[MyAdMobController sharedController] loadInterstitial];
```
Then add ad to your scene.

For show Interstitial on current scene just call this methods
```
UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

[[MyAdMobController sharedController] showInterstitialOnViewController:rootViewController];
```
For show BannerView first create UIView and add it to top of root UIView:
```
UIView *adView = [[UIView alloc] initWithFrame:adRect]; 
[[CCDirector sharedDirector].view addSubview:adView];
```
then add Banner View to it:
```
[[MyAdMobController sharedController] addBannerToView:adView];
```
`adRect` it's `CGrect` with size of banner and origin where you want it. For example to show banner on bottom of iphone
```
CGrect adRect = CGRectMake(0, [CCDirector sharedDirector] viewSize].height-50, 320, 50);
```

If you need to resolve some controller methods on your scene use `<MyAdMobControllerDelagate>` protocol:
```
  @interface MyScene () <MyAdMobControllerDelagate>
```
then set delegate:
```
  [[MyAdMobController sharedController] setDelegate:self];
```  
and implement this methods on your scene implementation:
```
  - (void)MyInterstitialDidDismissScreen:(GADInterstitial *)ad;
  - (void)MyInterstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error;
  - (void)MyInterstitialNotLoaded;
  
  - (void)MyAdViewDidReceiveAd:(GADBannerView *)view;
  - (void)MyAdView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error;
```
  
Also about banner reloading. Interstitial automatically will reloaded after user closed it. Banner view will try reload only if it failed to load first time.
