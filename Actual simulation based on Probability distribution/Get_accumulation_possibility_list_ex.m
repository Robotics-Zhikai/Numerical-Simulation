function [accumulation_possibility_list_ex,tout]=Get_accumulation_possibility_list_ex(lameda,dt) %得到累积概率表 用轮盘法得到服从一定概率分布的随机数,此为负指数函数分布
%     dt=0.004; %生成概率分布函数的精度，越小精度越高
%     lameda=10; %这个值为多少，则均值就为多少
    accumulation_possibility_list_ex=0;
    error=0.0001; %一个概率分布函数在进行数值模拟时无论如何都不可能达到积分为1，只能是达到一定的误差范围内
    t=0; 
    k=2;
    tout = 0;
    accumulation_possibility_list_ex(1,1)=0;
    while accumulation_possibility_list_ex<1-error
        accumulation_possibility_list_ex(k,1)=accumulation_possibility_list_ex(k-1,1)+((1/lameda)*exp(-t/lameda))*dt;
        t=t+dt;
        tout = [tout;t];
        k=k+1;
    end
    accumulation_possibility_list_ex=[accumulation_possibility_list_ex;1];
    tout = [tout;t+dt];
end