//
//  IQDropDownTextField+IQDropDownTextField_Internal.h
//  IQDropDownTextField
//
//  Created by Iftekhar on 12/19/23.
//

#import "IQDropDownTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface IQDropDownTextField (Internal)

-(void)_setSelectedItem:(nullable NSString *)selectedItem animated:(BOOL)animated shouldNotifyDelegate:(BOOL)shouldNotifyDelegate;

@end

NS_ASSUME_NONNULL_END
