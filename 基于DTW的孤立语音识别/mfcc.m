% mfcc.m Mel尺度倒谱系数
function cc=mfcc(k)
%------------------------------
% cc=mfcc(k)计算语音k的MFCC系数
%------------------------------
% M为滤波器个数，N为一帧语音采样点数
M=24; N=256;
% 归一化mel滤波器组系数
bank=melbankm(M,N,8000,0,0.5,'m');
figure;
plot(linspace(0,N/2,129),bank);
title('Mel滤波器组');
xlabel('频率[Hz]');
bank=full(bank);
bank=bank/max(bank(:));
% DCT系数,12*24
for i=1:12
  j=0:23;
  dctcoef(i,:)=cos((2*j+1)*i*pi/(2*24));
end
% 归一化倒谱提升窗口
w=1+6*sin(pi*[1:12]./12);
w=w/max(w);
% 预加重
AggrK=double(k);
AggrK=filter([1,-0.9375],1,AggrK);
% 分帧
FrameK=enframe(AggrK,N,80);
% 加窗
for i=1:size(FrameK,1)
    FrameK(i,:)=(FrameK(i,:))'.*hamming(N);
end
FrameK=FrameK';
% 计算功率谱
S=(abs(fft(FrameK))).^2;
disp('显示功率谱……')
figure;
plot(S);
axis([1,size(S,1),0,20]);
title('功率谱 (滤波器个数=24,一帧语音采样点数=256)');
xlabel('帧');
ylabel('频率[Hz]');
colorbar;
% 将功率谱通过滤波器组
P=bank*S(1:129,:);
% 取对数后作离散余弦变换
D=dctcoef*log(P);
% 倒谱提升窗
for i=1:size(D,2)
    m(i,:)=(D(:,i).*w')';
end
% 差分系数
dtm=zeros(size(m));
for i=3:size(m,1)-2
  dtm(i,:)=-2*m(i-2,:)-m(i-1,:)+m(i+1,:)+2*m(i+2,:);
end
dtm=dtm/3;
%合并mfcc参数和一阶差分mfcc参数
cc=[m,dtm];
%去除首尾两帧，因为这两帧的一阶差分参数为0
cc=cc(3:size(m,1)-2,:);