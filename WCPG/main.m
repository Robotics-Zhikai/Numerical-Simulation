clear 
clc
close all

%足端轨迹中心点(xp0(i),yp0(i),zp0(i))
%初始(xp(i),yp(i),zp(i))=(5,0,5) 任意设定的
global min_zf;
alpha=50; %调整足端轨迹收敛到极限环的速度的参数
gama=50; %调整足端轨迹收敛到极限环的速度的参数
Ls=10; %迈步步长
Hs=5; %最大抬腿高度
Vf=25; %期望的机身前进速度
Df=0.1; %占地系数


xp(1)=5; %第i个脚的足端位置矢量
yp(1)=0;
zp(1)=0;
xp(2)=-5; %第i个脚的足端位置矢量
yp(2)=0;
zp(2)=0;
xp(3)=5; %第i个脚的足端位置矢量
yp(3)=0;
zp(3)=0;
xp(4)=-5; %第i个脚的足端位置矢量
yp(4)=0;
zp(4)=0;


for i=1:4
    xp0(i)=0;
    yp0(i)=0;
    zp0(i)=0;

   
end

Step_simulation_time=0.00008; %仿真步长
simulation_time=50; %仿真总时间
bp=1.5; %这个参数的含义不知道是什么意思
%Condition_matrix=[0,-1,-1,1;-1,0,1,-1;-1,1,0,-1;1,-1,-1,0]; %trot
Condition_matrix=[0,-1,1,-1;-1,0,-1,1;-1,1,0,-1;1,-1,-1,0];
xf(1)=0;
yf(1)=0;
zf(1)=0;
xf(2)=0;
yf(2)=0;
zf(2)=0;
xf(3)=0;
yf(3)=0;
zf(3)=0;
xf(4)=0;
yf(4)=0;
zf(4)=0;

% Kc=15000; %这个参数不知道是什么意思
% bf=3; %这个参数不知道是什么意思
Kc=100;
bf=1.5;
ztd(1)=-0.2; %触地深度参数
ztd(2)=-0.2;
ztd(3)=-0.2;
ztd(4)=-0.2;
flag_once=1;
for time_i=1:ceil(simulation_time/Step_simulation_time)
    if mod(time_i,85000/4)==0
      %  Df=0.2;
        Hs=Hs+5; %抬腿高度变高
        %Ls=Ls+3;
       % ztd(1)=3;
        %Vf=Vf+5;
%         xf(1)=50;
%         yf(1)=0;
%         zf(1)=40;
    end

    for i=1:4 %四条腿
        x_average(i)=xp(i)-xp0(i);
        z_average(i)=zp(i)-zp0(i);
        ws(i)=pi*(Vf/Ls)*( (Df/(1-Df))*( (exp(-bp*z_average(i))+1)^-1 ) + (exp(bp*z_average(i))+1)^-1 );
    end
    for i=1:4
        d_xp(i)=(alpha*(1-(4*x_average(i)^2)/(Ls^2)-(z_average(i)^2)/(Hs^2))*x_average(i)+((ws(i)*Ls)/(2*Hs))*z_average(i))*Step_simulation_time;
        addition=0;
        for j=1:4
            addition=addition+Condition_matrix(i,j)*z_average(j);
        end
        d_zp(i)=(gama*(1-(4*x_average(i)^2)/(Ls^2)-(z_average(i)^2)/(Hs^2))*z_average(i)-(ws(i)*2*Hs/Ls)*x_average(i)+addition)*Step_simulation_time;
        xp(i)=xp(i)+d_xp(i);
        zp(i)=zp(i)+d_zp(i);
        
        d_xf(i)=((( (d_xp(i)/Step_simulation_time)+Kc*(xp(i)-xf(i)) )*( exp(-bf*(z_average(i)-ztd(i)))+1)^-1)-Vf*(exp(bf*(z_average(i)-ztd(i)))+1)^-1)*Step_simulation_time;
        d_zf(i)=((( (d_zp(i)/Step_simulation_time)+Kc*(zp(i)-zf(i)) )*( exp(-bf*(z_average(i)-ztd(i)))+1)^-1)-0*( exp(bf*(z_average(i)-ztd(i)))+1)^-1 )*Step_simulation_time;
        xf(i)=xf(i)+d_xf(i);
        zf(i)=zf(i)+d_zf(i);
    end
%       plot(time_i,zf(1),'.');
%          hold on;
%           drawnow;
    xp1(time_i)=xp(1);
    xp2(time_i)=xp(2);
    xp3(time_i)=xp(3);
    xp4(time_i)=xp(4);
    
    zp1(time_i)=zp(1);
    zp2(time_i)=zp(2);
    zp3(time_i)=zp(3);
    zp4(time_i)=zp(4);

    xf1(time_i)=xf(1);
    xf2(time_i)=xf(2);
    xf3(time_i)=xf(3);
    xf4(time_i)=xf(4);
    
    zf1(time_i)=zf(1);
    zf2(time_i)=zf(2);
    zf3(time_i)=zf(3);
    zf4(time_i)=zf(4);
    zf_now=zf(1);
    if flag_once==1
        zf_last=zf(1);
        flag_once=0;
    end
%     if (zf_now<=-2&&zf_last>-2)
%         Hs=Hs+5;
%        % Ls=Ls+3;
%         %ztd(1)=ztd(1)+0.5;
%         %Vf=Vf+5;
%     end
    zf_last=zf(1);
end

% 以下均为仿真显示代码，以需求取用
% subplot(411)
% plot(xp1,'.');
% grid on
% subplot(412)
% plot(xp2,'.');
% grid on
% subplot(413)
% plot(xp3,'.');
% grid on
% subplot(414)
% plot(xp4,'.');
% grid on

% subplot(411)
% plot(zp1,'.');
% grid on
% subplot(412)
% plot(zp2,'.');
% grid on
% subplot(413)
% plot(zp3,'.');
% grid on
% subplot(414)
% plot(zp4,'.');
% grid on



% subplot(411)
% plot(zf1,'.');
% subplot(412)
% plot(zf2,'.');
% subplot(413)
% plot(zf3,'.');
% subplot(414)
% plot(zf4,'.');

% 
% subplot(411)
% plot(xf1,'.');
% grid on
% subplot(412)
% plot(xf2,'.');
% grid on
% subplot(413)
% plot(xf3,'.');
% grid on
% subplot(414)
% plot(xf4,'.');
% grid on
% % 
for i=1:180:size(zf1,2)
    plot(xf1(i),zf1(i),'.');
    title('抬腿高度每隔一段时间变高')
    hold on;
    drawnow;
end

% subplot(411)
% plot(xf1,zf1,'.');
% subplot(412)
% plot(xf2,zf2,'.');
% subplot(413)
% plot(xf3,zf3,'.');
% subplot(414)
% plot(xf4,zf4,'.');

 
% subplot(411)
% plot(xp1,zp1,'.');
% %axis([9 11 -2 2]);
% subplot(412)
% plot(xp2,zp2,'.');
% %axis([9 11 -2 2]);
% subplot(413)
% plot(xp3,zp3,'.');
% %axis([9 11 -2 2]);
% subplot(414)
% plot(xp4,zp4,'.');
% %axis([9 11 -2 2]);

% for i=ceil(size(xp1,2)/2):size(xp1,2)
%     subplot(411)
%     plot(xp1(i),zp1(i),'.');
%     axis([1 11 -2 1]);
%     hold on;
%     subplot(412)
%     plot(xp2(i),zp2(i),'.');
%     axis([1 11 -2 1]);
%     hold on;
%     subplot(413)
%     plot(xp3(i),zp3(i),'.');
%     axis([1 11 -2 1]);
%     hold on;
%     subplot(414)
%     plot(xp4(i),zp4(i),'.');
%     axis([1 11 -2 1]);
%     hold on;
%     drawnow;
% end

function Get_min_zf(input) %获取zf的最小值
    global min_zf;
    persistent variable;
    if (isempty(variable))
        variable=input;
        min_zf=variable;
    end
    if (input<variable)
        min_zf=input;
        variable=min_zf;
    end
end




