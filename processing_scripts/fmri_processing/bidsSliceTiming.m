% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

function [sliceTimeMsec, TRsec] = bidsSliceTiming(fnm)
%return slice acquisition times and repetition time
sliceTime = jsonVal(fnm, '"SliceTiming":');
TRsec = jsonVal(fnm, '"RepetitionTime":');
if mean(sliceTime) > 10
    sliceTimeMsec = sliceTime;  %already in msec    
else    
    sliceTimeMsec = sliceTime * 1000; %convert sec to msec
end
%end bidsSliceTiming();
end

