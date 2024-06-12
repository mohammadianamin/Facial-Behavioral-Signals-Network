function Contact_features=Extract_Cor_Feature(params,signal,Timestamp_s)

% Extarct features from different signal based on the R-codes Pavlidis team
% Author : Amin Mohammadian
% Date:22.10.98


%%%% Preprocessing %%%%%%%%%
signal=smoothdata(signal,'movmedian',5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
params.StartPhaseTag=Timestamp_s(1);
params.EndPhaseTag=Timestamp_s(end);

start_time=params.StartPhaseTag;
end_time = params.EndPhaseTag;
step=params.step;
k=1;


%%%% set tags of time%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Contact_features.StarttimePhase=params.StartPhaseTag;
Contact_features.EndtimePhase=params.EndPhaseTag;
Contact_features.Window=params.window_size;
SamplingRate=params.SamplingRate;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for time_window=params.window_size*SamplingRate
    i=1;
    for t1=start_time:step:end_time-time_window
        %%%segmenting signals
        [~,m2]=min(abs(Timestamp_s-t1));
        
        seg_signal=signal(m2:m2+time_window,:);
        if(~sum(sum(seg_signal)==0)>0 && ~sum(sum(diff(seg_signal))==0)>0)
            flag_seg_signal=1;
            
            Contact_features.valid(i)=1;
        else
            flag_seg_signal=0;
            Contact_features.valid(i)=0;
        end
        
        %             %             %%%%%Extracting features
        if flag_seg_signal
            tr=triu(corr(seg_signal),1);
            s=svd(cov(seg_signal));
            Contact_features.W(k).allcor(i,:)=[tr([5 9 10 13 14 15]) s(:)'];
        else
            Contact_features.W(k).allcor(i,:)=ones(1,6+size(signal,2));
        end
        Contact_features.Timestamp(i)=m2;
        i=i+1;
    end
    k=k+1;
end