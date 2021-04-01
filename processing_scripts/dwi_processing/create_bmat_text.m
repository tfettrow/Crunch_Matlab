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

bval_file = dir('*.bval');
bvec_file = dir('*.bvec');
bval = textread(bval_file.name)';
bvec = textread(bvec_file.name)';

B = bval(:,ones(1,6)).*[bvec(:,1).^2 2*bvec(:,1).*bvec(:,2) 2*bvec(:,1).*bvec(:,3) bvec(:,2).^2 2*bvec(:,2).*bvec(:,3) bvec(:,3).^2];

fid = fopen( 'DWI.txt', 'wt' );
for i=1:size(B,1)    
    fprintf(fid, '%12.8f\t%12.8f\t%12.8f\t%12.8f\t%12.8f\t%12.8f\n',B(i,:));
end
fclose(fid);

