function Value = FetchRandomValue(AccumulationPossibility,dt)
%�����ۼƸ��ʷֲ�����������õ������Ӧ�ķֲ���һ��ֵ
    random=unifrnd(0,1);
    for  i=1:size(AccumulationPossibility,1)
        if random>AccumulationPossibility(i,1)&&random<=AccumulationPossibility(i+1,1)
            Value=i*dt;
            break; %����ٶ�
        end
    end
end