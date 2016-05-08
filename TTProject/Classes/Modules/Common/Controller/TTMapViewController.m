//
//  TTMapViewController.m
//  TTProject
//
//  Created by Ivan on 16/5/5.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TTMapViewController.h"
#import "OverwatchViewController.h"

@interface TTMapViewController ()<MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation TTMapViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = Color_White;
    
    [self addNavigationBar];
    
    self.title = @"瞭望";
    
    //初始化检索对象
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    [self render];
    
}

#pragma mark - Override Methods

- (void)addNavigationBar
{
    [super addNavigationBar];
    
    UIImage *okImage = [UIImage imageNamed:@"icon_nav_ok"];
    UIButton *okButton = [UIButton rightBarButtonWithImage:okImage highlightedImage:okImage target:self action:@selector(handleOKButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightBarButton:okButton];
    
}

#pragma mark - Private Methods

- (void) render {
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT)];
    self.mapView.delegate = self;
//    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
    self.mapView.rotateEnabled = NO;
    self.mapView.showsCompass = NO;
    [self.view addSubview:self.mapView];
    
    
    self.locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_map_location"]];
    self.locationImageView.centerX = SCREEN_WIDTH / 2;
    self.locationImageView.bottom = ( SCREEN_HEIGHT - NAVBAR_HEIGHT ) / 2 + NAVBAR_HEIGHT;
    [self.view addSubview:self.locationImageView];
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction
{
    self.centerCoordinate = mapView.centerCoordinate;
    DBG(@"center latitude : %f,longitude: %f",mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude);
}

#pragma mark - Event Response

- (void)handleOKButton
{
    DBG(@"handleOKButton");
    
    //构造AMapReGeocodeSearchRequest对象
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:self.centerCoordinate.latitude longitude:self.centerCoordinate.longitude];
    regeoRequest.radius = 0;
    regeoRequest.requireExtension = YES;
    
    //发起逆地理编码
    [self.search AMapReGoecodeSearch: regeoRequest];
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil && response.regeocode.aois && response.regeocode.aois.count > 0)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        DBG(@"ReGeo: %@", ((AMapAOI *)response.regeocode.aois[0]).name);
        
        OverwatchViewController *vc = [[OverwatchViewController alloc] init];
        
        if( response.regeocode.aois && response.regeocode.aois.count > 0 ){
            vc.title = ((AMapAOI *)response.regeocode.aois[0]).name;
        }
        vc.country = @"中国";
        vc.latitude = self.centerCoordinate.latitude;
        vc.longitude = self.centerCoordinate.longitude;
        
        TTNavigationController *navigationController = [[ApplicationEntrance shareEntrance] currentNavigationController];
        [navigationController pushViewController:vc animated:YES];
    } else {
        [self showNotice:@"定位失败!"];
    }
}

@end
