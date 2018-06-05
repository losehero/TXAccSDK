//
//  JSubmitBillViewController.m
//  jizhang
//
//  Created by jinlong9 on 17/1/10.
//  Copyright © 2017年 losehero. All rights reserved.
//

#import "JSubmitBillViewController.h"
#import "MMNumberKeyboard.h"
#import "JMoneyCell.h"
#import "TXAccountManager.h"
static NSString * const kCustomRowFloatLabeledTextFieldTag = @"CustomRowFloatLabeledMoney";
NSString *const kDateInline = @"dateInline";
NSString *const KType = @"billType";
NSString *const kTextView = @"textView";
NSString *const kButton = @"SaveButon";
NSString * const kValidationName = @"kName";
@interface JSubmitBillViewController ()<MMNumberKeyboardDelegate>
@property (nonatomic,retain) MMNumberKeyboard *keyboard;
@property (nonatomic,strong) NSString *num1;
@property (nonatomic,strong) NSString *num2;
@property (nonatomic,strong) NSString *sign;
@end

@implementation JSubmitBillViewController

- (void)initializeForm
{
    // Create and configure the keyboard.
    _keyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
    _keyboard.allowsDecimalPoint = YES;
    _keyboard.delegate = self;
    
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"Custom Rows"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    // Section Ratings
    section = [XLFormSectionDescriptor formSectionWithTitle:nil];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:KType rowType:XLFormRowDescriptorTypeInfo title:@"类型"];
    row.disabled = @YES;
    row.required = YES;
    row.value = self.billList ? self.billList.bname : self.jbill.bname;
    row.height = 60;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kValidationName rowType:XLFormRowDescriptorTypeText title:@"金额"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"大于0.01的数字" regex:@"^(?!0(\\d|\\.0+$|$))\\d+(\\.\\d{1,2})?$"]];
    row.height = 60;
    [row.cellConfigAtConfigure setObject:_keyboard forKey:@"textField.inputView"];
    [row.cellConfigAtConfigure setObject:@"输入大于¥0.01的数字" forKey:@"textField.placeholder"];
    row.value = self.jbill ? [NSString stringWithFormat:@"%.2f",self.jbill.bmoney] : @"";
    row.required = YES;
    _num1 = row.value;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kDateInline rowType:XLFormRowDescriptorTypeDateInline title:@"时间"];
    row.value = self.jbill ? [self dateToDate:self.jbill.bdate] : [NSDate date];
    row.height = 60;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kTextView rowType:XLFormRowDescriptorTypeTextView];
    [row.cellConfigAtConfigure setObject:@"点击输入备注" forKey:@"textView.placeholder"];
    row.value = self.jbill ? self.jbill.bdes : nil;
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:nil];
    [form addFormSection:section];
    section = [XLFormSectionDescriptor formSectionWithTitle:nil];
    [form addFormSection:section];
    section = [XLFormSectionDescriptor formSectionWithTitle:nil];
    [form addFormSection:section];
    section = [XLFormSectionDescriptor formSectionWithTitle:nil];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kButton rowType:XLFormRowDescriptorTypeButton title:@"保存"];
    row.height = 55;
    [row.cellConfigAtConfigure setObject:[UIColor colorWithRed:252.0/255.0 green:217.0/255.0 blue:82.0/255.0 alpha:1] forKey:@"backgroundColor"];
    [row.cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.color"];
    [row.cellConfig setObject:[UIFont fontWithName:@"Helvetica" size:18] forKey:@"textLabel.font"];
    row.action.formSelector = @selector(didTouchButton:);
    [section addFormRow:row];
    
    [form addFormSection:section];
    
    self.form = form;
}


- (void)insertDataWithBname:(NSString *)bName bdate:(NSString *)bdate bMoney:(float)bMoney bdes:(NSString *)des {
    
    [[TXAccountManager accountManager].persistentContainer performBackgroundTask:^(NSManagedObjectContext * context)
     {
         JBill *jbill = (JBill *)[NSEntityDescription insertNewObjectForEntityForName:@"JBill" inManagedObjectContext:context];
         jbill.biconname = self.billList.biconname;
         jbill.bname = bName;
         jbill.bmoney = bMoney;
         jbill.bdate = bdate;
         jbill.bdes = des;
         jbill.btype = self.billList.btype;
         
         NSError *error = nil;
         if ([context save:&error])
         {
             dispatch_sync(dispatch_get_main_queue(), ^{
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"恭喜您，添加成功!"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"好的"
                                                           otherButtonTitles:nil, nil];
                 [alertView show];
                 
             });
         }
         NSLog(@"error  :%@",error);
     }];

}

- (void)updateDataWithBdate:(NSString *)bdate bMoney:(float)bMoney bdes:(NSString *)des
{
    [[TXAccountManager accountManager].persistentContainer performBackgroundTask:^(NSManagedObjectContext * context)
    {
        [self.jbill setValue:bdate forKey:@"bdate"];
        [self.jbill setValue:[NSNumber  numberWithFloat:bMoney] forKey:@"bmoney"];
        [self.jbill setValue:des forKey:@"bdes"];
        NSError *error = nil;
        if ([[TXAccountManager accountManager].persistentContainer.viewContext save:&error]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
        
    }];
}

- (void)didTouchButton:(XLFormRowDescriptor *)sender
{
    [self deselectFormRow:sender];
    NSArray * array = [self formValidationErrors];
    if (array && [array count])
    {
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            XLFormValidationStatus * validationStatus = [[obj userInfo] objectForKey:XLValidationStatusErrorKey];
            if ([validationStatus.rowDescriptor.tag isEqualToString:kValidationName]){
                UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:validationStatus.rowDescriptor]];
                [self animateCell:cell];
                return ;
            }
        }];
        
    }
    else
    {
        XLFormSectionDescriptor * section = [self.form.formSections firstObject];
        NSString *bName = nil;
        float bMoney = 0.00;
        NSString *date = nil;
        NSString *des = @"";
        for (XLFormRowDescriptor *row in  section.formRows)
        {
            if ([row.tag isEqualToString:KType]) //账单类型
            {
                bName = row.value;
            }
            else if ([row.tag isEqualToString:kValidationName]) //金额
            {
                row.value = [[row.value stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@"+" withString:@""];
                bMoney = [row.value floatValue];
                
            }
            else if([row.tag isEqualToString:kDateInline]) //账单时间
            {
                date = [self stringToDate:row.value];
            }
            else if([row.tag isEqualToString:kTextView]) //还款方式
            {
                des = row.value;
            }
        }
        
        if (_billList)
        {
            [self insertDataWithBname:bName
                                bdate:date
                               bMoney:bMoney
                                 bdes:des];
        }
        else if (_jbill)
        {
            [self updateDataWithBdate:date
                               bMoney:bMoney
                                 bdes:des];
            
        }
        
        NSLog(@"bType :%@",bName);
        NSLog(@"bMoney :%f",bMoney);
        NSLog(@"date :%@",date);
        NSLog(@"des :%@",des);
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _num1 = @"";
    _num2 = @"";
    _sign = @"";
    self.title = @"记账";
    
    [self initializeForm];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)numberKeyboardShouldReturn:(MMNumberKeyboard *)numberKeyboard
{
    // Do something with the done key if neeed. Return YES to dismiss the keyboard.
    if (_sign.length)
    {
        double num1 = [_num1 doubleValue];
        double num2 = [_num2 doubleValue];
        NSString  *localNum = nil;
        if ([_sign isEqualToString:@"+"])
        {
            localNum = [NSString stringWithFormat:@"%.2f", num1 + num2];
            [numberKeyboard updateTextWithField:localNum];
        }
        else if([_sign isEqualToString:@"-"])
        {
            localNum = [NSString stringWithFormat:@"%.2f", num1 - num2];
            [numberKeyboard updateTextWithField:localNum];
        }
        
        [numberKeyboard setReturnKeyTitle:@"完成"];
        _num1 = localNum;
        _num2 = @"";
        _sign = @"";
    }
    
    return YES;
}

- (void)numberKeyboardEqualReturn:(MMNumberKeyboard *)numberKeyboard
{
    if (_sign.length)
    {
        double num1 = [_num1 doubleValue];
        double num2 = [_num2 doubleValue];
        NSString  *localNum = nil;
        if ([_sign isEqualToString:@"+"])
        {
            localNum = [NSString stringWithFormat:@"%.2f", num1 + num2];
            [numberKeyboard updateTextWithField:localNum];
        }
        else if([_sign isEqualToString:@"-"])
        {
            localNum = [NSString stringWithFormat:@"%.2f", num1 - num2];
            [numberKeyboard updateTextWithField:localNum];
        }
        
        [numberKeyboard setReturnKeyTitle:@"完成"];
        _num1 = localNum;
        _num2 = @"";
        _sign = @"";
    }
}

- (BOOL)numberKeyboardShouldDeleteBackward:(MMNumberKeyboard *)numberKeyboard
{
    if ([_num2 length] >= 1)
    {
        int toindex = (int)_num2.length - 1;
        _num2 = [_num2 substringToIndex:toindex];
        if (!_num2.length)
        {
            [numberKeyboard setReturnKeyTitle:@"完成"];
        }
    }
    else if([_sign length] >= 1)
    {
        _sign = [_sign substringToIndex:(int)_sign.length - 1];
        [numberKeyboard setReturnKeyTitle:@"完成"];
    }
    else if([_num1 length] >= 1)
    {
        int toindex = (int)_num1.length - 1;
        _num1 = [_num1 substringToIndex:toindex];
        [numberKeyboard setReturnKeyTitle:@"完成"];
    }
    
    NSLog(@"num1  :%@",_num1);
    NSLog(@"num2  :%@",_num2);
    NSLog(@"sign  :%@",_sign);
    
    return YES;
}

- (BOOL)numberKeyboard:(MMNumberKeyboard *)numberKeyboard shouldInsertText:(NSString *)text
{
    if ([text isEqualToString:@"+"] || [text isEqualToString:@"-"])
    {
        if (_sign.length)
        {
            if (_num2.length)
            {
                float num1 = [_num1 floatValue];
                float num2 = [_num2 floatValue];
                NSString  *localNum = nil;
                if ([_sign isEqualToString:@"+"])
                {
                    localNum = [NSString stringWithFormat:@"%.2f", num1 + num2];
                    [numberKeyboard updateTextWithField:localNum];
                }
                else if([_sign isEqualToString:@"-"])
                {
                    localNum = [NSString stringWithFormat:@"%.2f", num1 - num2];
                    [numberKeyboard updateTextWithField:localNum];
                }
                _num1 = localNum;
                _num2 = @"";
                _sign = @"";
            }
            else
            {
                [numberKeyboard updateSign:text];
                _sign = text;
                return NO;
            }
            
        }
        
           _sign = text;
    }
    else
    {
        if (_sign.length)
        {
            NSArray  *array = [_num2 componentsSeparatedByString:@"."];
            
            if ([array count] >= 2)
            {
                if (((NSString *)[array lastObject]).length >= 2)
                {
                    return NO;
                }
                else
                {
                    if ([text isEqualToString:@"."] && [_num2 rangeOfString:@"."].length)
                    {
                        return NO;
                    }
                    else
                    {
                        double localNum2 = [[_num2 stringByAppendingString:text] doubleValue];
                        if (localNum2 >= 100000000)
                        {
                            return NO;
                        }
                        
                        _num2 = [_num2 stringByAppendingString:text];
                        [numberKeyboard setReturnKeyTitle:@"="];
                    }
                }
            }
            else
            {
                if ([text isEqualToString:@"."] && [_num2 rangeOfString:@"."].length)
                {
                    return NO;
                }
                else
                {
                    double localNum2 = [[_num2 stringByAppendingString:text] doubleValue];
                    if (localNum2 >= 100000000)
                    {
                        return NO;
                    }
                    _num2 = [_num2 stringByAppendingString:text];
                    [numberKeyboard setReturnKeyTitle:@"="];
                }
            }
            
        }
        else
        {
            NSArray  *array = [_num1 componentsSeparatedByString:@"."];
            if ([array count] >= 2)
            {
                if (((NSString *)[array lastObject]).length >= 2)
                {
                    return NO;
                }
                else
                {
                    if ([text isEqualToString:@"."] && [_num1 rangeOfString:@"."].length)
                    {
                        return NO;
                    }
                    else
                    {
                        double localNum1 = [[_num1 stringByAppendingString:text] doubleValue];
                        if (localNum1 >= 100000000)
                        {
                            return NO;
                        }
                        _num1 = [_num1 stringByAppendingString:text];
                    }
                    
                   
                }
            }
            else
            {
                if ([text isEqualToString:@"."] && [_num1 rangeOfString:@"."].length)
                {
                    return NO;
                }
                else
                {
                    double localNum1 = [[_num1 stringByAppendingString:text] doubleValue];
                    if (localNum1 >= 100000000)
                    {
                        return NO;
                    }
                    _num1 = [_num1 stringByAppendingString:text];
                    
                }
            }
        }
    }
 
    
    NSLog(@"num1  :%@",_num1);
    NSLog(@"num2  :%@",_num2);
    NSLog(@"sign  :%@",_sign);
    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - Helper

-(void)animateCell:(UITableViewCell *)cell
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values =  @[ @0, @20, @-20, @10, @0];
    animation.keyTimes = @[@0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.additive = YES;
    
    [cell.layer addAnimation:animation forKey:@"shake"];
}

- (NSString *)stringToDate:(NSDate *)date
{
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    return currentDateString;
}

- (NSDate *)dateToDate:(NSString *)dateStr
{
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //NSString转NSDate
    return [formatter dateFromString:dateStr];;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
