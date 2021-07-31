% mfcc.m Mel�߶ȵ���ϵ��
function cc=mfcc(k)
%------------------------------
% cc=mfcc(k)��������k��MFCCϵ��
%------------------------------
% MΪ�˲���������NΪһ֡������������
M=24; N=256;
% ��һ��mel�˲�����ϵ��
bank=melbankm(M,N,8000,0,0.5,'m');
figure;
plot(linspace(0,N/2,129),bank);
title('Mel�˲�����');
xlabel('Ƶ��[Hz]');
bank=full(bank);
bank=bank/max(bank(:));
% DCTϵ��,12*24
for i=1:12
  j=0:23;
  dctcoef(i,:)=cos((2*j+1)*i*pi/(2*24));
end
% ��һ��������������
w=1+6*sin(pi*[1:12]./12);
w=w/max(w);
% Ԥ����
AggrK=double(k);
AggrK=filter([1,-0.9375],1,AggrK);
% ��֡
FrameK=enframe(AggrK,N,80);
% �Ӵ�
for i=1:size(FrameK,1)
    FrameK(i,:)=(FrameK(i,:))'.*hamming(N);
end
FrameK=FrameK';
% ���㹦����
S=(abs(fft(FrameK))).^2;
disp('��ʾ�����ס���')
figure;
plot(S);
axis([1,size(S,1),0,20]);
title('������ (�˲�������=24,һ֡������������=256)');
xlabel('֡');
ylabel('Ƶ��[Hz]');
colorbar;
% ��������ͨ���˲�����
P=bank*S(1:129,:);
% ȡ����������ɢ���ұ任
D=dctcoef*log(P);
% ����������
for i=1:size(D,2)
    m(i,:)=(D(:,i).*w')';
end
% ���ϵ��
dtm=zeros(size(m));
for i=3:size(m,1)-2
  dtm(i,:)=-2*m(i-2,:)-m(i-1,:)+m(i+1,:)+2*m(i+2,:);
end
dtm=dtm/3;
%�ϲ�mfcc������һ�ײ��mfcc����
cc=[m,dtm];
%ȥ����β��֡����Ϊ����֡��һ�ײ�ֲ���Ϊ0
cc=cc(3:size(m,1)-2,:);