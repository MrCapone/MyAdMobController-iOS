//  Created by MrCapone
//  Copyright (c) Lukyanov D. M. All rights reserved.
//

#import "MyAdMobController.h"

@implementation MyAdMobController

@synthesize delegate;

+ (MyAdMobController *)sharedController {
    static dispatch_once_t once;
    static MyAdMobController * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark Interstitial

- (void)loadInterstitial
{
    if ( interstitial_ != nil ) {
        interstitial_ = nil; //clean interstitial for reloading
        
    }
    
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.delegate = self;
    interstitial_.adUnitID = MY_INTERSTITIAL_ID;
    [interstitial_ loadRequest:[GADRequest request]];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    if ([self.delegate respondsToSelector:@selector(MyInterstitialDidDismissScreen:)]) {
        [self.delegate MyInterstitialDidDismissScreen:ad];
    }
    
    [self loadInterstitial];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    if ([self.delegate respondsToSelector:@selector(MyInterstitial:didFailToReceiveAdWithError:)]) {
        [self.delegate MyInterstitial:ad didFailToReceiveAdWithError:error];
    }
    
    NSLog(@"Interstitial loading error: %@", error.description);
}

- (void)showInterstitialOnViewController:(UIViewController *)viewController
{
    if (interstitial_ != nil && [interstitial_ isReady]) {
        [interstitial_ presentFromRootViewController:viewController];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(MyInterstitialNotLoaded)]) {
            [self.delegate MyInterstitialNotLoaded];
        }
        
        NSLog(@"Interstitial is not loaded");
        [self loadInterstitial];
    }
}

#pragma mark Banner View

- (void)loadBannerView
{
    if (bannerView_ != nil) {
        bannerView_ = nil; //clear bannerView for reloading
    }
    
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:CGPointMake(0, 0)];
    bannerView_.adUnitID = MY_BANNER_ID;
    bannerView_.rootViewController = [CCDirector sharedDirector]; //dirty hack, need more tests
    bannerView_.delegate = self;
    [bannerView_ loadRequest:[GADRequest request]];
}

-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    if ([self.delegate respondsToSelector:@selector(MyAdView:didFailToReceiveAdWithError:)]) {
        [self.delegate MyAdView:view didFailToReceiveAdWithError:error];
    }
    
    NSLog(@"Banner loading error: %@", error.description);

}

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    if ([self.delegate respondsToSelector:@selector(MyAdViewDidReceiveAd:)]) {
        [self.delegate MyAdViewDidReceiveAd:view];
    }
}

- (void)addBannerToView:(UIView *)view
{
    if (bannerView_ != nil) {
        [view addSubview:bannerView_];
    }
    else
    {
        NSLog(@"Banner is not loaded");
        [self loadBannerView];
    }
}

@end
