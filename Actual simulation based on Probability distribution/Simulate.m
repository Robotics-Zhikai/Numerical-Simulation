clc
clear
close all
%大作业的程序

rand('seed', 0) 
%实际数据
Actual = [46.03 9.84 35.81 1.56 18.34 15.99 3.13 11.89 5.43 1.14 16.62 8.61 19.99 1.08 1.82 15.08 1.17 14.16 6.58 25.49 29.86 14.99 4.98];
%由五分钟有23个人 推广得一小时有276人 五分钟的均值为13.46

dt = 0.004;
num = 276-size(Actual,2);

[accumulation_possibility_list_ex,t1]=Get_accumulation_possibility_list_ex(15,dt);
% figure
% plot(t1,accumulation_possibility_list_ex,'-')
Data = Actual;
for i =1:num
    Value = FetchRandomValue(accumulation_possibility_list_ex,dt);
    Data = [Data Value];
end

figure
plot(Data,'.')
title('结账人进入单个收银台间隔时间数据')
ylabel('t /s')
xlabel('进入收银台人次编号')

figure
histogram(Data)
title('结账人进入单个收银台间隔时间数据分布直方图')
xlabel('间隔时间分组 (t /s)')
ylabel('频次')
% [accumulation_possibility_list_guass,t2]=Get_accumulation_possibility_list_gauss(0,0.02,0.0005);

figure
ProcessData = normrnd(13,2,1,num+size(Actual,2));
plot(ProcessData,'.')
title('单个收银台结账时间数据')
ylabel('t /s')
xlabel('进入收银台人次编号')

figure
histogram(ProcessData)
title('单个收银台结账时间数据分布直方图')
xlabel('结账时间分组 (t /s)')
ylabel('频次')

Time = datetime([2020 11 2 19 30 00],'Format','HH:mm:ss');
TimeStr = [];
for i = 1:size(Data,2)
%     Time = Time + Data(i);
    Time.Second = Time.Second+Data(i);
    
    TimeStr = [TimeStr;[{Time},{roundn(Data(i),-2)}]];
    
%     TimeStr = [TimeStr; {[num2str(hour),':',num2str(minute),':',num2str(Second),':',num2str(Down)]}];

%     TimeStr = [TimeStr;{num2str(Time)}];
end

BPData = [];
[accumulation_possibility_list_ex,t1]=Get_accumulation_possibility_list_ex(15.71,dt);
for i =1:100000
    i
    Value = FetchRandomValue(accumulation_possibility_list_ex,dt);
    BPData = [BPData Value];
end
figure
BPHis = histogram(BPData,'Normalization','probability');
mean(BPData)
title('利用理论模型生成的结账人进入单个收银台间隔时间数据')
xlabel('间隔时间分组 (t /s)')
ylabel('频率')

figure
plot(BPHis.Values,'.')
hold on 
plot(BPHis.Values,'-')
title('频率直方图各区间取值高度图')
xlabel('间隔时间 (t /s)')
ylabel('频率')

bpvalue = BPHis.Values;

%%
%BP训练
n=50;
net = newff([1 size(bpvalue,2)], [n,1], {'tansig' 'purelin'}, 'trainlm');
p = 1:size(bpvalue,2);
% 对于该初始网络，可以应用sim()函数观察网络输出
y1 = sim(net,p);
% 同时绘制网络输出曲线，并与原函数相比较
figure;
plot(p,bpvalue,'-',p,y1,'--')
title('未训练网络的输出结果');
xlabel('间隔时间 (t /s)');
ylabel('频率')
legend('原函数','训练前的仿真输出')

net.trainParam.epochs = 140;
net.trainParam.goal = 0.00001;
net = train(net,p,bpvalue);

y2 = sim(net,p);
figure;
plot(p,bpvalue,'-',p,y2,'--')
title('训练后网络的输出结果');
xlabel('间隔时间 (t /s)');
ylabel('频率')
legend('原函数','训练后的仿真输出')

figure
p1 = 1:0.1:size(bpvalue,2);
subplot(121)
plot(p,bpvalue,'-');
title('原函数');
xlabel('间隔时间 (t /s)');
ylabel('频率')
axis([0 150 -0.01 0.07])
subplot(122)
plot(p1,sim(net,p1),'-');
title('训练后网络的输出结果');
xlabel('间隔时间 (t /s)');
ylabel('频率')



% plot(t2,accumulation_possibility_list_guass,'-')










