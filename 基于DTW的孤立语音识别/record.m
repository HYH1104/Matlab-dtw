% record.m ����¼��
clc;clear all;close all;
[pathstr,name,ext]= fileparts(mfilename('fullpath'));	
Fs=8000;                                  %����Ƶ�� 
T=1.1;                                    %����ʱ�� 
n=T*Fs;                                   %��������                                
R = audiorecorder( Fs,16 ,1) ;            %ͨ����˷���Fs�Ĳ���Ƶ�ʲɼ���16��λ��1��ͨ����������������ݣ����洢��R��
disp('��ʼ�ɼ�')
record(R);pause(T);stop(R);               %��ʼ¼��->��ʱT��->ֹͣ¼��
disp('�����ɼ�')
myspeech = getaudiodata(R);               %��R�ɼ�����������ݸ�ֵ��myspeech
plot(myspeech)                            %����myspeech����
audiowrite([pathstr,'\test\00.wav'],myspeech,Fs); %���õ�����Ƶ��Ϊ*.wav