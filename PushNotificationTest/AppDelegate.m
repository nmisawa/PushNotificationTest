//
//  AppDelegate.m
//  PushNotificationTest
//
//  Created by Noriaki Misawa on 2015/03/16.
//  Copyright (c) 2015年 MISAWA.NET. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [self registerUserNotificationSettings:application];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self sendLocalNotificationForMessage:@"TEST"];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // プッシュ通知が利用不可であればerrorが返ってくる
    NSLog(@"error: %@", error);
}

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo))reply
{
}


- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {

    if ([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]) {
        // ...
    } else if ([identifier isEqualToString:@"DECLINE_IDENTIFIER"]) {
        // ...
    }
    
    
    if (completionHandler) {
        completionHandler();
    }


}
    
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    if ([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]) {
        // ...
    } else if ([identifier isEqualToString:@"DECLINE_IDENTIFIER"]) {
        // ...
    }
    
    
    if (completionHandler) {
        completionHandler();
    }
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    // user has allowed receiving user notifications of the following types
//    [application registerForRemoteNotifications];
}

// Notificationの設定
- (void)registerUserNotificationSettings:(UIApplication *)application
{
    // Actionの生成
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.authenticationRequired = NO;
    acceptAction.destructive = NO;
    
    // Actionの生成
    UIMutableUserNotificationAction *declineAction = [[UIMutableUserNotificationAction alloc] init];
    declineAction.identifier = @"DECLINE_IDENTIFIER";
    declineAction.title = @"Decline";
    declineAction.activationMode = UIUserNotificationActivationModeBackground;
    declineAction.authenticationRequired = NO;
    declineAction.destructive = NO;
    
    // Categoryの作成
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    inviteCategory.identifier = @"INVITE_CATEGORY"; // CategoryのIDを設定
    [inviteCategory setActions:@[acceptAction, declineAction] forContext:UIUserNotificationActionContextDefault]; // ダイアログ表示
    [inviteCategory setActions:@[acceptAction, declineAction] forContext:UIUserNotificationActionContextMinimal]; // バナー表示
    
//    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:[NSSet setWithObject:inviteCategory]];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}

// LocalNotificationを送信
- (void)sendLocalNotificationForMessage:(NSString *)message
{
    UILocalNotification *localNotification = [UILocalNotification new];
    localNotification.category = @"INVITE_CATEGORY"; // Action表示させたいCategoryの設定
    localNotification.alertBody = message;
    localNotification.fireDate = [NSDate date];
    localNotification.timeZone = [NSTimeZone localTimeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
