
function SWM_Art(inputArray)

%NOTE: cannot have addpath command if going to compile with mcc 
addpath /ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/spm12/
addpath /ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/art-2015-10/
addpath /ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/

%Set to the folder that has all ART scripts (i.e., the .cfg files) 
cd '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/SWM_AS/ART/';

%Loop through all files inputted: 
for i=1:length(inputArray)
	input = inputArray{i}; 
	art(input); 
end 
   
end 

