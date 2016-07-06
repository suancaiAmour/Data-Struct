//
//  main.m
//  对输入字符串表达式进行计算
//
//  Created by 张鸿 on 16/7/6.
//  Copyright © 2016年 酸菜Amour. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  运算符的优先级
 */
typedef struct pri{
    char oper;
    int operPri;
}ZHPri;
ZHPri inPir[] = {{'=', 0}, {'(', 1}, {'+', 3}, {'-', 3}, {'*', 5}, {'/', 5}, {')', 6}};
ZHPri outPir[] = {{'=', 0}, {'(', 6}, {'+', 2}, {'-', 2}, {'*', 4}, {'/', 4}, {')', 1}};

typedef enum{
    InPirBig = 0,
    equal,
    InPirSmall,
}ZHPriNum;

ZHPriNum comparePir(char inOper, char outOper)
{
    int inOperPri = 0, outOperPri = 0;
    for (int i = 0; i < 7; i++)
    {
        if (inOper == inPir[i].oper){
            inOperPri = inPir[i].operPri;
            break;
        }
    }
    
    for (int i = 0; i < 7; i++){
        if (outOper == outPir[i].oper) {
            outOperPri = outPir[i].operPri;
            break;
        }
    }
    
    if (inOperPri > outOperPri) {
        return InPirBig;
    }
    else if(inOperPri < outOperPri){
        return InPirSmall;
    }else{
        return equal;
    }
}

/**
 *  运算栈
 */
#define MAXDATANUM 100
typedef struct operInn{
    char data[MAXDATANUM];
    int top;
}ZHInn;
//初始化一个栈
void initInn(ZHInn *Inn)
{
    Inn->top = -1;
}
//数据压栈
void pushData(ZHInn *Inn, char data)
{
    Inn->top++;
    Inn->data[Inn->top] = data;
}
//数据出栈
char popData(ZHInn *Inn)
{
    char data = Inn->data[Inn->top];
    Inn->top--;
    return data;
}

char gainTopData(ZHInn*Inn)
{
    return Inn->data[Inn->top];
}


void transformExpre(char *exp, char*newExp)
{
    char *newExp1 = newExp;
    char data, data1;
    ZHInn *inn = malloc(MAXDATANUM);
    initInn(inn);
    pushData(inn, '=');
    

    while ( (*exp) != '\0') {
        data = (*exp);
        if (data =='(' || data == ')'|| data == '*' || data == '/' || data == '+' || data == '-') {
            switch (comparePir(gainTopData(inn), data)) {
                case InPirSmall:
                    pushData(inn, data);
                    exp++;
                    break;
                        
                case equal:
                    popData(inn);
                    exp++;
                    break;
                        
                case InPirBig:
                    data1 = popData(inn);
                    ( *(newExp1++) ) = data1;
                    break;
            }
        }else{
            while (data >= '0' && data <= '9')  {
                ( *(newExp1++) ) = data;
                exp++;
                data = (*exp);
            }
            ( *(newExp1++) ) = '#';
        }
    }
    while (gainTopData(inn) != '=') {
        data1 = popData(inn);
        ( *(newExp1++) ) = data1;
    }
    (*newExp1) = '\0';
    free(inn);
}


int main(int argc, const char * argv[]) {
    
    char *exp = "(90+(90+90))*2";
    
    char *exp1 = malloc(MAXDATANUM);
    transformExpre(exp, exp1);
    
    printf("%s\t%s\r\n", exp, exp1);
    free(exp1);
    
    return 0;
}
