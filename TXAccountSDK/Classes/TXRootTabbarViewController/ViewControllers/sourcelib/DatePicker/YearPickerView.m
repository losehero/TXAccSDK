//
//  YearPickerView.m
//  BOEFace
//
//  Created by 牛严 on 15/7/13.
//  Copyright (c) 2015年 缪宇青. All rights reserved.
//

#import "YearPickerView.h"
#define kMainProjColor     [UIColor colorWithRed:92.0/255.0 green:93.0/255.0 blue:103.0/255.0 alpha:1]

@interface YearPickerView ()
@property(strong,nonatomic)NSCalendar *calendar;
@property(strong,nonatomic)NSDate *selectDate;
@property(strong,nonatomic)NSDate *startDate;
@property(strong,nonatomic)NSDate *endDate;
@property(strong,nonatomic)NSDate *chosenDate;
@property(strong,nonatomic)NSDateComponents *startCpts;
@property(strong,nonatomic)NSDateComponents *endCpts;
@property NSString *startHour;
@property NSString *chosenHour;
@property NSInteger years;
@end

@implementation YearPickerView

#pragma mark - Private Methods

- (NSDateComponents *)dateComponent
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    return dateComponent;
}


-(void)loadDate{
    self.calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.startDate = [dateFormatter dateFromString:@"1900-01-01"];
    self.endDate = [dateFormatter dateFromString:@"2030-12-30"];
    self.startCpts = [self.calendar components:NSCalendarUnitYear
                                      fromDate:self.startDate];
    self.endCpts = [self.calendar components:NSCalendarUnitYear fromDate:self.endDate];
    [dateFormatter setDateFormat:@"yyyy"];
    self.startHour = @"00";
    self.chosenHour = [NSString stringWithFormat:@"%td",[[self dateComponent] hour]];
}

-(void)loadWithChosenDate:(NSDate *)Date{
    self.chosenDate = Date;
    [self loadDate];
    self.delegate = self;
    self.dataSource = self;
    NSInteger gapYears = [[self dateComponent] hour];
    [self selectRow:gapYears inComponent:0 animated:NO];
    [self reloadAllComponents];
}

-(void)loadWithChosenHour:(NSInteger)hour
{
    [self loadDate];
    self.delegate = self;
    self.dataSource = self;
    NSInteger gapYears = hour;
    [self selectRow:gapYears inComponent:0 animated:NO];
    [self reloadAllComponents];
}


#pragma mark - UIView Methods
-(void)awakeFromNib{
    [super awakeFromNib];
}

#pragma mark - UIPickerView DataSource Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    self.years = 24;
    return self.years;
}

#pragma mark - UIPickerView Delegate Methods
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view{
    UILabel *dateLabel = (UILabel *)view;
    dateLabel = [[UILabel alloc] init];
    [dateLabel setTextColor:kMainProjColor];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    
    NSString *hour = @"";
    
    if (row < 10)
    {
        hour = [NSString stringWithFormat:@"0%td",row];
    }
    else
    {
        hour = [NSString stringWithFormat:@"%td",row];
    }
    
    [dateLabel setText:hour];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    return dateLabel;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 70;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSInteger hour =  row;
    NSString *chosenYearString = [NSString stringWithFormat:@"%ld",(long)hour];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YearValueChanged" object:chosenYearString];
}

@end
