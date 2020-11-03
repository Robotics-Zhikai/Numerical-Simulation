clear 
close all
clc

%哈工大小月亮超市真实小样本实验并仿真

% figure
% x=0:0.01:100;
% fx=1/lameda*exp(-x/lameda);
% plot(x,fx,'-');

accumulation_possibility_list_ex=Get_accumulation_possibility_list_ex(15.71,0.004); %获取服从均值为10的指数分布的分布函数
accumulation_possibility_list_guass=Get_accumulation_possibility_list_gauss(13.12,4.1,0.0005); %获取均值为6.5,方差为1.2的高斯分布的分布函数

% %生成高斯分布检测步骤
% for i=1:10000
%     x(i)=Get_handle_time(accumulation_possibility_list_guass);
% end
% mean(x)
% std2(x)
% %生成指数分布检测步骤
% for i=1:100000
%     x1(i)=Get_reach_interval(accumulation_possibility_list_ex);
% end
% mean(x1)
% std2(x1)
k=1;
Sum_amount_person=40; %超市里从开始观察时刻总共有的人
while 1 
    d_simulation_time=0.001; %整个模拟的时间间隔
    T_simulation=50000; %整个模拟持续的时间
    T_simulation = T_simulation*1;
    t_now=0;
    current_person_amount=0; %当前在收银台前的人数
    T_interval=Get_reach_interval(accumulation_possibility_list_ex); %生成第一个人到达的时间
    T_count_person_reach=0; %累积d_simulation_time，直到T_interval
    T_handle=Get_handle_time(accumulation_possibility_list_guass); %生成收第一个人银的时间
    T_count_person_handle=0; %累积d_simulation_time，直到收银时间
    ERROR=0.001;
    
    Wait_time_person=zeros(1,Sum_amount_person); %超市中所有人的结账时间，包括排队时间和付钱时间
    count_amout_person=0; %计有多少人到达收银台
    flag_1=0;
    Get_Sum_Time_Of_people=0; %获取每个人在超市逗留的的总时间
    leave_person_state=1; %作为修改人的状态为离开的计数变量

    World_time=0; %记录世界时间，一直在计数
    Record_the_non_cashier_time=0 ;% 记录收银台不收银时间
    current_person_amountRecord = [];
    for i=1:T_simulation/d_simulation_time
        World_time=World_time+d_simulation_time;
        T_count_person_reach=T_count_person_reach+d_simulation_time;
        if (abs(T_count_person_reach-T_interval)<=ERROR)&&(flag_1==0) %说明有一个新的人到达
            current_person_amount=current_person_amount+1;
            T_count_person_reach=0;
            T_interval=Get_reach_interval(accumulation_possibility_list_ex);
            count_amout_person=count_amout_person+1;
            Get_Sum_Time_Of_people(1,count_amout_person)=0;
            Get_Sum_Time_Of_people(2,count_amout_person)=1; %该编号的人开始计时，状态变量为1
            if count_amout_person==Sum_amount_person
                flag_1=1; %达到人数上限，不再产生新的人了，人走完了
            end
        end
        if size(Get_Sum_Time_Of_people,1)>1
            for jj=1:size(Get_Sum_Time_Of_people,2)
                if Get_Sum_Time_Of_people(2,jj)==1 %当该状态变量为1时，意味着仍在等待或者付款状态，则计时，否则当状态变量为0时，则认为离开，不进行计时
                    Get_Sum_Time_Of_people(1,jj)=Get_Sum_Time_Of_people(1,jj)+d_simulation_time;
                end
            end
        end
        if current_person_amount>0
            T_count_person_handle=T_count_person_handle+d_simulation_time;
            if abs(T_count_person_handle-T_handle)<=ERROR %说明收银完毕
                current_person_amount=current_person_amount-1;
                T_count_person_handle=0;
                T_handle=Get_handle_time(accumulation_possibility_list_guass);
                Get_Sum_Time_Of_people(2,leave_person_state)=0; %状态变量为0，代表该人离开，停止计时 FIFO结构
                leave_person_state=leave_person_state+1;
            end
        end
%         if mod(i,5000)==0
%             plot(i,current_person_amount,'.');
%             hold on;
%             drawnow;
%         end
        if (flag_1==1)&&(current_person_amount==0)
            for jjjjj=0:50000
%                 if mod(jjjjj,5000)==0
%                     plot(i+jjjjj,current_person_amount,'.');
%                     hold on;
%                     drawnow;
%                 end
            end
            break;
        end
        if current_person_amount==0
            Record_the_non_cashier_time=Record_the_non_cashier_time+d_simulation_time;
        end
        if mod(i,1/d_simulation_time)==0
            current_person_amountRecord = [current_person_amountRecord current_person_amount]; %现实1秒记一个
        end
    end
    plot(current_person_amountRecord)
    title('每时刻在收银台前的人数')
    ylabel('人数')
    xlabel('时间 (t /s)')
    
    
    Service_intensity(k)=1-Record_the_non_cashier_time/World_time; %记录收银强度
    average_time(k)=mean(Get_Sum_Time_Of_people(1,:)); %记录平均时间，包括排队时间和结账时间   
    Sum_amount_person=Sum_amount_person+0;
    subplot(211)
    plot(k,Service_intensity(k),'.');
    ylabel('收银台服务强度，服务时间占总时间的比例');
    xlabel('试验次数');
    hold on;
    drawnow;
    subplot(212)
    plot(k,average_time(k),'.');
    ylabel('所有人的平均排队与结账时间');
    xlabel('试验次数');
    hold on;
    drawnow;
     k=k+1;
     mean_average_time=mean(average_time); %计算多次，取均值，下同
     mean_Service_intensity=mean(Service_intensity);
end



function T_interval=Get_reach_interval(accumulation_possibility_list_ex) %随机按照相应的分布得到顾客到达的时间间隔,T_interval遵从相应分布规律
    dt=0.004;
    T_interval = FetchRandomValue(accumulation_possibility_list_ex,dt);
%     random=unifrnd(0,1);
%     for  i=1:size(accumulation_possibility_list_ex,1)
%         if random>accumulation_possibility_list_ex(i,1)&&random<=accumulation_possibility_list_ex(i+1,1)
%             T_interval=i*dt;
%             break; %提高速度
%         end
%     end
end


function T_handle=Get_handle_time(accumulation_possibility_list_gauss)%得到服从高斯分布的收银时间
    %global Low_range;
   % global Upper_range;
    dt=0.0005;
    T_handle = FetchRandomValue(accumulation_possibility_list_gauss,dt);
%     random=unifrnd(0,1);
%     for i=1:size(accumulation_possibility_list_gauss,1)
%         if (random>accumulation_possibility_list_gauss(i,1))&&(random<=accumulation_possibility_list_gauss(i+1,1))
%             %T_handle=Low_range+i*dt;
%             T_handle=0+i*dt;
%             break; %提高速度
%         end
%     end
end














