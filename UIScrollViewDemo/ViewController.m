//
//  ViewController.m
//  UIScrollViewDemo
//
//  Created by zhangbin on 16/6/12.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)UIScrollView *scrollV;
@property(nonatomic,weak)UIView *BlueTopView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollV = [[UIScrollView alloc]init];
    scrollV.frame = self.view.bounds;
    [self.view addSubview:scrollV];
    // 创建5个tableView，添加到scrollV上
    for (NSInteger i = 0; i < 5; i++) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.frame = CGRectMake(i *scrollV.frame.size.width,0,scrollV.frame.size.width,scrollV.frame.size.height);
        tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
        // 不可省略。否则垂直滚动tableView的内容时,BlueTopView将不会跟随tableView移动。因为如果没有设置代理,垂直滚动tableView的内容时，就不会执行scrollViewDidScroll，就不会在代理方法中，让BlueTopView将跟随tableView移动。
          tableView.delegate = self;
        // 不可省略。数据源数据就是显示tableView内容中的cell的。没有数据源数据，就不会执行数据源方法，那么tableView内容中的cell将不会显示
        tableView.dataSource = self;
        // 将5个tableView 依次加入到scrollV中的指定位置。
        // 一定要添加到scrollV中，否则滚动scrollV的内容，scrollV的内容没有这5个tableView，我们通过UIScrollView这个窗口怎么会看到这5个tableView呢呢
        [scrollV addSubview:tableView];
    }
    // 可以滚动的内容范围
    scrollV.contentSize = CGSizeMake(5 * scrollV.frame.size.width, 0);
    scrollV.pagingEnabled = YES;
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.showsVerticalScrollIndicator = NO;
    // 不可省略。否则水平滚动scrollV的内容时，剩下4个界面的BlueTopView将不再显示。因为如果没有设置代理,水平滚动scrollV的内容时，就不会执行scrollViewDidScroll，就不会在代理方法中重新确定BlueTopView的frame了
    scrollV.delegate = self;
    self.scrollV = scrollV;
    // 只创建一个蓝色UIView
    UIView *BlueTopView = [[UIView alloc]init];
    BlueTopView.backgroundColor = [UIColor blueColor];
    BlueTopView.frame = CGRectMake(0,0,self.view.frame.size.width,100);
    // 一定要添加到控制器的view中，如果添加到了scrollView中的话，滚动scrollView的内容，BlueTopView一定也会滚动
    [self.view addSubview:BlueTopView];
    self.BlueTopView = BlueTopView;
}
// 滚动就会调用，根据水平滚动还是垂直滚动，来决定参数中的scrollView是scrollV还是tableView.
// 因为可能是scrollV，也可能是tableView，所以scrollV必须设置代理，tableView也必须设置代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
     // 如果当前滚动的是scrollV的内容，就执行{},即水平滚动就会调用
    if(scrollView == self.scrollV){
        // 拿到下标index
        NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
        // 根据index取出scrollV中的每一个子控件tableView。目的：拿到tableView的偏移量，从而控制蓝色View的y值
        UITableView *tableView = self.scrollV.subviews[index];
        // 红色topView的y坐标由tableView的contentOffset.y决定。如果偏移量为-100，那么y坐标为0(相对于控制器的view);如果偏移量为0，那么y坐标为-100(相对于控制器的view.此时红色view完全看不见了，因为红色topView的底部紧贴屏幕顶部);如果偏移量为-50，那么y坐标为-50，此时红色topView一半在屏幕顶部的外侧，一半在屏幕顶部的内侧
        self.BlueTopView.frame = CGRectMake(0, -(tableView.contentInset.top + tableView.contentOffset.y), self.view.frame.size.width, 100);
        // 将红色topView添加到控制器的view上。目的：滚动scrollV的内容时,红色topView不会跟着scrollV移动
        [self.view addSubview:self.BlueTopView];
    }else{// 如果当前滚动的是tableView中的内容，就执行{}，即垂直滚动就会调用
        // 为什么是-100，因为tableView的第0个cell的左上角为0,0，设置为-100，那么红色topView将会无缝显示在第0个cell的上方.如果为100，将会显示在第2个cell上，亲测正确。
        self.BlueTopView.frame = CGRectMake(0, -100, self.view.frame.size.width, 100);
        // 把蓝色BlueTopView添加到tableView中，虽然下面的代码是scrollView，但是scrollView是方法的参数，本质是tableView。这样蓝色BlueTopView就会跟着tableView的滚动而滚动了，因为此时BlueTopView的父控件是tableView，所以会让TableView之前的内容向下移动，空缺的位置让蓝色的BlueTopView占据着。
        // 因为设置了tableView的顶部内间距为100,tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);所以tableView会在距控制器100像素的距离显示。因为这100像素的距离让蓝色BlueTopView占据着,所以造成了蓝色BlueTopView紧紧贴着tableView
        // 注意:蓝色BlueTopView不是tableView的内容。所以tableView的偏移量和蓝色BlueTopView没关系，只需要看第0个cell的位置.所以一开始的contentOffset.y为-100，因为tableView的原点在屏幕左上角，而tableView的内容的坐标原点就是第0个cell的位置，所以 tableView左上角的y坐标减去内容左上角的y坐标:0-100=-100.
        NSLog(@"%lf",scrollView.contentOffset.y);

        [scrollView addSubview:self.BlueTopView];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 20;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *Identifier = @"EveryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%zd个cell",indexPath.row];
    return cell;
}


@end
