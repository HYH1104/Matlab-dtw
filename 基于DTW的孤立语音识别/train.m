% train.m 数据库生成
disp('正在生成训练参数……');
[pathstr,name,ext]= fileparts(mfilename('fullpath'));
a=["“0”","“1”","“2”","“3”","“4”","“5”","“6”","“7”","“8”","“9”","“10”"];
for i=0:10
    fname=sprintf('train\\%d0.wav',i);
    fprintf(2,'正在生成%s训练参数……\n',a(i+1));
    [k,fs]=audioread(fname);
    [StartPoint,EndPoint]=vad(k,fs);
    cc=mfcc(k);
    cc=cc(StartPoint-6:EndPoint-6,:);
    ref(i+1).StartPoint=StartPoint;
    ref(i+1).EndPoint=EndPoint;
    ref(i+1).mfcc=cc;
end
disp('正在存储模板库……');
save mfcc.mat ref;
close all;