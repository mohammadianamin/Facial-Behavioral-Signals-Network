function Contact_features=ExtractFeature_facs(params,signal,Timestamp_s,Timestamp_s_FACS,ModalitySignal,Stimulus_sel)

% Extarct features from different signal based on the R-codes Pavlidis team and new features
% Author : Amin Mohammadian
% Date:22.10.98
% upDate: 1400/10/13 shamsi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start_time=params.StartPhaseTag;
end_time = params.EndPhaseTag;
step=params.step;
k=1;
cdone=cd;
%%%% set tags of time%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Contact_features.StarttimePhase=params.StartPhaseTag;
Contact_features.EndtimePhase=params.EndPhaseTag;
Contact_features.Window=params.window_size;
SamplingRate=params.SamplingRatefacs;

Contact_features.valid=[];
Contact_features.W(k).FACS=[];
i=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for time_window=min(params.window_size,size(signal,1)/SamplingRate)
    if time_window>end_time
        Contact_features.W(k).FACS=ones(size(signal));
        Contact_features.Stimulus_sel=Stimulus_sel;
        Contact_features.Timestamp=Timestamp_s_FACS;
        Contact_features.valid=zeros(size(signal,1),1);
    end
 
    for t1=start_time:step:end_time-time_window+1
        %%%segmenting signals
        [~,m2]=min(abs(Timestamp_s-t1));
        [minim_time_diff,m2facs]=min(abs(Timestamp_s_FACS-t1));
        if minim_time_diff~=0
            display(minim_time_diff)
        end
        seg_signal=(signal(m2facs:m2facs+time_window*SamplingRate-SamplingRate,:));
        
        
        if(sum(sum(isnan(seg_signal)))<1 && sum(sum(seg_signal))~=0 && size(signal,1)>time_window) % && sum(diff(seg_signal))~=0
            flag_seg_signal=1;
            Contact_features.valid(i)=1;
        else
            flag_seg_signal=0;
            Contact_features.valid(i)=0;
        end
        
        %             %             %%%%%Extracting features
                
       
                if flag_seg_signal
                    try
                        Contact_features.valid(i)=1;
                        cr=corrcoef(seg_signal);
                        cr(isnan(cr))=1;
                        f=triu(cr-10)-cr;
                        c=cov(seg_signal);
                        cc=triu(cov(seg_signal)-10)-cov(seg_signal);
                        distall=[];xcrr=[];fall=[];
                        for ii=1:size(seg_signal,2)
                            for jj=ii+1:size(seg_signal,2)
                                [dist,~,~] = dtw(seg_signal(:,ii),seg_signal(:,jj));
                                cd ('Effective vosogh mfiles')
                                [ef]=effect_connect_moh(seg_signal(:,ii),seg_signal(:,jj));
                                cd(cdone)
                                xmax=max(xcorr(seg_signal(:,ii),seg_signal(:,jj)));
                                xmin=min(xcorr(seg_signal(:,ii),seg_signal(:,jj)));
                                xmean=mean(xcorr(seg_signal(:,ii),seg_signal(:,jj)));
                                distall=[distall dist ];
                                xcrr=[xcrr [xmax xmin xmean]];
                                if ~isempty(ef)
                                    fall=[fall [ef(1,2) ef(2,1)]];
                                else
                                    fall=[fall [0 0]];
                                end
                            end
                        end
                        Contact_features.W(k).FACS=[Contact_features.W(k).FACS ;[cr(f~=-10)' c(cc~=-10)' distall xcrr mean(mean(seg_signal)) fall]];
                    catch
                        cd(cdone)                        
                        Contact_features.W(k).FACS=[Contact_features.W(k).FACS ;ones(1,225)];
                        Contact_features.valid(i)=0;
                        
                    end
                else
                    Contact_features.valid(i)=0;
                    Contact_features.W(k).FACS=[Contact_features.W(k).FACS ;ones(1,225)];
                end
                
        Contact_features.Timestamp(i)=Timestamp_s_FACS(m2facs);
        Contact_features.Stimulus_sel(i)=Stimulus_sel(m2);
        i=i+1;
        
    end
    k=k+1;
end

