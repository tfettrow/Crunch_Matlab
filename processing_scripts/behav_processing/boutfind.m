a1 = dir;
for file = 3:length(a1)
    readtable(a1(file).name); %read in csv data
    [hr,min,~]=hms(timeofday(ans{:,1})); %extract time of day and split hours and minutes of day (@4 hr format)
    idx=find(hr==0 & min==0); %find all the index values when a new day starts, hr = 0 and min = 0
    steps = ans{:,5}; % extract steps data
    idx(length(idx)+1,1) = length(steps); % add last wear point index
    idx(length(idx)+1,1) = 0; % add first starting day point index
    idx=wshift('1D',idx,-1); % shift the data left to align the start and end of wear time
    for day_1 = 1:length(idx)-1
        peak1(day_1,1) = max(steps(idx(day_1,1)+1:idx(day_1+1,1),1)); %identify the max steps/min during each wear day
        step_sort{day_1,1} = sort(steps(idx(day_1,1)+1:idx(day_1+1,1),1),'descend'); %sort the steps of the wear day, high to low
        peak30(day_1,1) = mean(step_sort{day_1,1}(1:30,1)); %take the mean of the first 30 steps/min values
    end
    
    %identifying # of bouts per day where >=60 steps/min for >=2mins
    for day_1 = 1:length(idx)-1
        boutcount{day_1,1}(1,1) = 0; %initialize
        %     boutsteps{day_1,1}(1,1) = 0; %initialize
        if any(steps(idx(day_1,1)+1:idx(day_1+1,1),1) >= 60) %check to see if there are any bouts at all
            idx2{day_1,1} = find(steps(idx(day_1,1)+1:idx(day_1+1,1),1) >= 60); %find the index of when the bouts are occuring
            idx2_diff{day_1,1} = diff(idx2{day_1,1}); %find the difference in index value, a diff of 1 = consecuitive index values
            %       a1{day_1,1} = find(idx2_diff{day_1,1}( ~= 1 && idx2_diff{day_1,1}); %find when bouts end/change
            if any(idx2_diff{day_1,1} == 1) % if there are any consecutive index values, calculate # of bouts
                for x = 1:length(idx2_diff{day_1,1}(:,1))-1
                    if (idx2_diff{day_1,1}(x,1)==1 && x == 1) %if first index diff is 1, then make bout count 1
                        boutcount{day_1,1}(1,1) = boutcount{day_1,1}(1,1)+1;
                        %                     boutsteps{day_1,boutcount{day_1,1}(1,1)}(x,1) = steps(idx2{day_1,1}(x,1))
                    elseif (idx2_diff{day_1,1}(x,1)==1 && x > 1) %if following diff values are 1, continue until next >1 diff value
                        if idx2_diff{day_1,1}(x+1,1)==1
                            %                         boutsteps{day_1,boutcount{day_1,1}(1,1)+1}(x,1) = steps(idx2{day_1,1}(x,1))
                            continue
                        else
                            boutcount{day_1,1}(1,1) = boutcount{day_1,1}(1,1)+1; %if value is not 1, bout ended, start next bout
                        end
                    end
                end
            end
        else
            boutcount{day_1,1}(1,1) = 0; %if no diff = 1 values, no bouts are present
            idx2{day_1,1} = 0;
            idx2_diff{day_1,1} = 0;
        end
        %boutsteps{day_1,bcount}=steps(idx2{day_1,1}(a1{day_1,1}(x,1))):steps(idx2{day_1,1}(a1{day_1,1}(x+1,1)));
    end
    t = table(peak1,peak30,cell2mat(boutcount),'VariableNames',{'Peak1';'Peak30';'Boutcount'});
    writetable(t,fullfile('..',a1(file).name));
    clearvars -EXCEPT a1 file
end