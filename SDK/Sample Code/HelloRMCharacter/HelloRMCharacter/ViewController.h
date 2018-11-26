//
//  ViewController.h
//  HelloRMCharacter
//

#import <UIKit/UIKit.h>
#import <RMCharacter/RMCharacter.h>
#import <RMCore/RMCore.h>
#import <CoreMotion/CoreMotion.h>
#import <GLKit/GLKit.h>


#import <MQTTClient/MQTTClient.h>
#import <MQTTClient/MQTTSessionManager.h>


@interface ViewController : UIViewController <MQTTSessionManagerDelegate, RMCoreDelegate>
{
    CMMotionManager *motionManager;
    NSTimer *timer;
    NSTimer *driveTimer;
    NSNumber *currentTime;
    NSDictionary *gyros;
    NSDictionary *accel;
    
}
@property (nonatomic, strong) RMCharacter *Romo;
@property (nonatomic, strong) RMCoreRobotRomo3 *Romo3;
@property (nonatomic, strong) RMCoreRobot<HeadTiltProtocol, DriveProtocol, LEDProtocol> *robot;

/*
 * MQTTClient: keep a strong reference to your MQTTSessionManager here
 */
@property (strong, nonatomic) MQTTSessionManager *manager;

@property (strong, nonatomic) NSUserDefaults *defaults;

@property (strong, nonatomic) NSMutableArray *chat;

@property (nonatomic)           RMCharacterEmotion lastEmotion;
@property (nonatomic)           RMCharacterExpression lastExpression;
@property (nonatomic)           CGFloat lastPupilDilation;
@property (nonatomic)           CGFloat lastFaceRotation;
@property (nonatomic)           BOOL lastLeftEyeOpen;
@property (nonatomic)           BOOL lastRightEyeOpen;
@property (nonatomic)           RMCoreDriveCommand lastDriveCommand;
@property (nonatomic)           BOOL lastIsDriving;
@property (nonatomic)           BOOL lastIsTilting;
@property (nonatomic)           BOOL lastIsDrivable;
@property (nonatomic)           BOOL lastIsHeadTiltable;


@property (nonatomic)           RMCharacterEmotion currentEmotion;
@property (nonatomic)           RMCharacterExpression currentExpression;
@property (nonatomic)           CGFloat currentPupilDilation;
@property (nonatomic)           CGFloat currentFaceRotation;
@property (nonatomic)           BOOL currentLeftEyeOpen;
@property (nonatomic)           BOOL currentRightEyeOpen;
@property (nonatomic)           RMCoreDriveCommand currentDriveCommand;
@property (nonatomic)           BOOL currentIsDriving;
@property (nonatomic)           BOOL currentIsTilting;
@property (nonatomic)           BOOL currentIsDrivable;
@property (nonatomic)           BOOL currentIsHeadTiltable;

@end
