% record.m 语音录入
clc;clear all;close all;
[pathstr,name,ext]= fileparts(mfilename('fullpath'));	
Fs=8000;                                  %数据频率 
T=1.1;                                    %采样时间 
n=T*Fs;                                   %采样点数                                
R = audiorecorder( Fs,16 ,1) ;            %通过麦克风以Fs的采样频率采集‘16’位‘1’通道的声音的振幅数据，并存储在R中
disp('开始采集')
record(R);pause(T);stop(R);               %开始录制->延时T秒->停止录制
disp('结束采集')
myspeech = getaudiodata(R);               %将R采集到的振幅数据赋值给myspeech
plot(myspeech)                            %绘制myspeech波形
audiowrite([pathstr,'\test\00.wav'],myspeech,Fs); %将得到的音频存为*.wav