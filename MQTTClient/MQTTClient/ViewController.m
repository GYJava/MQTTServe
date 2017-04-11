//
//  ViewController.m
//  MQTTClient
//
//  Created by zhuguangyang on 2017/4/1.
//  Copyright © 2017年 GYJade. All rights reserved.
//

#import "ViewController.h"
#import<MQTTClient/MQTTClient.h>


@interface ViewController () <MQTTSessionDelegate>


@property (nonatomic,strong) MQTTSession *mySession;

@end

@implementation ViewController

typedef struct _name
{
    char *Strname;
}*Lname;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
    
    transport.host = @"localhost";
    transport.port = 8088;
    
    self.mySession = [[MQTTSession alloc] init];
    self.mySession.transport = transport;
//    [self.mySession setUserName:@"test"];
//    [self.mySession setPassword:@"test"];
    _mySession.delegate = self;
    _mySession.clientId = @"1231";
    
    //会话连接并设置超时时间
    BOOL isSuccess = [_mySession connectAndWaitTimeout:30000];
    
//    _mySession.willTopic = @"";
//    if (isSuccess) {
    
    
    
//        [_mySession subscribeToTopic:@"$client/MQTTClient710371" atLevel:0 subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
//            
//            if (error) {
//                
//                NSLog(@"Subscription failed %@", error.localizedDescription);
//                
//            } else {
//                
//                NSLog(@"Subscription sucessfull! Granted Qos: %@", gQoss);
//                
//            }
//            
//        }];
//    }
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)sendData:(id)sender {
    
//    [_mySession disconnect];
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:@"我就问你帅不我就问你帅不帅我就问你帅不帅我就问你帅不帅我就问你帅不帅我就问你帅不帅我就问你帅不帅帅" options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    [_mySession publishAndWaitData:data
                        onTopic:@"topic"
                         retain:NO
                            qos:MQTTQosLevelAtLeastOnce];
    
}


- (BOOL)newMessageWithFeedback:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
    NSLog(@"newMessageWithFeedback%@",data);
    
    BytePtr bytes = (BytePtr)[data bytes];
    
    Lname name = (Lname)bytes;
//    NSString *str = ;
    
//    NSLog(@"%s",name->Strname);
//    NSString *str = [[NSString alloc] initWithBytes:(BytePtr)(bytes+1) length: encoding:NSASCIIStringEncoding];
    
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF16StringEncoding]);
    return YES;
}


//接受数据
- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
    
    NSLog(@"%@",data);
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    
//    NSString *jsonStr = [NSString stringWithUTF8String:data.bytes];
//    NSLog(@"%@",jsonStr);
//     NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]);
    
}

- (void)sending:(MQTTSession *)session type:(MQTTCommandType)type qos:(MQTTQosLevel)qos retained:(BOOL)retained duped:(BOOL)duped mid:(UInt16)mid data:(NSData *)data
{
    NSLog(@"=============");
}

- (void)connected:(MQTTSession *)session
{
    NSLog(@"已连接");
    [_mySession subscribeToTopic:@"$client/12311" atLevel:0 subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
        
        if (error) {
            
            NSLog(@"Subscription failed %@", error.localizedDescription);
            
        } else {
            
            NSLog(@"Subscription sucessfull! Granted Qos: %@", gQoss);
            
        }
        
    }];
}

- (void)connectionClosed:(MQTTSession *)session
{
    NSLog(@"已关闭");
    [_mySession connectAndWaitTimeout:30000];
}

- (void)connectionError:(MQTTSession *)session error:(NSError *)error
{
    NSLog(@"连接错误");
}

- (void)connectionRefused:(MQTTSession *)session error:(NSError *)error
{
    NSLog(@"已拒绝");
}

- (void)connected:(MQTTSession *)session sessionPresent:(BOOL)sessionPresent
{
    NSLog(@"未知");
}

- (void)subAckReceived:(MQTTSession *)session msgID:(UInt16)msgID grantedQoss:(NSArray<NSNumber *> *)qoss
{
    NSLog(@"服务器 subAck");
}

- (void)received:(MQTTSession *)session type:(MQTTCommandType)type qos:(MQTTQosLevel)qos retained:(BOOL)retained duped:(BOOL)duped mid:(UInt16)mid data:(NSData *)data
{
    NSLog(@"received:+%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}


/**
 连接状态的回调

 @param session session description
 @param eventCode eventCode description
 @param error error description
 */
- (void)handleEvent:(MQTTSession *)session event:(MQTTSessionEvent)eventCode error:(NSError *)error {
    
    switch (eventCode) {
        case MQTTSessionEventConnected:
            
            NSLog(@"mqtt connect Succesed");
            
            break;
        case MQTTSessionEventConnectionError:
            NSLog(@"connect error %@",error.localizedDescription);
            
            // [deviceSession connect];
            break;
        case MQTTSessionEventConnectionRefused:
            NSLog(@"mqtt connect refused");
            break;
        case MQTTSessionEventConnectionClosed:
            NSLog(@"connect Closed");
            break;
        case MQTTSessionEventProtocolError:
            NSLog(@"protocol Error");
            
            break;
        default:
            break;
            
            
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
