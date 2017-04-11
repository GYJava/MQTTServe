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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
    
    transport.host = @"localhost";
    transport.port = 8088;
    
    
    self.mySession = [[MQTTSession alloc] init];
//    _mySession.willTopic = @""
    self.mySession.transport = transport;
    [self.mySession setUserName:@"test"];
    [self.mySession setPassword:@"zgy"];
    _mySession.delegate = self;
    _mySession.clientId = @"12311";
    
    //会话连接并设置超时时间
    BOOL isSuccess = [_mySession connectAndWaitTimeout:30];
    
    
//    _mySession.willTopic = @"";
    if (isSuccess) {

        [_mySession subscribeToTopic:@"topic" atLevel:0 subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
            
            if (error) {
                
                NSLog(@"Subscription failed %@", error.localizedDescription);
                
            } else {
                
                NSLog(@"Subscription sucessfull! Granted Qos: %@", gQoss);
                
            }
            
        }];
    }
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)sendData:(id)sender {
    
//    [_mySession disconnect];
    
//    NSData *data = [[NSData alloc] initWithBase64EncodedString:@"abcdefgdhwahduwahdaudauwhdua" options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *data = [@"a" dataUsingEncoding:NSUTF8StringEncoding];
    
    //取消自我订阅
    [_mySession publishAndWaitData:data
                        onTopic:@"$client/12311"
                         retain:NO
                            qos:MQTTQosLevelAtLeastOnce];
    

    
}


- (BOOL)newMessageWithFeedback:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
    
    
    return YES;
}


//接受数据
- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
    
//     NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
}

- (void)sending:(MQTTSession *)session type:(MQTTCommandType)type qos:(MQTTQosLevel)qos retained:(BOOL)retained duped:(BOOL)duped mid:(UInt16)mid data:(NSData *)data
{
    NSLog(@"=============");
}

- (void)connected:(MQTTSession *)session
{
    NSLog(@"已连接");
    [_mySession unsubscribeTopic:@"$client/1231111"];
}

- (void)connectionClosed:(MQTTSession *)session
{
    NSLog(@"已关闭");
    [_mySession connectAndWaitTimeout:30];
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
    
    BytePtr bytes = (BytePtr)[data bytes];
    
    NSLog(@"bytes:%s",bytes);
    
    NSLog(@"received:+%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
