function [accumulation_possibility_list_guass,tout]=Get_accumulation_possibility_list_gauss(miu,sigema,dt) %�õ��ۻ����ʱ� �����̷��õ�����һ�����ʷֲ��������,��Ϊ��̬�����ֲ�
    
%     dt=0.0005;
%     global miu;
%     global sigema;
    %global Low_range;
    %global Upper_range;
    accumulation_possibility_list_guass=0;
    error=0.001; %һ�����ʷֲ������ڽ�����ֵģ��ʱ������ζ������ܴﵽ����Ϊ1��ֻ���Ǵﵽһ������Χ��
%     miu=6.5; %��ֵΪ6.5 �޸����ʱ����Ҫ������̬�ֲ��ں��Ḻֵ�ķֲ�������޸�error
%     sigema=1.2; %��׼��Ϊ1.2
    %t=miu; %��ʵ�ϣ������ܴ���t��ֵΪ��
    t=0;
    tout = 0;
    k=2;
    accumulation_possibility_list_guass(1,1)=0;
    %while accumulation_possibility_list_guass<(1-error)/2
    while accumulation_possibility_list_guass<(1-error) %����miuΪ0 ��׼�Ϊ0��˵��ֻ���������ۼ���Զ�������ۼƵ�1 �͸�˹�ֲ���˵
        accumulation_possibility_list_guass(k,1)=accumulation_possibility_list_guass(k-1,1)+(1/((2*pi)^0.5*sigema))*exp(-(t-miu)^2/(2*sigema^2))*dt;      
        t=t+dt;
        tout = [tout;t];
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
    tout = [tout;t+dt];
end