//
//  ProductDetailViewController.m
//  PagingDemo
//
//  Created by Liu jinyong on 15/8/6.
//  Copyright (c) 2015年 Baidu 91. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "GoodsDescriptionViewController.h"
#import "PictureInfController.h"
#import "GoodsEvaluateController.h"

@interface ProductDetailViewController (){
    PictureInfController *contr1;
    GoodsDescriptionViewController *contr2;
    GoodsEvaluateController *contr3;

}

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.scrollView.contentSize = CGSizeMake(0, 729);

//    [self loadAllView];
//    [self.scrollView bringSubviewToFront:contr2.view];
}
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        self.scrollView=[[UIScrollView alloc]init];
        self.scrollView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//        self.scrollView.backgroundColor=[UIColor grayColor];
        [self.view addSubview:self.scrollView];
        [self.scrollView addSubview:self.segmentControl];
        
    }
    return _scrollView;
}
-(UISegmentedControl *)segmentControl
{
    if (!_segmentControl) {
         NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"图文详情",@"产品参数",@"商品评价",nil];
        self.segmentControl=[[UISegmentedControl alloc]initWithItems:segmentedArray ];
        self.segmentControl.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
        self.segmentControl.selectedSegmentIndex = 0;
        
        
        
    }
    return _segmentControl;
}

- (IBAction)segmentValueChange:(id)sender {
    
    
}
-(void)loadAllView
{
    [self loadView1];
    [self loadView2];
    [self loadView3];
//    contr1.view.hidden=YES;
//
//    contr3.view.hidden=YES;

}
-(void)loadView1
{
    contr1=[[PictureInfController alloc]initWithNibName:@"PictureInfController" bundle:nil];
    contr1.view.frame=CGRectMake(0, 30, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-30);
    [self.scrollView addSubview:contr1.view];
}
-(void)loadView2
{
    contr2=[[GoodsDescriptionViewController alloc]init];
    contr2.view.frame=CGRectMake(0, 30, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-30);
//    [contr2.view setFrame:CGRectMake(0, 30, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-30)];
    contr2.view.bounds=self.view.bounds;
    NSLog(@"%f %f",contr2.view.bounds.size.width,contr2.view.bounds.size.height);
      [contr2.view setAutoresizesSubviews:YES];
    [self.scrollView addSubview:contr2.view];
}
-(void)loadView3
{
    contr3=[[GoodsEvaluateController alloc]init];
    contr3.view.frame=CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-30);
    [self.scrollView addSubview:contr3.view];
}
@end
