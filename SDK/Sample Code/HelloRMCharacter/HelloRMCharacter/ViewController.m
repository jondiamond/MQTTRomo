//
//  ViewController.m
//  HelloRMCharacter
//
#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)

#import "ViewController.h"

@implementation ViewController

NSString * const EmotionType_toString[] = {
    [RMCharacterEmotionCurious] = @"curious",
    [RMCharacterEmotionExcited] = @"excited",
    [RMCharacterEmotionHappy] = @"happy",
    [RMCharacterEmotionSad] = @"sad",
    [RMCharacterEmotionScared] = @"scared",
    [RMCharacterEmotionSleepy] = @"sleepy",
    [RMCharacterEmotionSleeping] = @"sleeping",
    [RMCharacterEmotionBewildered] = @"bewildered",
    [RMCharacterEmotionDelighted] = @"delighted",
    [RMCharacterEmotionIndifferent] = @"indifferent"
};

NSString * const ExpressionType_toString[] = {
    [RMCharacterExpressionNone] = @"none",
    [RMCharacterExpressionAngry] = @"angry",
    [RMCharacterExpressionBored] = @"bored",
    [RMCharacterExpressionCurious] = @"curious",
    [RMCharacterExpressionDizzy] = @"dizzy",
    [RMCharacterExpressionEmbarrassed] = @"embarrassed",
    [RMCharacterExpressionExcited] = @"excited",
    [RMCharacterExpressionExhausted] = @"exhausted",
    [RMCharacterExpressionHappy] = @"happy",
    [RMCharacterExpressionHoldingBreath] = @"holdingbreath",
    [RMCharacterExpressionLaugh] = @"laugh",
    [RMCharacterExpressionLookingAround] = @"lookingaround",
    [RMCharacterExpressionLove] = @"love",
    [RMCharacterExpressionPonder] = @"ponder",
    [RMCharacterExpressionSad] = @"sad",
    [RMCharacterExpressionScared] = @"scared",
    [RMCharacterExpressionSleepy] = @"sleepy",
    [RMCharacterExpressionSneeze] = @"sneeze",
    [RMCharacterExpressionTalking] = @"talking",
    [RMCharacterExpressionYawn] = @"yawn",
    [RMCharacterExpressionStartled] = @"startled",
    [RMCharacterExpressionChuckle] = @"chuckle",
    [RMCharacterExpressionProud] = @"proud",
    [RMCharacterExpressionLetDown] = @"letdown",
    [RMCharacterExpressionWant] = @"want",
    [RMCharacterExpressionHiccup] = @"hiccup",
    [RMCharacterExpressionFart] = @"fart",
    [RMCharacterExpressionBewildered] = @"bewildered",
    [RMCharacterExpressionYippee] = @"yippee",
    [RMCharacterExpressionSniff] = @"sniff",
    [RMCharacterExpressionSmack] = @"smack",
    [RMCharacterExpressionWee] = @"wee",
    [RMCharacterExpressionStruggling] = @"struggling"
};

NSString * const DriveCommand_toString[] = {
    [RMCoreDriveCommandStop]        = @"RMCoreDriveCommandStop",
    [RMCoreDriveCommandForward]     = @"RMCoreDriveCommandForward",
    [RMCoreDriveCommandBackward]    = @"RMCoreDriveCommandBackward",
    [RMCoreDriveCommandWithPower]   = @"RMCoreDriveCommandWithPower",
    [RMCoreDriveCommandWithHeading] = @"RMCoreDriveCommandWithHeading",
    [RMCoreDriveCommandWithRadius]  = @"RMCoreDriveCommandWithRadius",
    [RMCoreDriveCommandTurn]        = @"RMCoreDriveCommandTurn"
};

#pragma mark -- View Lifecycle --

- (NSDictionary *)getGyroData {
    CMDeviceMotion *motionData = motionManager.deviceMotion;
    CMAttitude *attitude = motionData.attitude;
    
    CMQuaternion quat = attitude.quaternion;
    GLKQuaternion q = GLKQuaternionMake(quat.x, quat.y, quat.z, quat.w);
    
    GLKQuaternion rq = GLKQuaternionMakeWithAngleAndAxis(DEGREES_RADIANS(-90), 1, 0, 0);
    
    q = GLKQuaternionMultiply(rq, q);
    
    GLKVector3 axis = GLKQuaternionAxis(GLKQuaternionInvert(q));
    
    NSString *x = [NSString stringWithFormat:@"%f", axis.v[0]];
    
    NSString *y = [NSString stringWithFormat:@"%f", -axis.v[1]];
    
    NSString *z = [NSString stringWithFormat:@"%f", axis.v[2]];
    
    NSString *w = [NSString stringWithFormat:@"%f", GLKQuaternionAngle(q)];
    
    NSDictionary *dic = (@{@"x": x, @"y" : y, @"z" : z, @"w" : w});
    return dic;
}

- (NSDictionary *)getAccelerometerData {
    CMAccelerometerData *accelData = motionManager.accelerometerData;
    
    NSString *x = [NSString stringWithFormat:@"%f", accelData.acceleration.x];
    
    NSString *y = [NSString stringWithFormat:@"%f", accelData.acceleration.y];
    
    NSString *z = [NSString stringWithFormat:@"%f", accelData.acceleration.z];


    NSDictionary *dic = (@{@"x": x, @"y" : y, @"z" : z});
    
    return dic;
}

- (NSDictionary *)getDateTimeParts:(NSDate **)timestamp {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:*timestamp];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    
    // Create and format a current time string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SSS"];
    
    NSString *newDateString = [dateFormatter stringFromDate:*timestamp];
    *timestamp = (NSDate*)newDateString;
    
    // Create a dictionary for our time data
    NSDictionary *dateTime = [[NSDictionary alloc] initWithObjectsAndKeys:
                              newDateString,@"datetimestring",
                              [NSNumber numberWithInteger:year],@"year",
                              [NSNumber numberWithInteger:month],@"month",
                              [NSNumber numberWithInteger:day],@"day",
                              [NSNumber numberWithInteger:hour],@"hour",
                              [NSNumber numberWithInteger:minute],@"minute",
                              [NSNumber numberWithInteger:second],@"second",
                              nil
                              ];
    return dateTime;
}

- (NSMutableDictionary *)getRomoState {
    if (self.currentEmotion != [self.Romo emotion]) {
        self.lastEmotion = self.currentEmotion;
    }
    
    self.currentEmotion = [self.Romo emotion];
    
    if (self.currentExpression != [self.Romo expression]) {
        self.lastExpression = self.currentExpression;
    }
    
    self.currentExpression = [self.Romo expression];
    
    if (self.currentPupilDilation != [self.Romo pupilDilation]) {
        self.lastPupilDilation = self.currentPupilDilation;
    }
    
    self.currentPupilDilation = [self.Romo pupilDilation];
    
    
    if (self.currentFaceRotation != [self.Romo faceRotation]) {
        self.lastFaceRotation = self.currentFaceRotation;
    }
    
    self.currentFaceRotation = [self.Romo faceRotation];
    
    if (self.currentLeftEyeOpen != [self.Romo leftEyeOpen]) {
        self.lastLeftEyeOpen = self.currentLeftEyeOpen;
    }
    
    self.currentLeftEyeOpen = [self.Romo leftEyeOpen];
    
    if (self.currentRightEyeOpen != [self.Romo rightEyeOpen]) {
        self.lastRightEyeOpen = self.currentRightEyeOpen;
    }
    
    self.currentRightEyeOpen = [self.Romo rightEyeOpen];
    
    if (self.currentDriveCommand != [self.robot driveCommand]) {
        self.lastDriveCommand = self.currentDriveCommand;
    }
    
    self.currentDriveCommand = [self.robot driveCommand];
    
    
    if (self.currentIsDriving != [self.robot isDriving]) {
        self.lastIsDriving = self.currentIsDriving;
    }
    
    self.currentIsDriving = [self.robot isDriving];
    
    if (self.currentIsTilting != [self.robot isTilting]) {
        self.lastIsTilting = self.currentIsTilting;
    }
    
    self.currentIsTilting = [self.robot isTilting];
    
    if (self.currentIsDrivable != [self.robot isDrivable]) {
        self.lastIsDrivable= self.currentIsDrivable;
    }
    
    self.currentIsDrivable = [self.robot isDrivable];
    
    if (self.currentIsHeadTiltable != [self.robot isHeadTiltable]) {
        self.lastIsHeadTiltable= self.currentIsHeadTiltable;
    }
    
    self.currentIsHeadTiltable = [self.robot isHeadTiltable];

    float batteryLevel = [self.robot.vitals batteryLevel];
    
    
    // Get romos current emotion and expression
    NSMutableDictionary *romoState = [[NSMutableDictionary alloc]initWithCapacity:25];
    
    if (self.currentEmotion)
        [romoState setObject:EmotionType_toString[self.currentEmotion] forKey:@"emotion"];
    
    if (self.lastEmotion)
        [romoState setObject:EmotionType_toString[self.lastEmotion] forKey:@"lastEmotion"];
    
    [romoState setObject:ExpressionType_toString[self.currentExpression] forKey:@"expression"];
    
    [romoState setObject:ExpressionType_toString[self.lastExpression] forKey:@"lastExpression"];
    
    [romoState setObject: [NSNumber numberWithFloat:self.currentPupilDilation] forKey:@"pupilDilation"];

    [romoState setObject:[NSNumber numberWithFloat:self.currentPupilDilation] forKey:@"lastPupilDilation"];

    [romoState setObject: [NSNumber numberWithFloat:self.currentFaceRotation] forKey:@"faceRotation"];
    
    [romoState setObject:[NSNumber numberWithFloat:self.lastFaceRotation] forKey:@"lastFaceRotation"];
    
    [romoState setObject:[NSNumber numberWithBool:self.currentLeftEyeOpen] forKey:@"leftEyeOpen"];
    
    [romoState setObject:[NSNumber numberWithBool:self.lastLeftEyeOpen] forKey:@"lastLeftEyeOpen"];

    [romoState setObject:[NSNumber numberWithBool:self.currentRightEyeOpen] forKey:@"rightEyeOpen"];
    
    [romoState setObject:[NSNumber numberWithBool:self.lastRightEyeOpen] forKey:@"lastRightEyeOpen"];
    
    [romoState setObject: DriveCommand_toString[self.currentDriveCommand] forKey:@"driveCommand"];
    
    [romoState setObject: DriveCommand_toString[self.lastDriveCommand] forKey:@"lastDriveCommand"];
    
    [romoState setObject:[NSNumber numberWithBool:self.currentIsDriving] forKey:@"isDriving"];
    
    [romoState setObject:[NSNumber numberWithBool:self.lastIsDriving] forKey:@"lastIsDriving"];
    
    [romoState setObject:[NSNumber numberWithBool:self.currentIsTilting] forKey:@"isTilting"];
    
    [romoState setObject:[NSNumber numberWithBool:self.lastIsTilting] forKey:@"lastIsTilting"];
    
    [romoState setObject:[NSNumber numberWithBool:self.currentIsDrivable] forKey:@"isDrivable"];
    
    [romoState setObject:[NSNumber numberWithBool:self.lastIsDrivable] forKey:@"lastIsDrivable"];
    
    [romoState setObject:[NSNumber numberWithBool:self.currentIsHeadTiltable] forKey:@"isHeadTiltable"];
    
    [romoState setObject:[NSNumber numberWithBool:self.lastIsHeadTiltable] forKey:@"lastIsHeadTiltable"];
    
    [romoState setObject: [NSNumber numberWithFloat:batteryLevel] forKey:@"batteryLevel"];
    
    return romoState;
}

- (NSMutableDictionary *) buildRomoJsonData: (NSDictionary *) dateTimeParts {
    
    // Get our gyroscope data into a dictionary
    gyros = [self getGyroData];
    accel = [self getAccelerometerData];
    
    // Get robot status & characteristics
    NSDictionary * romoState = [self getRomoState];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:10];
    [dict setObject:dateTimeParts forKey:@"datetime"];
    [dict setObject:gyros forKey:@"gyroscope"];
    [dict setObject:accel forKey:@"accelerometer"];
    [dict setObject:romoState forKey:@"romo"];
    
    return dict;

}

- (void) sendTimedUpdate:(NSTimer *)timer
{
    NSError *error;
    
    // Final dictionary we create our json payload from
    NSData *jsonDataToSendTheServer;
    
    // Get the current time
    NSDate * timestamp = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970]];
    
    // Get the component parts
    NSDictionary * dateTimeParts = [self getDateTimeParts:&timestamp];
    
    NSMutableDictionary * dict = [self buildRomoJsonData: dateTimeParts];
    
    jsonDataToSendTheServer = [NSJSONSerialization dataWithJSONObject:dict
                                                              options:NSJSONWritingPrettyPrinted error:&error];
    
    currentTime = [NSNumber numberWithDouble:CACurrentMediaTime()];
    
    
    [self.manager sendData:jsonDataToSendTheServer
                     topic:[NSString stringWithFormat:@"%@/%@/timer/%@/%@/%@",
                            [self.defaults stringForKey:@"base"],
                            [self.defaults stringForKey:@"romoId"],
                            dateTimeParts[@"hour"],
                            dateTimeParts[@"minute"],
                            dateTimeParts[@"second"]
                            ]
                       qos:MQTTQosLevelExactlyOnce
                    retain:FALSE];
    
    NSLog(@"Data sent to %@/%@/timer/%@/%@/%@",
          [self.defaults stringForKey:@"base"],
          [self.defaults stringForKey:@"romoId"],
          dateTimeParts[@"hour"],
          dateTimeParts[@"minute"],
          dateTimeParts[@"second"]
        );
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    switch (self.manager.state) {
        case MQTTSessionManagerStateClosed:
            NSLog( @"Connection closed");
            
            break;
        case MQTTSessionManagerStateClosing:
            NSLog( @"Connection closing");
            
            break;
        case MQTTSessionManagerStateConnected:
            NSLog( @"%@", [NSString stringWithFormat:@"connected as %@-%@",
                           [self.defaults stringForKey:@"base"],
                           [self.defaults stringForKey:@"romoId"]]);
            
            [self.manager sendData:[@"Device connected" dataUsingEncoding:NSUTF8StringEncoding]
                             topic:[NSString stringWithFormat:@"%@/%@",
                                    [self.defaults stringForKey:@"base"],
                                    [self.defaults stringForKey:@"romoId"]]
                               qos:MQTTQosLevelExactlyOnce
                            retain:FALSE];
            
            break;
        case MQTTSessionManagerStateConnecting:
            NSLog( @"Connection connecting");
            
            break;
        case MQTTSessionManagerStateError:
            NSLog( @"Connection error");
            
            break;
        case MQTTSessionManagerStateStarting:
        default:
            NSLog( @"Not connected");
            
            break;
    }
}

- (void)processRobotCharacter:(NSDictionary *)characterDic {
    NSString * expression = characterDic[@"expression"];
    NSString * emotion = characterDic[@"emotion"];
    
    if (expression != nil)
        [self.Romo setExpression: [RMCharacter mapReadableNameToExpression:expression]];
    
    if (emotion != nil)
        [self.Romo setEmotion: [RMCharacter mapReadableNameToEmotion:emotion]];
}

- (void)parseChangeCharacterJSON:(id)object {
    
    if([object isKindOfClass:[NSArray class]]){
        for (int item = 0; item < [object count]; item++){
            
            if ([object[item] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = object[item];
                
                [self processRobotCharacter:dic];
            }
        }
    } else if([object isKindOfClass:[NSDictionary class]]){
        NSDictionary * dic = object;
            
        [self processRobotCharacter:dic];
        
    }
}

- (void)processDriveCommand:(NSDictionary *)commandDic {
    
    NSString * command = nil;
    NSDictionary * paramDic = nil;
    
    NSNumber * paramSpeed = nil;
    NSNumber * paramRadius = nil;
    NSNumber * paramAngle = nil;
    NSNumber * paramHeading = nil;
    NSNumber * paramDuration = nil;
    
    BOOL paramForceShortestTurn = true;
    
    //NSString * finishingAction = nil; // StopDriving, DriveForward, DriveBackward
    
    if (commandDic[@"driveForwardWithSpeed"] != nil) {
        command = @"driveForwardWithSpeed";
        
        //Get parameter dictionary
        paramDic = commandDic[@"driveForwardWithSpeed"];
        
        //Get parameters
        paramSpeed = paramDic[@"speed"];
        paramDuration = paramDic[@"duration"];
        
    } else if (commandDic[@"driveBackwardWithSpeed"] != nil) {
        command = @"driveBackwardWithSpeed";
        
        //Get parameter dictionary
        paramDic = commandDic[@"driveBackwardWithSpeed"];
        
        //Get parameters
        paramSpeed = paramDic[@"speed"];
        paramDuration = paramDic[@"duration"];
        
    } else if (commandDic[@"driveWithRadius"] != nil) {
        command = @"driveWithRadius";
        
        //Get parameter dictionary
        paramDic = commandDic[@"driveWithRadius"];
        
        //Get parameters
        paramRadius = paramDic[@"radius"];
        paramSpeed = paramDic[@"speed"];
        
        paramDuration = paramDic[@"duration"];
        
    } else if (commandDic[@"turnByAngle"] != nil) {
        command = @"turnByAngle";
        
        //Get parameter dictionary
        paramDic = commandDic[@"turnByAngle"];
        
        //Get parameters
        paramRadius = paramDic[@"radius"];
        paramAngle = paramDic[@"angle"];
        
        //Optional param
        paramSpeed = paramDic[@"speed"];
        paramDuration = paramDic[@"duration"];
        //finishingAction
        //paramCompletion = paramDic[@"onCompletion"];
        
    }  else if (commandDic[@"turnToHeading"] != nil) {
        
        command = @"turnToHeading";
        
        //Get parameter dictionary
        paramDic = commandDic[@"turnToHeading"];
        
        //Get parameters
        paramRadius = paramDic[@"radius"];
        paramHeading = paramDic[@"heading"];
        
        //Optional param
        paramSpeed = paramDic[@"speed"];
        paramForceShortestTurn = paramDic[@"forceShortestTurn"];
        paramDuration = paramDic[@"duration"];
        //paramForceShortestTurn = paramDic[@"forceShortestTurn"];
        //finishingAction
        //paramCompletion = paramDic[@"onCompletion"];
        
    } else {
        
        command = @"stopDriving";
        
    }
    
    //Limit the duration when at speed
    if (paramSpeed.floatValue > 0.0f && paramDuration.floatValue > 1.0f){
        paramDuration = @(1.0f);
    }
    
    if ([command isEqualToString:@"driveForwardWithSpeed"]) {
        [self.robot driveForwardWithSpeed:[paramSpeed floatValue]];
    } else if ([command isEqualToString:@"driveBackwardWithSpeed"]) {
        [self.robot driveBackwardWithSpeed:[paramSpeed floatValue]];
    } else if ([command isEqualToString:@"driveWithRadius"]) {
        [self.robot driveWithRadius:[paramRadius floatValue] speed:[paramSpeed floatValue]];
    } else if ([command isEqualToString:@"turnByAngle"]) {
        if (paramSpeed != nil) {
            [self.robot turnByAngle:[paramAngle floatValue]
                         withRadius:[paramRadius floatValue]
                              speed:[paramSpeed floatValue]
                    finishingAction:RMCoreTurnFinishingActionStopDriving
                         completion:^(BOOL success, float heading) {
                             [self processCompletionEvent:success heading:heading];
                         }];
        } else {
            [self.robot turnByAngle:[paramAngle floatValue]
                         withRadius:[paramRadius floatValue]
                    finishingAction:RMCoreTurnFinishingActionStopDriving
                         completion: ^(BOOL success, float heading) {
                             [self processCompletionEvent:success heading:heading];
                         }];

        }
    } else if ([command isEqualToString:@"turnToHeading"]) {
        if (paramSpeed != nil ) {
            [self.robot turnToHeading:[paramHeading floatValue]
                           withRadius:[paramRadius floatValue]
                                speed:[paramSpeed floatValue]
                    forceShortestTurn:(BOOL)paramForceShortestTurn
                      finishingAction:RMCoreTurnFinishingActionStopDriving
                           completion:^(BOOL success, float heading) {
                               [self processCompletionEvent:success heading:heading];
                           }];

        } else {
            [self.robot turnToHeading:[paramHeading floatValue]
                           withRadius:[paramRadius floatValue]
                      finishingAction:RMCoreTurnFinishingActionStopDriving
                           completion:^(BOOL success, float heading) {
                               [self processCompletionEvent:success heading:heading];
                           }];

        }
    }
    
    // Start timer unless the radius is zero and turning to take stop driving after 1 second
    if (([command isEqualToString :@"driveWithRadius"] || [command isEqualToString :@"turnByAngle"] || [command isEqualToString :@"turnToHeading"])  && ([paramRadius floatValue] == 0.0)) {
        NSLog(@"Performing a turn with a radius of 0.");
    } else {
        //If not executing a turn or if the radius isn't zero limit movement with a timer
        driveTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self selector:@selector(stopRomoDriving:) userInfo:nil repeats:NO];
    }
    
}

- (void)processCompletionEvent:(BOOL) sucess heading:(float)heading {
    NSLog(@"Movement completed.");
}
 
- (void)stopRomoDriving: (NSTimer *)timer{
    [self.Romo3 stopDriving];
    
    // Remove the timer
    [timer invalidate];
    timer = nil;
}

- (void)parseDriveCommandJSON:(id)object {
    
    if([object isKindOfClass:[NSArray class]]){
        for (int item = 0; item < 1; item ++) { //}[object length]; item++){
            
            if ([object[item] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = object[item];
                
                [self processDriveCommand:dic];
            }
        }
    } else if([object isKindOfClass:[NSDictionary class]]){
        NSDictionary * dic = object;
        
        [self processDriveCommand:dic];
        
    }
}

/*
 * MQTTSessionManagerDelegate
 */
- (void)handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained {
    /*
     * MQTTClient: process received message
     */
    
    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:data
                     options:0
                     error:&error];
        
        if(error) {
            /* JSON was malformed, act appropriately here */
            NSLog(@"Malformed command received: %@",data);
        }
        
        // the originating poster wants to deal with dictionaries;
        // assuming you do too then something like this is the first
        // validation step:
        
        if([topic hasSuffix:@"character"])
        {
            [self parseChangeCharacterJSON:object];
        } else if([topic hasSuffix:@"drive"])
        {
            [self parseDriveCommandJSON:object];
        }
    }
}

- (void)setupNotificationObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"RMCoreRobotDriveSpeedDidChangeNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"RMCoreRobotHeadTiltSpeedDidChangeNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"RMBumpDetected"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"RMBumpCleared"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"RMInerialStasisDetected"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"RMInertialStasisCleared"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"RMVisualStasisDetected"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"visualStasisCleared"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"RMStasisDetected"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"RMStasisCleared"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"RMCharacterDidFinishExpressingNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"RMCharacterDidBeginExpressingNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"RMCharacterDidFinishAudioNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"RMCharacterDidBeginAudioNotification"
                                               object:nil];
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [RMCore setDelegate:self];
    
    // Grab a shared instance of the Romo character
    self.Romo = [RMCharacter Romo];
    
    //self.mqttSettings = [NSDictionary dictionaryWithContentsOfURL:mqttPlistUrl];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    // Start timer to push latest events over the bus
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                     target:self selector:@selector(sendTimedUpdate:) userInfo:nil repeats:YES];
    
    if (!self.manager) {
        self.manager = [[MQTTSessionManager alloc] init];
        self.manager.delegate = self;
        
        NSString *keyArray[2];
        NSNumber *valueArray[2];
        
        keyArray[0] = [NSString stringWithFormat:@"%@/%@/command/#",
                       [self.defaults stringForKey:@"base"],
                       [self.defaults stringForKey:@"romoId"]
                       ];
        valueArray[0] = [NSNumber numberWithInt:MQTTQosLevelExactlyOnce];
        
        keyArray[1] = [NSString stringWithFormat:@"%@/all/command/#",
                       [self.defaults stringForKey:@"base"]
                       ];
        valueArray[1] = [NSNumber numberWithInt:MQTTQosLevelExactlyOnce];
    
        self.manager.subscriptions = [NSDictionary dictionaryWithObjects:(id *)valueArray
                                                                 forKeys: (id *)keyArray count: 2];
        
        [self.manager connectTo:[self.defaults stringForKey:@"host"]
                           port:[self.defaults integerForKey:@"port"]
                            tls:[self.defaults boolForKey:@"tls"]
                      keepalive:60
                          clean:true
                           auth:true
                           user:[self.defaults stringForKey:@"username"]
                           pass:[self.defaults stringForKey:@"password"]
                      willTopic:[NSString stringWithFormat:@"%@/%@/will/",
                                 [self.defaults stringForKey:@"base"],
                                 [self.defaults stringForKey:@"romoId"]
                            ]
                           will:[@"offline" dataUsingEncoding:NSUTF8StringEncoding]
                        willQos:MQTTQosLevelExactlyOnce
                 willRetainFlag:FALSE
                   withClientId:nil];
    } else {
        [self.manager connectToLast];
    }
    
    [self.manager addObserver:self
                   forKeyPath:@"state"
                      options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                      context:nil];
    
    [self setupNotificationObservers];
    
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 1.0 / 60.0 ; // 60 Hz
    [motionManager startDeviceMotionUpdates];
    
    motionManager.accelerometerUpdateInterval = 1.0 / 60.0 ; // 60 Hz
    [motionManager startAccelerometerUpdates];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Add Romo's face to self.view whenever the view will appear
    [self.Romo addToSuperview:self.view];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Removing Romo from the superview stops animations and sounds
    [self.Romo removeFromSuperview];
}


#pragma mark -- Touch Events --

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInView:self.view];
    [self lookAtTouchLocation:touchLocation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInView:self.view];
    [self lookAtTouchLocation:touchLocation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.Romo lookAtDefault];

    // Constants for the number of expression & emotion enum values
    int numberOfExpressions = 33;
    int numberOfEmotions = 10;

    // Choose a random expression from 1 to numberOfExpressions
    RMCharacterExpression randomExpression = 1 + (arc4random() % numberOfExpressions);
    
    // Choose a random expression from 1 to numberOfEmotions
    RMCharacterEmotion randomEmotion = 1 + (arc4random() % numberOfEmotions);
    
    [self.Romo setExpression:randomExpression withEmotion:randomEmotion];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Tell Romo to reset his eyes
    [self.Romo lookAtDefault];
}

#pragma mark -- Private Methods --

- (void)lookAtTouchLocation:(CGPoint)touchLocation
{
    // Maxiumum distance from the center of the screen = half the width
    CGFloat w_2 = self.view.frame.size.width / 2;
    
    // Maximum distance from the middle of the screen = half the height
    CGFloat h_2 = self.view.frame.size.height / 2;
    
    // Ratio of horizontal location from center
    CGFloat x = (touchLocation.x - w_2)/w_2;

    // Ratio of vertical location from middle
    CGFloat y = (touchLocation.y - h_2)/h_2;
    
    // Since the touches are on Romo's face, they 
    CGFloat z = 0.0;
    
    // Romo expects a 3D point
    // x and y between -1 and 1, z between 0 and 1
    // z controls how far the eyes diverge
    // (z = 0 makes the eyes converge, z = 1 makes the eyes parallel)
    RMPoint3D lookPoint = RMPoint3DMake(x, y, z);
    
    // Tell Romo to look at the point
    // We don't animate because lookAtTouchLocation: runs at many Hertz
    [self.Romo lookAtPoint:lookPoint animated:NO];

}

- (void) receiveNotification:(NSNotification *) notification
{
    NSError *error;
    
    // Final dictionary we create our json payload from
    NSData *jsonDataToSendTheServer;
    
    // Get the current time
    NSDate * timestamp = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970]];
    
    // Get the component parts
    NSDictionary * dateTimeParts = [self getDateTimeParts:&timestamp];
    
    NSMutableDictionary * dict = [self buildRomoJsonData: dateTimeParts];
    
    jsonDataToSendTheServer = [NSJSONSerialization dataWithJSONObject:dict
                                                              options:NSJSONWritingPrettyPrinted error:&error];
    
    currentTime = [NSNumber numberWithDouble:CACurrentMediaTime()];
    
    
    [self.manager sendData:jsonDataToSendTheServer
                     topic:[NSString stringWithFormat:@"%@/%@/event/%@",
                            [self.defaults stringForKey:@"base"],
                            [self.defaults stringForKey:@"romoId"],
                            [notification name]
                            ]
                       qos:MQTTQosLevelExactlyOnce
                    retain:FALSE];
    
    NSLog(@"Data sent to %@/%@/%@",
                    [self.defaults stringForKey:@"base"],
                    [self.defaults stringForKey:@"romoId"],
                    [notification name]
                );
    
}

- (void) sendDebugMessage:(NSString *) message {
    [self.manager sendData:[message dataUsingEncoding:NSUTF8StringEncoding]
                     topic:[NSString stringWithFormat:@"%@/%@/debug",
                            [self.defaults stringForKey:@"base"],
                            [self.defaults stringForKey:@"romoId"]
                            ]
                       qos:MQTTQosLevelExactlyOnce
                    retain:FALSE];
    
    NSLog(@"Data sent to %@/%@/debug",
          [self.defaults stringForKey:@"base"],
          [self.defaults stringForKey:@"romoId"]
          );
}

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)robotDidConnect:(RMCoreRobot *)robot {
    // Currently the only kind of robot is Romo3, so this is just future-proofing
    if ([robot isKindOfClass:[RMCoreRobotRomo3 class]]) {
        self.Romo3 = (RMCoreRobotRomo3 *)robot;
        
        // Change Romo's LED to be solid at 80% power
        [self.Romo3.LEDs setSolidWithBrightness:0.8];
        
    }
    
    if (robot.isDrivable && robot.isHeadTiltable && robot.isLEDEquipped) {
        [self sendDebugMessage:@"robotDidConnect"];
        self.robot = (RMCoreRobot<HeadTiltProtocol, DriveProtocol, LEDProtocol> *) robot;
    }
}

- (void)robotDidDisconnect:(RMCoreRobot *)robot {
    if (robot == self.robot) {
        [self sendDebugMessage:@"robotDidDisconnect"];
        self.robot = nil;
    }
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    //
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    //
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    //
}

//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    //
//}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    //
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    //
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    //
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    //
}

- (void)setNeedsFocusUpdate {
    //
}

//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    //
//    return true;
//}

- (void)updateFocusIfNeeded {
    //
}

@end
