function [accumulation_possibility_list_guass,tout]=Get_accumulation_possibility_list_gauss(miu,sigema,dt) %得到累积概率表 用轮盘法得到服从一定概率分布的随机数,此为正态函数分布
    
%     dt=0.0005;
%     global miu;
%     global sigema;
    %global Low_range;
    %global Upper_range;
    accumulation_possibility_list_guass=0;
    error=0.001; %一个概率分布函数在进行数值模拟时无论如何都不可能达到积分为1，只能是达到一定的误差范围内
%     miu=6.5; %均值为6.5 修改这个时，需要根据正态分布在横轴负值的分布情况来修改error
%     sigema=1.2; %标准差为1.2
    %t=miu; %事实上，不可能存在t的值为负
    t=0;
    tout = 0;
    k=2;
    accumulation_possibility_list_guass(1,1)=0;
    %while accumulation_possibility_list_guass<(1-error)/2
    while accumulation_possibility_list_guass<(1-error) %对于miu为0 标准差不为0来说，只往正方向累计永远不可能累计到1 就高斯分布来说
        accumulation_possibility_list_guass(k,1)=accumulation_possibility_list_guass(k-1,1)+(1/((2*pi)^0.5*sigema))*exp(-(t-miu)^2/(2*sigema^2))*dt;      
        t=t+dt;
        tout = [tout;t];
        k=k+1;
    end
    %Upper_range=miu+(k-2)*dt; %这个用不到，最多是为了检验编程是否正确
    %Low_range=miu-(k-2)*dt;
    
%     k=2;
%     accumulation_possibility_list_guass(1,1)=0;
%     t=Low_range; 
%     while t<Upper_range %得到概率分布表
%         accumulation_possibility_list_guass(k,1)=accumulation_possibility_list_guass(k-1,1)+(1/((2*pi)^0.5*sigema))*exp(-(t-miu)^2/(2*sigema^2))*dt;      
%         t=t+dt;
%         k=k+1;
%     end
    accumulation_possibility_list_guass=[accumulation_possibility_list_guass;1];
    tout = [tout;t+dt];
end