//
//  RMViewController.h
//  HelloRMVision
//
//  Created by Adam Setapen on 6/16/13.
//  Copyright (c) 2013 Romotive, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <RMVision/RMVision.h>

#import <MQTTClient/MQTTClient.h>
#import <MQTTClient/MQTTSessionManager.h>

@interface RMViewController : UIViewController <MQTTSessionManagerDelegate, RMVisionDelegate>
{
        NSTimer *timer;
}

@property (nonatomic, strong) RMVision *vision;

/*
 * MQTTClient: keep a strong reference to your MQTTSessionManager here
 */
@property (strong, nonatomic) MQTTSessionManager *manager;

@property (strong, nonatomic) NSUserDefaults *defaults;

@property (nonatomic) BOOL faceAlreadyDetected;

@end
