%概率机器人第二章第3题
Pz_x = [0.6,0.4,0;
        0.3,0.7,0;
        0,  0,  1];
Px_x_1 = [0.8, 0.2, 0;
          0.4, 0.4, 0.2;
          0.2, 0.6, 0.2];

%% (a)  就是个简单的贝叶斯滤波
bel_x1 = [1;0;0];
      
Z_x2 = [0;1;0];

rec_bel_x = [];
rec_pre_x = [];

bel_x = bel_x1;
Z_x2 = [0 1 0;0 1 0;0 0 1;1 0 0];


weather_que = [1,1,2,0];%观测的天气序列

for i = 1:4
    [bel_x,pre_x] = bayes_filter(weather_que(i),bel_x,Px_x_1,Pz_x);
end

%% （b）
%只考虑当天天气数据的情况
bel_x1 = [1;0;0];
bel_x = bel_x1;
weather_que = [0,0,2];%观测的天气序列
rec_bel_x = [];
rec_pre_x = [];
for i = 1:3
    [bel_x,pre_x] = bayes_filter(weather_que(i),bel_x,Px_x_1,Pz_x);
    rec_bel_x = [rec_bel_x;bel_x'];
    rec_pre_x = [rec_pre_x;pre_x'];
end
%未来几天天气数据也可用的情况
Pz3_x2 = Pz_x(1,:)*Px_x_1;%Z3为晴
Pz4_x2 = Pz_x(3,:)*Px_x_1*Px_x_1;%Z4为雨
temp = Pz_x(1,:).*Pz3_x2.*Pz4_x2.*rec_bel_x(1,:);
Px2_z24 = temp/sum(temp);

Pz4_x3 = Pz_x(3,:)*Px_x_1;
temp = Pz4_x3.*rec_bel_x(2,:);
Px3_z34 = temp/sum(temp);

Px4_z4 = rec_bel_x(3,:);

P_allday_squ = [Px2_z24;Px3_z34;Px4_z4];


%% (c)
%若只用当天的
P_only_today = rec_bel_x(1,1)*rec_bel_x(2,1)*rec_bel_x(3,3);
P_all_days = Px2_z24(1)*Px3_z34(1)*Px4_z4(3);

%%

%贝叶斯预测
function hat_bel_x = bayes_predicit(bel_x,P_x_x1)
%bel_x:状态X的后验
%P_x_x1：状态转移矩阵
hat_bel_x = P_x_x1'*bel_x;
end

%贝叶斯更新
function bel_x_update = bayes_update(bel_x,Pz_x)
%bel_x:状态X的预测
%Pz_x：观测矩阵
bel_x_update = Pz_x*bel_x;
end

     
function [x,pre] = bayes_filter(z,x_l,A,C)
    pre = A'*x_l;%预测
    x = C(:,z+1).*pre;%更新
    x = x/sum(x);
end
