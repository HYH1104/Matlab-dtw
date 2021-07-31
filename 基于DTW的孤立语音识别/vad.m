% vad.m �˵���
function [StartPoint,EndPoint]=vad(k,fs)
close all;
% ���ȹ�һ����[-1,1]
k=double(k);
k=k./max(abs(k));
%------------------------------
%          ��ʾ����
%------------------------------
disp('��ʾԭʼ����ͼ����');
t=0:1/fs:(length(k)-1)/fs;
subplot(3,1,1);
plot(t,k);
axis([0,(length(k)-1)/fs,min(k),max(k)]);
title('��00.wav�������źŲ���');
xlabel('ʱ��/s');
ylabel('��һ�����');
disp('��ʾ������ʼ���Ŵ���ͼ����');
t1=0.2:1/fs:0.3;
k1=k(0.2*fs:0.3*fs);
subplot(3,1,2);
plot(t1,k1);
axis([0.2,0.3,min(k),max(k)]);
title('��00.wav��������ʼ���Ŵ���ͼ');
xlabel('ʱ��/s');
ylabel('��һ�����');
disp('��ʾ�����������Ŵ���ͼ����');
t1=0.4:1/fs:0.5;
k1=k(0.4*fs:0.5*fs);
subplot(3,1,3);
plot(t1,k1);
axis([0.4,0.5,min(k),max(k)]);
title('��00.wav�������������Ŵ���ͼ');
xlabel('ʱ��/s');
ylabel('��һ�����');
%------------------------------
%        �����ʱ������
%------------------------------
FrameLen=240;
FrameInc=80;
FrameTemp1=enframe(k(1:end-1),FrameLen,FrameInc);
FrameTemp2=enframe(k(2:end),FrameLen,FrameInc);
signs=(FrameTemp1.*FrameTemp2)<0;
diffs=abs(FrameTemp1-FrameTemp2)>0.01;
zcr=sum(signs.*diffs,2);
disp('��ʾԭʼ����ͼ����');
figure,subplot(3,1,1);
plot(t,k);
axis([0,(length(k)-1)/fs,min(k),max(k)]);
title('��00.wav�������źŲ���');
xlabel('ʱ��/s');
ylabel('��һ�����');
disp('��ʾ����ʱ���ʡ���')
zcrInd=1:length(zcr);
subplot(3,1,2);
plot(zcrInd,zcr);
axis([0,length(zcr),0,max(zcr)]);
title('��ʱ������');
xlabel('֡');
ylabel('����');
%------------------------------
%         �����ʱ����
%------------------------------
amp=sum(abs(enframe(filter([1 -0.9375], 1, k), FrameLen, FrameInc)), 2);
disp('��ʾ��ʱ��������')
ampInd=1:length(amp);
subplot(3,1,3);
plot(ampInd,amp);
axis([0,length(amp),0,max(amp)]);
title('��ʱ����');
xlabel('֡');
ylabel('����');
%------------------------------
%         ��������
%------------------------------
disp('�������ޡ���');
ZcrLow=max([round(mean(zcr)*0.1),3]);                   %�����ʵ�����
ZcrHigh=max([round(max(zcr)*0.1),5]);                   %�����ʸ�����
AmpLow=min([min(amp)*10,mean(amp)*0.2,max(amp)*0.1]);   %����������
AmpHigh=max([min(amp)*10,mean(amp)*0.2,max(amp)*0.1]);  %����������
%------------------------------
%         �˵���
%------------------------------
MaxSilence=8;   %�������϶ʱ��
MinAudio=16;    %�������ʱ��
Status=0;       %״̬��0������,1���ɶ�,2������,3������
HoldTime=0;     %��������ʱ��
SilenceTime=0;  %������϶ʱ��
disp('��ʼ�˵��⡭��');
for n=1:length(zcr)
    switch Status
        case{0,1}
            if amp(n)>AmpHigh || zcr(n)>ZcrHigh
                StartPoint=n-HoldTime;
                Status=2;
                HoldTime=HoldTime+1;
                SilenceTime=0;
            elseif amp(n)>AmpLow || zcr(n)>ZcrLow
                Status=1;
                HoldTime=HoldTime+1;
            else
                Status=0;
                HoldTime=0;
            end
        case 2
            if amp(n)>AmpLow || zcr(n)>ZcrLow
                HoldTime=HoldTime+1;
            else
               SilenceTime=SilenceTime+1;
               if SilenceTime<MaxSilence
                   HoldTime=HoldTime+1;
               elseif (HoldTime-SilenceTime)<MinAudio
                   Status=0;
                   HoldTime=0;
                   SilenceTime=0;
               else
                   Status=3;
               end
            end
        case 3
            break;
    end
    if Status==3
        break;
    end
end
HoldTime=HoldTime-SilenceTime;
EndPoint=StartPoint+HoldTime;
disp('��ʾ�˵㡭��');
figure,subplot(3,1,1);
plot(k);
axis([1,length(k),min(k),max(k)]);
title('��00.wav�������ź�');
xlabel('����');
ylabel('����');
line([StartPoint*FrameInc,StartPoint*FrameInc],[min(k),max(k)],'color','red');
line([EndPoint*FrameInc,EndPoint*FrameInc],[min(k),max(k)],'color','red');
subplot(3,1,2);
plot(zcr);
axis([1,length(zcr),0,max(zcr)]);
title('��ʱ������');
xlabel('֡');
ylabel('����');
line([StartPoint,StartPoint],[0,max(zcr)],'Color','red');
line([EndPoint,EndPoint],[0,max(zcr)],'Color','red');
subplot(3,1,3);
plot(amp);
axis([1,length(amp),0,max(amp)]);
title('��ʱ����');
xlabel('֡');
ylabel('����');
line([StartPoint,StartPoint],[0,max(amp)],'Color','red');
line([EndPoint,EndPoint],[0,max(amp)],'Color','red');