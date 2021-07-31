% dtwtest.m 语音检测
clear all;close all;clc;
disp('正在导入参考模板参数...');
load mfcc.mat;
N=1;
disp('正在计算测试模板的参数...')
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
    fprintf('单个数字进行模板匹配检测中。。。\n')
else
    fprintf('%d个数字进行模板匹配检测中。。。\n',N)
end
dist = zeros(10,10);
for i=1:N
    for j=1:14
        dist(i,j) = dtw(test(i).mfcc, ref(j).mfcc);
    end
end

disp('正在计算匹配结果...')
disp(' ')
for i=1:N
    a=["“0”","“1”","“2”","“3”","“4”","“5”","“6”","“7”","“8”","“9”","“10”"];
    [d,j] = min(dist(i,:));
    fprintf(2,'测试到的模板 %d0.wav 的语音识别结果为：%s\n', i-1, a(j));
end
clear all