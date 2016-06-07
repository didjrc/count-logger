//
//  AppDelegate.h
//  Count Logger
//
//  Created by Jonathan Chinen on 30/5/16.
//  Copyright © 2016 Jonathan Chinen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PebbleKit/PebbleKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, PBPebbleCentralDelegate, PBWatchDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PBWatch *connectedWatch;
@property (weak, nonatomic) PBPebbleCentral *central;

@end

