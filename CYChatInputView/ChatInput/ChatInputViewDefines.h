//
//  ChatInputViewDefines.h
//  ChunyuClinic
//
//  Created by 高天翔 on 15/9/29.
//  Copyright © 2015年 lvjianxiong. All rights reserved.
//

#ifndef ChatInputViewDefines_h
#define ChatInputViewDefines_h

typedef NS_ENUM(NSInteger, ChatInputViewType)
{
    ChatInputViewTypePhoto  = 0x1,
    ChatInputViewTypeAlbum  = 0x1<<1,
    ChatInputViewTypeMoulde = 0x1<<2,       //模板
    ChatInputViewTypeCoupon = 0x1<<3,       //优惠券
    ChatInputViewTypeProfile    =   0x1 <<4,//多档案
    ChatInputViewTypeTopic  = 0x1<<5,       //发话题
    ChatInputViewTypeAgain  = 0x1<<6,           //复诊
    ChatInputViewTypeShowAppointment = 0x1<<7,    //显示发门诊预约
    ChatInputViewTypeAudio  = 0x1<<8,        //音频按钮
    ChatInputViewTypeSpecialService = 0x1<<9,  //特色服务
    ChatInputViewTypeAssistant  = 0x1<<10,   //转给助手
    ChatInputViewTypeProposal = 0x1<<11,     // 处方建议
};

typedef NS_ENUM(NSInteger, ChatInputViewState)
{
    ChatInputViewStateClose,        //关闭
    ChatInputViewStateRecord,       //录音
    ChatInputViewStateMore,         //更多
    ChatInputViewStateKeyboard      //显示键盘
};

#endif /* ChatInputViewDefines_h */
