//
//  ViewController.m
//  HTTPSocket
//
//  Created by yy on 2018/5/30.
//  Copyright © 2018年 1. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <GCDAsyncSocket.h>
#import "NSMutableData+LGAppendingData.h"

#define VA_TEXT_TYPE 1111
#define VA_IMAGE_TYPE 2222

static const char * server_ip = "自己的ip";
static const short server_port = 6969;
//自己的ip地址  192.168.xx.xxx
static NSString * server_host = @"自己的ip";
static uint16_t server_ports = 6969;

@interface ViewController ()<GCDAsyncSocketDelegate>

@property (nonatomic,assign) int clinetSocket;

@property (nonatomic,strong) GCDAsyncSocket * asySocket;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initClientSocket];
    [self connect];
    [self sendData];
}
#pragma GCDAsyncSocket 创建的

- (void)initClientSocket{
    if (!_asySocket) {
         _asySocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
}
- (void)connect{
    NSError * error;
    [_asySocket connectToHost:server_host onPort:server_ports error:&error];
    if (error) {
        NSLog(@"connect error %@",error);
    }
}
- (void)disConnect{
    [_asySocket disconnect];
}
- (void)sendData{
    NSMutableData * totalData = [NSMutableData data];
    
    NSString * str = @"hello";
    NSData * strData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    UIImage * image = [UIImage imageNamed:@"arrears.png"];
    NSData * imageData = UIImagePNGRepresentation(image);
    
    [totalData appendData:strData type:VA_TEXT_TYPE];
    [totalData appendData:imageData type:VA_IMAGE_TYPE];
    
    [_asySocket writeData:totalData withTimeout:01 tag:0];
}

#pragma GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust
completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"socket 链接成功 ");
    [_asySocket readDataWithTimeout:-1 tag:0];
}

- (void)learing{
    
    // 你要给服务器发数据，服务器给你反馈  需要走一个 服务器 和 客户端 的一个约定  HTTP协议
    // 哎  哥们 你敲门的时候 敲3下 我就知道是你 否则 我以为是老王
    // 发送的时候是用的 HTTP 协议
    
    /*
     请求头信息
     
     "Access-Control-Allow-Credentials" = false;
     "Access-Control-Allow-Headers" = "Content-Type";
     "Access-Control-Allow-Methods" = "*";
     "Access-Control-Allow-Origin" = "*";
     "Access-Control-Max-Age" = 100;
     "Cache-Control" = "no-cache";
     Connection = "keep-alive";
     "Content-Type" = "application/json;charset=UTF-8";
     Date = "Wed, 30 May 2018 08:38:13 GMT";
     Expires = "Wed, 30 May 2018 08:38:12 GMT";
     Server = nginx;
     "Transfer-Encoding" = Identity;
     
     
     
     */
    
    
    //    [self sendWithStr:@"Hello"];
    
    
    //    [self initSocket];
}

#pragma 系统Socket 创建的

- (void)initSocket{
    //第一步 创建 Socket
    /*
     第一个参数: adress_family 协议簇 AF_INET ->IPV4
     第二个参数: 数据格式 ----> SOCK_STREAM(TCP) (基于数据流)  /SOCK_DGRAM(UDP) (基于数据报文)
     第三个参数: protocol IPPROTO_TCF, 如果是0，会自定更新第二个参数，这样适合的协议
     返回
     socket
     
     */
    
    
    /**
     1: 创建socket
     参数
     domain：协议域，又称协议族（family）。常用的协议族有AF_INET、AF_INET6、AF_LOCAL（或称AF_UNIX，Unix域Socket）、AF_ROUTE等。协议族决定了socket的地址类型，在通信中必须采用对应的地址，如AF_INET决定了要用ipv4地址（32位的）与端口号（16位的）的组合、AF_UNIX决定了要用一个绝对路径名作为地址。
     type：指定Socket类型。常用的socket类型有SOCK_STREAM、SOCK_DGRAM、SOCK_RAW、SOCK_PACKET、SOCK_SEQPACKET等。流式Socket（SOCK_STREAM）是一种面向连接的Socket，针对于面向连接的TCP服务应用。数据报式Socket（SOCK_DGRAM）是一种无连接的Socket，对应于无连接的UDP服务应用。
     protocol：指定协议。常用协议有IPPROTO_TCP、IPPROTO_UDP、IPPROTO_STCP、IPPROTO_TIPC等，分别对应TCP传输协议、UDP传输协议、STCP传输协议、TIPC传输协议。
     注意：1.type和protocol不可以随意组合，如SOCK_STREAM不可以跟IPPROTO_UDP组合。当第三个参数为0时，会自动选择第二个参数类型对应的默认协议。
     返回值:
     如果调用成功就返回新创建的套接字的描述符，如果失败就返回INVALID_SOCKET（Linux下失败返回-1）
     */
    
    _clinetSocket = socket(AF_INET, SOCK_STREAM, 0);
    // 建立连接  连接服务端
    
    /*
     第一个参数: 客户端Socket
     第二个参数: 指向数据结构 scoketaddr 的指针，包括现在的ipz地址和端口号
     第三个参数: 结构体数据长度
     
     返回值:成功 0 失败 --- 错误代号
     返回值
     成功则返回0，失败返回非0，错误码GetLastError()。
     
     */
    
    struct sockaddr_in serverAddr = {0};
    // 结构体 地址大小
    serverAddr.sin_len = sizeof(serverAddr);
    //协议域 IPV4
    serverAddr.sin_family = AF_INET;
    /*
       inet_aton 是一个计算机函数，功能是将一个字符串IP地址转换为一个32位的网络序列IP地址。如果这个函数成功，函数的返回值非零，如果输入地址不正确则会返回零
     */
    //server_ip 是本机的 ip 地址
    inet_aton(server_ip, &serverAddr.sin_addr);
    
    //端口
    serverAddr.sin_port = htons(server_port);
    
    
    //2: 建立连接
    
    /**
     __uint8_t    sin_len;          假如没有这个成员，其所占的一个字节被并入到sin_family成员中
     sa_family_t    sin_family;     一般来说AF_INET（地址族）PF_INET（协议族）
     in_port_t    sin_port;         // 端口
     struct    in_addr sin_addr;    // ip
     char        sin_zero[8];       没有实际意义,只是为了　跟SOCKADDR结构在内存中对齐
     */
    
    int connectFlag = connect(_clinetSocket, (const struct sockaddr *)&serverAddr, sizeof(serverAddr));
    
    // 连接成功后 进行 数据读写操作
    
    if (!connectFlag) {
        NSLog(@"连接成功");
        
        NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(reciveMessage) object:nil];
        [thread start];
    }else{
        
        NSLog(@"连接失败");
    }
}
// 数据接收
- (void)reciveMessage{
    
    // 4. 接收数据
    /**
     参数
     1> 客户端socket
     2> 接收内容缓冲区地址
     3> 接收内容缓存区长度
     4> 接收方式，0表示阻塞，必须等待服务器返回数据
     
     返回值
     如果成功，则返回读入的字节数，失败则返回SOCKET_ERROR
     */
    
    // http 也有长连接(keep-live) 但是不用 http来搞，长连接都是通过 socket来保持一个长连接，长连接 意味着 断开的操作是可控的，而 http 本身是不可空的， http的 连接状态  是由什么标识呢？ 是由tcp的flag来标识的，
    // websocket 建立连接的时候， 是通过http来传输的，
    /*
        1.客户端的socket
        2.接受内容缓冲区域
        3.接受内容缓冲区域长度
        4.接受方式，0表示阻塞，必须等服务器返回数据
        返回值: 成功 -----> 返回读入字节数 失败 -----》 SOCKET_ERROR
     
     */
    
    char rec_msg[1024] = {0};
    while (1) {
        recv(_clinetSocket, rec_msg, sizeof(rec_msg), 0);
        printf("%s \n",rec_msg);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)doConnect{
    //1创建
    /*
     参数
     domain：    协议域，AF_INET ->IPV4
     type:       Socket 类型，SOCK_STREAM/SOCK_DGRAM
     protocol:   IPPROTO_TCF,如果是0，会自定更新第二个参数，这样适合的协议
     
     
     返回
     socket
     */
    int clinetSocket = socket(AF_INET, SOCK_STREAM, 0);
    
    
    //链接
    /*
        参数
     1> 客户端的socket
     2> 指向数据结构sockaddr的指针，其中包含目的的端口和IP地址
     3> 结构体数据长度
     
     返回值
     0 成功/其他 错误代码
     
     */
    
    struct sockaddr_in serverAddr;
    //协议域 IPV4
    serverAddr.sin_family = AF_INET;
    //端口
    serverAddr.sin_port = htons(80);
    //地址
    serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
    
    
    //在C语言开发中，经常传递一个数据的指针，还需要指定数据的长度
    
    int connResult = connect(clinetSocket, (const struct sockaddr *)&serverAddr, sizeof(serverAddr));
    
    if (connResult == 0) {
        NSLog(@"链接成功");
    }else{
        NSLog(@"链接失败");
        return;
    }
    _clinetSocket = clinetSocket;
    
}
/* Socket 演练 */
- (void)sendWithStr:(NSString *)strValue{
    //3.发送
    /*
        参数
     1> 客户端socket
     2> 发送内容地址
     3> 发送内容长度
     4> 发送方式标志，一般为0
     
     返回值
     如果成功，则返回发送数据的字节数，失败则返回SOCKET_ERROR
     
     
     */
    
    
    /**
     3: 发送消息
     s：一个用于标识已连接套接口的描述字。
     buf：包含待发送数据的缓冲区。
     len：缓冲区中数据的长度。
     flags：调用执行方式。
     
     返回值
     如果成功，则返回发送的字节数，失败则返回SOCKET_ERROR
     一个中文对应 3 个字节！UTF8 编码！
     */
    
    NSString * Msg = strValue;
    
    ssize_t sendLen = send(_clinetSocket, Msg.UTF8String, strlen(Msg.UTF8String), 0);
    NSLog(@"发送了 %ld 个字节",sendLen);
    
    //4.读
    /*
     参数
     1> 客户端Socket
     2> 接受内容缓冲区地址 提前准备
     3> 接受内容缓存长度
     4> 接受方式， 0表示阻塞 必须等待服务器返回数据
     
     返回值
     如果成功，则返回读入的字节数，失败则返回SOCKET_ERROR
     */
    
    uint8_t buffer[1024];//准备空间
    
    ssize_t recvLen = recv(_clinetSocket, buffer, sizeof(buffer), 0);
    NSLog(@"接收到了 %ld 个字节",recvLen);
    
    //获取服务器返回的数据
    NSData * data = [NSData dataWithBytes:buffer length:recvLen];
    //str
    NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"str %@",str);
    //5.关闭
    close(_clinetSocket);
}

@end
