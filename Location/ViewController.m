//
//  ViewController.m
//  Location
//
//  Created by GG on 16/3/9.
//  Copyright © 2016年 GG. All rights reserved.
//

#import "ViewController.h"
//1. 导入框架
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<CLLocationManagerDelegate>
{
    //2. 声明全局的定位管理器
    CLLocationManager *_locationManager;
    UILabel *label;
    
}
@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    
    label = [[UILabel alloc]initWithFrame:CGRectMake(50, 100, 200, 100)];
    label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    
    
    //3. 实例化定位管理器
    _locationManager = [[CLLocationManager alloc]init];
    

    
    //4. 判断当前系统是否打开定位服务,在设置->隐私里。这是能够控制手机上所有App的定位授权
    if ([CLLocationManager locationServicesEnabled] == NO) {
        
        //判断是否可以打开授权界面
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
            
            //跳转到设置页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        };

        return;
    }
    
    
    //定位授权,如果不授权
    [_locationManager requestWhenInUseAuthorization]; //使用该应用时想要授权能够定位
//     [_locationManager requestAlwaysAuthorization];   //也是授权定位，这种情况下，有时你应用没打开也会定位,如果苹果手机上有地图软件的话，你没有打开该软件，系统有时也会突然给你个提示框说某应用一直在使用定位功能，是否关闭。
    //挂上代理
    _locationManager.delegate = self;
    
    //是否使用后台定位的功能，
    _locationManager.allowsBackgroundLocationUpdates = YES;

        
    //设置定位精度
    _locationManager.desiredAccuracy = 10;
        
    //设置定位频率
    CLLocationDistance distance=1.0;//1米定位一次
    _locationManager.distanceFilter = distance;
        
    //开始追踪
    [_locationManager startUpdatingLocation];
     
        

}


#pragma  mark delegate 
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *curLoc = locations.lastObject;
    
    /*
     * 当前位置的经纬度
     *
        typedef struct {
           CLLocationDegrees latitude;
           CLLocationDegrees longitude;
        } CLLocationCoordinate2D;
     *
     */
    CLLocationCoordinate2D coordinate = curLoc.coordinate;
    NSLog(@"经度:%f 纬度:%f",coordinate.longitude,coordinate.latitude);
    
    
    //海拔高度
    NSLog(@"海拔高度:%f",curLoc.altitude);
    
    //位置的精度，位置精度通过一个圆表示，实际位置可能位于这个圆内的任何地方。这个圆是由coordinate(坐标)和horizontalAccuracy(半径)共同决定的，horizontalAccuracy的值越大，那么定义的圆就越大，因此位置精度就越低。如果horizontalAccuracy的值为负，则表明coordinate的值无效。
    NSLog(@"位置的精度:%f",curLoc.horizontalAccuracy);
    
    //海拔高度的精度。为正值表示海拔高度的误差为对应的米数；为负表示altitude(海拔高度)的值无效。
    NSLog(@"海拔的精度:%f",curLoc.verticalAccuracy);
    
    //speed — 速度。该属性是通过比较当前位置和前一个位置，并比较它们之间的时间差异和距离计算得到的。鉴于Core Location更新的频率，speed属性的值不是非常精确，除非移动速度变化很小。
    NSLog(@"行驶速度：%f",curLoc.speed);
    
    //当前定位的日期
    NSLog(@"定位日期%@",curLoc.timestamp);
    
    //得到两个位置之间的距离，通过不断累加，来获取总距离
//    [curLoc distanceFromLocation:nil];
    
    //得到两次更新的时间之间的间隔，通过累加来获取行驶总时间
//    [curLoc.timestamp timeIntervalSinceDate:lastLoc.timestamp];
    
    //floor 楼层的高度 -> level 几层
    NSLog(@"当前楼层%ld层",curLoc.floor.level);

    
    
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"定位失败%@",error);

}

@end
