clc
clear
close all
%����ҵ�ĳ���

rand('seed', 0) 
%ʵ������
Actual = [46.03 9.84 35.81 1.56 18.34 15.99 3.13 11.89 5.43 1.14 16.62 8.61 19.99 1.08 1.82 15.08 1.17 14.16 6.58 25.49 29.86 14.99 4.98];
%���������23���� �ƹ��һСʱ��276�� ����ӵľ�ֵΪ13.46

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
title('�����˽��뵥������̨���ʱ������')
ylabel('t /s')
xlabel('��������̨�˴α��')

figure
histogram(Data)
title('�����˽��뵥������̨���ʱ�����ݷֲ�ֱ��ͼ')
xlabel('���ʱ����� (t /s)')
ylabel('Ƶ��')
% [accumulation_possibility_list_guass,t2]=Get_accumulation_possibility_list_gauss(0,0.02,0.0005);

figure
ProcessData = normrnd(13,2,1,num+size(Actual,2));
plot(ProcessData,'.')
title('��������̨����ʱ������')
ylabel('t /s')
xlabel('��������̨�˴α��')

figure
histogram(ProcessData)
title('��������̨����ʱ�����ݷֲ�ֱ��ͼ')
xlabel('����ʱ����� (t /s)')
ylabel('Ƶ��')

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
title('��������ģ�����ɵĽ����˽��뵥������̨���ʱ������')
xlabel('���ʱ����� (t /s)')
ylabel('Ƶ��')

figure
plot(BPHis.Values,'.')
hold on 
plot(BPHis.Values,'-')
title('Ƶ��ֱ��ͼ������ȡֵ�߶�ͼ')
xlabel('���ʱ�� (t /s)')
ylabel('Ƶ��')

bpvalue = BPHis.Values;

%%
%BPѵ��
n=50;
net = newff([1 size(bpvalue,2)], [n,1], {'tansig' 'purelin'}, 'trainlm');
p = 1:size(bpvalue,2);
% ���ڸó�ʼ���磬����Ӧ��sim()�����۲��������
y1 = sim(net,p);
% ͬʱ��������������ߣ�����ԭ������Ƚ�
figure;
plot(p,bpvalue,'-',p,y1,'--')
title('δѵ�������������');
xlabel('���ʱ�� (t /s)');
ylabel('Ƶ��')
legend('ԭ����','ѵ��ǰ�ķ������')

net.trainParam.epochs = 140;
net.trainParam.goal = 0.00001;
net = train(net,p,bpvalue);

y2 = sim(net,p);
figure;
plot(p,bpvalue,'-',p,y2,'--')
title('ѵ���������������');
xlabel('���ʱ�� (t /s)');
ylabel('Ƶ��')
legend('ԭ����','ѵ����ķ������')

figure
p1 = 1:0.1:size(bpvalue,2);
subplot(121)
plot(p,bpvalue,'-');
title('ԭ����');
xlabel('���ʱ�� (t /s)');
ylabel('Ƶ��')
axis([0 150 -0.01 0.07])
subplot(122)
plot(p1,sim(net,p1),'-');
title('ѵ���������������');
xlabel('���ʱ�� (t /s)');
ylabel('Ƶ��')



% plot(t2,accumulation_possibility_list_guass,'-')










