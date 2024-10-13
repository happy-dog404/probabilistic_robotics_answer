clear;




%(c) 确定平稳分布
times = 1e6;
weather_data = weather_sim(times,0);
tabulate(weather_data)

%(e)
p_0 = 0.6429;
p_1 = 0.2857;
p_2 = 0.0714;

Hp = -(p_0*log2(p_0)+p_1*log2(p_1)+p_2*log2(p_2));



%3(a)
P_x = [0.8,0.2,0;0.4,0.4,0.2;0.2,0.6,0.2];%状态转移矩阵 
P_z = [0.6,0.4,0;0.3,0.7,0;0,0,1];%观测矩阵

Z = [1,1,2,0];
x_l = [1,0,0]';
for t = 1:4
    [x,pre] = bayes_filter(Z(t),x_l,P_x,P_z);
    x_l = x;    
end

function [x,pre] = bayes_filter(z,x_l,A,C)
    pre = A'*x_l;%预测
    x = C(:,z+1).*pre;%更新
    x = x/sum(x);
end

%(b) 天气状态序列模拟器
% times 为序列长度
% x0 为初始天气：0 晴天 1 多云 2雨
function squ = weather_sim(times,x0)
squ = x0;
l_x = x0;%0 晴天 1 多云 2雨
for i = 1:times-1
    r = rand();
    switch l_x
        case 0
            if r < 0.8
                x = 0;
            elseif r >= 0.8
                x = 1;
            end
        case 1
            if r < 0.4
                x = 0;
            elseif r >= 0.4 && r < 0.8
                x = 1;
            else
                x = 2;
            end   
        case 2
            if r < 0.2
                x = 0;
            elseif r >= 0.2 && r <= 0.8
                x = 1;
            else
                x = 2;
            end
    end
    squ = [squ,x];
    l_x = x;
end

end










