clear 
close all
clc


% figure
% x=0:0.01:100;
% fx=1/lameda*exp(-x/lameda);
% plot(x,fx,'-');

accumulation_possibility_list_ex=Get_accumulation_possibility_list_ex(); %��ȡ���Ӿ�ֵΪ10��ָ���ֲ��ķֲ�����
accumulation_possibility_list_guass=Get_accumulation_possibility_list_gauss(); %��ȡ��ֵΪ6.5,����Ϊ1.2�ĸ�˹�ֲ��ķֲ�����

% %���ɸ�˹�ֲ���ⲽ��
% for i=1:10000
%     x(i)=Get_handle_time(accumulation_possibility_list_guass);
% end
% mean(x)
% std2(x)
% %����ָ���ֲ���ⲽ��
% for i=1:100000
%     x1(i)=Get_reach_interval(accumulation_possibility_list_ex);
% end
% mean(x1)
% std2(x1)
k=1;
Sum_amount_person=10; %������ӿ�ʼ�۲�ʱ���ܹ��е���
while 1 
    d_simulation_time=0.0001; %����ģ���ʱ����
    T_simulation=50000; %����ģ�������ʱ��
    t_now=0;
    current_person_amount=0; %��ǰ������̨ǰ������
    T_interval=Get_reach_interval(accumulation_possibility_list_ex); %���ɵ�һ���˵����ʱ��
    T_count_person_reach=0; %�ۻ�d_simulation_time��ֱ��T_interval
    T_handle=Get_handle_time(accumulation_possibility_list_guass); %�����յ�һ��������ʱ��
    T_count_person_handle=0; %�ۻ�d_simulation_time��ֱ������ʱ��
    ERROR=0.001;
    
    Wait_time_person=zeros(1,Sum_amount_person); %�����������˵Ľ���ʱ�䣬�����Ŷ�ʱ��͸�Ǯʱ��
    count_amout_person=0; %���ж����˵�������̨
    flag_1=0;
    Get_Sum_Time_Of_people=0; %��ȡÿ�����ڳ��ж����ĵ���ʱ��
    leave_person_state=1; %��Ϊ�޸��˵�״̬Ϊ�뿪�ļ�������

    World_time=0; %��¼����ʱ�䣬һֱ�ڼ���
    Record_the_non_cashier_time=0 ;% ��¼����̨������ʱ��
    for i=1:T_simulation/d_simulation_time
        World_time=World_time+d_simulation_time;
        T_count_person_reach=T_count_person_reach+d_simulation_time;
        if (abs(T_count_person_reach-T_interval)<=ERROR)&&(flag_1==0) %˵����һ���µ��˵���
            current_person_amount=current_person_amount+1;
            T_count_person_reach=0;
            T_interval=Get_reach_interval(accumulation_possibility_list_ex);
            count_amout_person=count_amout_person+1;
            Get_Sum_Time_Of_people(1,count_amout_person)=0;
            Get_Sum_Time_Of_people(2,count_amout_person)=1; %�ñ�ŵ��˿�ʼ��ʱ��״̬����Ϊ1
            if count_amout_person==Sum_amount_person
                flag_1=1; %�ﵽ�������ޣ����ٲ����µ����ˣ���������
            end
        end
        if size(Get_Sum_Time_Of_people,1)>1
            for jj=1:size(Get_Sum_Time_Of_people,2)
                if Get_Sum_Time_Of_people(2,jj)==1 %����״̬����Ϊ1ʱ����ζ�����ڵȴ����߸���״̬�����ʱ������״̬����Ϊ0ʱ������Ϊ�뿪�������м�ʱ
                    Get_Sum_Time_Of_people(1,jj)=Get_Sum_Time_Of_people(1,jj)+d_simulation_time;
                end
            end
        end
        if current_person_amount>0
            T_count_person_handle=T_count_person_handle+d_simulation_time;
            if abs(T_count_person_handle-T_handle)<=ERROR %˵���������
                current_person_amount=current_person_amount-1;
                T_count_person_handle=0;
                T_handle=Get_handle_time(accumulation_possibility_list_guass);
                Get_Sum_Time_Of_people(2,leave_person_state)=0; %״̬����Ϊ0����������뿪��ֹͣ��ʱ FIFO�ṹ
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
                if mod(jjjjj,5000)==0
%                     plot(i+jjjjj,current_person_amount,'.');
%                     hold on;
%                     drawnow;
                end
            end
            break;
        end
        if current_person_amount==0
            Record_the_non_cashier_time=Record_the_non_cashier_time+d_simulation_time;
        end
    end
    Service_intensity(k)=1-Record_the_non_cashier_time/World_time; %��¼����ǿ��
    average_time(k)=mean(Get_Sum_Time_Of_people(1,:)); %��¼ƽ��ʱ�䣬�����Ŷ�ʱ��ͽ���ʱ��   
    Sum_amount_person=Sum_amount_person+0;
    subplot(211)
    plot(k,Service_intensity(k),'.');
    ylabel('����̨����ǿ�ȣ�����ʱ��ռ��ʱ��ı���');
    xlabel('�������');
    hold on;
    drawnow;
    subplot(212)
    plot(k,average_time(k),'.');
    ylabel('�����˵�ƽ���Ŷ������ʱ��');
    xlabel('�������');
    hold on;
    drawnow;
     k=k+1;
     mean_average_time=mean(average_time); %�����Σ�ȡ��ֵ����ͬ
     mean_Service_intensity=mean(Service_intensity);
end

function accumulation_possibility_list_ex=Get_accumulation_possibility_list_ex() %�õ��ۻ����ʱ� �����̷��õ�����һ�����ʷֲ��������,��Ϊ��ָ�������ֲ�
    dt=0.004; %���ɸ��ʷֲ������ľ��ȣ�ԽС����Խ��
    lameda=10; %���ֵΪ���٣����ֵ��Ϊ����
    accumulation_possibility_list_ex=0;
    error=0.0001; %һ�����ʷֲ������ڽ�����ֵģ��ʱ������ζ������ܴﵽ����Ϊ1��ֻ���Ǵﵽһ������Χ��
    t=0; 
    k=2;
    accumulation_possibility_list_ex(1,1)=0;
    while accumulation_possibility_list_ex<1-error
        accumulation_possibility_list_ex(k,1)=accumulation_possibility_list_ex(k-1,1)+((1/lameda)*exp(-t/lameda))*dt;
        t=t+dt;
        k=k+1;
    end
    accumulation_possibility_list_ex=[accumulation_possibility_list_ex;1];
end

function T_interval=Get_reach_interval(accumulation_possibility_list_ex) %���������Ӧ�ķֲ��õ��˿͵����ʱ����,T_interval�����Ӧ�ֲ�����
    dt=0.004;
    random=unifrnd(0,1);
    for  i=1:size(accumulation_possibility_list_ex,1)
        if random>accumulation_possibility_list_ex(i,1)&&random<=accumulation_possibility_list_ex(i+1,1)
            T_interval=i*dt;
            break; %����ٶ�
        end
    end
end

function accumulation_possibility_list_guass=Get_accumulation_possibility_list_gauss() %�õ��ۻ����ʱ� �����̷��õ�����һ�����ʷֲ��������,��Ϊ��̬�����ֲ�
    
    dt=0.0005;
    global miu;
    global sigema;
    %global Low_range;
    %global Upper_range;
    accumulation_possibility_list_guass=0;
    error=0.000001; %һ�����ʷֲ������ڽ�����ֵģ��ʱ������ζ������ܴﵽ����Ϊ1��ֻ���Ǵﵽһ������Χ��
    miu=6.5; %��ֵΪ6.5 �޸����ʱ����Ҫ������̬�ֲ��ں��Ḻֵ�ķֲ�������޸�error
    sigema=1.2; %��׼��Ϊ1.2
    %t=miu; %��ʵ�ϣ������ܴ���t��ֵΪ��
    t=0;
    k=2;
    accumulation_possibility_list_guass(1,1)=0;
    %while accumulation_possibility_list_guass<(1-error)/2
    while accumulation_possibility_list_guass<(1-error)
        accumulation_possibility_list_guass(k,1)=accumulation_possibility_list_guass(k-1,1)+(1/((2*pi)^0.5*sigema))*exp(-(t-miu)^2/(2*sigema^2))*dt;      
        t=t+dt;
        k=k+1;
    end
    %Upper_range=miu+(k-2)*dt; %����ò����������Ϊ�˼������Ƿ���ȷ
    %Low_range=miu-(k-2)*dt;
    
%     k=2;
%     accumulation_possibility_list_guass(1,1)=0;
%     t=Low_range; 
%     while t<Upper_range %�õ����ʷֲ���
%         accumulation_possibility_list_guass(k,1)=accumulation_possibility_list_guass(k-1,1)+(1/((2*pi)^0.5*sigema))*exp(-(t-miu)^2/(2*sigema^2))*dt;      
%         t=t+dt;
%         k=k+1;
%     end
    accumulation_possibility_list_guass=[accumulation_possibility_list_guass;1];
end

function T_handle=Get_handle_time(accumulation_possibility_list_gauss)%�õ����Ӹ�˹�ֲ�������ʱ��
    %global Low_range;
   % global Upper_range;
    dt=0.0005;
    random=unifrnd(0,1);
    for i=1:size(accumulation_possibility_list_gauss,1)
        if (random>accumulation_possibility_list_gauss(i,1))&&(random<=accumulation_possibility_list_gauss(i+1,1))
            %T_handle=Low_range+i*dt;
            T_handle=0+i*dt;
            break; %����ٶ�
        end
    end
end














