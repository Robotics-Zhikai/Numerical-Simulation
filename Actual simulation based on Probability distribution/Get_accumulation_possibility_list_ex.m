function [accumulation_possibility_list_ex,tout]=Get_accumulation_possibility_list_ex(lameda,dt) %�õ��ۻ����ʱ� �����̷��õ�����һ�����ʷֲ��������,��Ϊ��ָ�������ֲ�
%     dt=0.004; %���ɸ��ʷֲ������ľ��ȣ�ԽС����Խ��
%     lameda=10; %���ֵΪ���٣����ֵ��Ϊ����
    accumulation_possibility_list_ex=0;
    error=0.0001; %һ�����ʷֲ������ڽ�����ֵģ��ʱ������ζ������ܴﵽ����Ϊ1��ֻ���Ǵﵽһ������Χ��
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