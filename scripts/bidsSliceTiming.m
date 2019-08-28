function [sliceTimeMsec, TRsec] = bidsSliceTiming(fnm)
%return slice acquisition times and repetition time
sliceTime = jsonVal(fnm, '"SliceTiming":');
TRsec = jsonVal(fnm, '"RepetitionTime":');
sliceTimeMsec = sliceTime * 1000; %convert sec to msec
%end bidsSliceTiming();
end

