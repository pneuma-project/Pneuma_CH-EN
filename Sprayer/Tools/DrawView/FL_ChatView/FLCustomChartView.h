//
//  FLCustomChartView.h
//  Sprayer
//
//  Created by fanglin on 2020/3/18.
//  Copyright © 2020 FangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLCustomChartView : UIView

//@property (nonatomic, assign) NSInteger numOfX;

/** Y轴坐标数据 */
@property (nonatomic, strong) NSArray *dataArrOfY;
/** X轴坐标数据 */
@property (nonatomic, strong) NSArray *dataArrOfX;
/** y轴数据 */
@property (nonatomic,strong) NSArray *yDataArr;
/** x轴数据 */
@property (nonatomic,strong) NSArray *xDataArr;
/** X轴标题 */
@property (nonatomic, strong) UILabel *titleOfX;
/** Y轴标题 */
@property (nonatomic, strong) UILabel *titleOfY;

@property (nonatomic, copy) NSString *titleOfXStr;
@property (nonatomic, copy) NSString *titleOfYStr;

@end

NS_ASSUME_NONNULL_END
