function Value = FetchRandomValue(AccumulationPossibility,dt)
%根据累计概率分布函数表随机得到满足对应的分布的一个值
    random=unifrnd(0,1);
    for  i=1:size(AccumulationPossibility,1)
        if random>AccumulationPossibility(i,1)&&random<=AccumulationPossibility(i+1,1)
            Value=i*dt;
            break; %提高速度
        end
    end
end