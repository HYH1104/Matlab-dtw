% dtwtest.m �������
clear all;close all;clc;
disp('���ڵ���ο�ģ�����...');
load mfcc.mat;
N=1;
disp('���ڼ������ģ��Ĳ���...')
[pathstr,name,ext]= fileparts(mfilename('fullpath'));	
for i=0:N-1
	fname = [pathstr,'\test\',num2str(i),'0.wav'];
    [k,fs]=audioread(fname);
    [StartPoint,EndPoint]=vad(k,fs);
    cc=mfcc(k);
    cc=cc(StartPoint-6:EndPoint-6,:);
    test(i+1).StartPoint=StartPoint;
    test(i+1).EndPoint=EndPoint;
    test(i+1).mfcc=cc;
end
if N==1
    fprintf('�������ֽ���ģ��ƥ�����С�����\n')
else
    fprintf('%d�����ֽ���ģ��ƥ�����С�����\n',N)
end
dist = zeros(10,10);
for i=1:N
    for j=1:14
        dist(i,j) = dtw(test(i).mfcc, ref(j).mfcc);
    end
end

disp('���ڼ���ƥ����...')
disp(' ')
for i=1:N
    a=["��0��","��1��","��2��","��3��","��4��","��5��","��6��","��7��","��8��","��9��","��10��"];
    [d,j] = min(dist(i,:));
    fprintf(2,'���Ե���ģ�� %d0.wav ������ʶ����Ϊ��%s\n', i-1, a(j));
end
clear all