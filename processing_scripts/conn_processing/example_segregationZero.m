%% ********************************************************************************************************************* %%
%%	Run network segregation analysis, REPLACING negative values with 0 (METRIC 3/3)										 %%
%%		KC emailed to KH on 6/23/20; KH updated with notes most recently on 7/16/20										 %%
%%		Generally following KC's steps in network segregation paper														 %%
%% ********************************************************************************************************************* %%

function [seg,within,between,numNegsWithin,numNegsBetween] = example_segregationZero(wholenetwork,nodes)

%% --------------------------------------------------------------------------------------------------------------------- %%
%% 										               FUNCTION SUMMARY										             %% 
%% --------------------------------------------------------------------------------------------------------------------- %%
% SEGREGATION: compute segregation = (within - between) / within
%   Given the following input arguments:
%   	1. wholenetwork: a 2D matrix containing connectivity values 
%		   --> this is the Z matrix from conn_project_*/results/firstlevel/SBC_01/resultsROI_Subject*_Condition001.mat 
%   	2. nodes: a vector indicating the indices of the current subnetwork
%   This function computes the segregation value for the current subnetwork
%   Here, I describe the example of a network where nodes=[1 2 3 4 5 6 7 8 9 10 11 12 13];
%         i.e. ,the first 13 columns of the Z connectivity matrix 

%% --------------------------------------------------------------------------------------------------------------------- %%
%% 										     CALC WITHIN SUBNETWORK CONNECTIVITY										 %% 
%% --------------------------------------------------------------------------------------------------------------------- %%
% 1. First, calculate within subnetwork connectivity

% 1-. *DIF FROM segregation.m*: Set negative values to zero (but we'll still include the 0's in the calculations)
wholenetwork(wholenetwork < 0) = 0;

% 1a. Create a new matrix the size of the Z matrix called 'Diagonal' (e.g., size = 216*216)  
%	  -This matrix 'Diagonal' contains all 0s, except for the diagonal = 1s (i.e., where the Z matrix has NaNs)
Diagonal = diag(ones(size(wholenetwork,1),1));

% 1b. Create a new *logical* matrix the size of the Z matrix called 'Pos' that contains the opposite of 'Diagonal' 
%	  -(i.e., 0s on the diagonal and 1s everywhere else; e.g., size = 216*216) 
Pos = (Diagonal == 0);

% 1c. Establish the connections to be included in the calculation
%	  -Create a new *logical* matrix that is the length/width of 'nodes' 
%     -(i.e., the subnetwork; e.g., size = 13*13) with 0s on the diagonal and 1s everywhere else 
%     **& in the case of segregationZero, you'll have 0s anywhere there was a negative corr value** 
PosSub = Pos(nodes,nodes); 

% 1d. Establish the connection strengths for the included connections
%	  -Create a new matrix called 'subnetwork' that contains ONLY the connectivity values for the nodes subnetwork 
%	  -(i.e., connectivity values pulled from the whole Z matrix)'
subnetwork = wholenetwork(nodes,nodes); 

% 1-. *DIF FROM segregation.m*: Count how many corr values were neg that you then set to = 0 in subnetwork 
numNegsWithin=(sum(subnetwork(:)==0));  

% 1e. Calculate within-network connectivity.
%	  -This is just a straight up average of ALL of the values in the within-network ('subnetwork') connectivity matrix, 
%	   except for the NaNs going down the diagonal. We use the logical 'PosSub' call to keep only the connectivity values 
%      (i.e., where PosSub=1) and to ditch all the NaNs down the diagonal (i.e., where PosSub=0) 
%     -'within' is then just a single value of within network connectivity
% 	  -length(subnetwork(PosSub)) = length(nodes)*length(nodes)-length(nodes) 
%	  -->aka just ((# of nodes in the subnetwork)^2 - # of nodes); e.g., 13*13-13=156 
%     -This is because you're taking the AVERAGE of ALL values in the subnetwork, except for the diagonal (& the diagonal=length(nodes)) 
within = mean(subnetwork(PosSub));

%% --------------------------------------------------------------------------------------------------------------------- %%
%% 										ESTABLISH NODES THAT ARE OUTSIDE CURRENT SUBNETWORK								 %% 
%% --------------------------------------------------------------------------------------------------------------------- %%
% 2. Next, figure out which nodes are outside the current subnetwork

% 2a. Set othernodes = indices of ALL nodes in wholenetwork
othernodes = 1:size(wholenetwork,1);

% 2b. Get rid of indices that match with the node indices for the current subnetwork 
%     -E.g., now length(othernodes) = # columns in wholenetwork - # nodes in the current subnetwork 
%     -E.g., length(othernodes)=216-13=203 
othernodes(nodes)=[];

%% --------------------------------------------------------------------------------------------------------------------- %%
%% 										     CALCULATE BETWEEN-NETWORK CONNECTIVITY								         %% 
%% --------------------------------------------------------------------------------------------------------------------- %%
% 3. Now, calculate the between network connectivity

% 3b. Create a new *logical* matrix of 1s with size = nodes*othernodes (e.g., 13*203)
PosOther = Pos(nodes,othernodes);

% 3c. Pull from wholenetwork (i.e., Z matrix) -> rows based on 'nodes' (e.g., top 13 rows) & columns based on 'othernodes' (e.g., cols 14-216)
%	  So, e.g., you're pulling the 1st 13 rows for cols 14-216 
%	  Note: in this case, you have no NaNs that get pulled because all NaNs for the 1st 13 rows are found in the 1st 13 cols 
%	       (which you are not pulling here; you're starting at col 14)
%	  This is ultimately giving you a matrix called 'othernetwork' that contains the correlation values of the subnetwork 
%	  (e.g., the 1st 13 rows) with all OTHER nodes (e.g., cols 14-216), but NOT with itself (e.g., NOT with cols 1-13) 
othernetwork = wholenetwork(nodes, othernodes); 

% 3-. *DIF FROM segregation.m*: Count how many corr values were neg that you then set to = 0 in othernetwork 
numNegsBetween=(sum(othernetwork(:)==0));  

% 3d. Calculate the average of othernetwork where the logical PosOther=1 to obtain between-network connectivity
%     (i.e., as we did above for within-network connectivity)
%	  Again, this is just the straight up average value for the whole matrix (in this case the matrix called 'othernetwork') 
%	  length(othernetwork(PosOther)) = (# rows)*(# cols) in othernetwork (e.g., 13*203=2639) = (# rows)*(# cols) in othernetwork (e.g., 13*203=2639)
%     Note: there are no NaNs included here (see 3c) so don't need to subtract those to understand length(othernetwork(PosOther))
between = mean(othernetwork(PosOther));

%% --------------------------------------------------------------------------------------------------------------------- %%
%% 										          COMPUTE NETWORK SEGREGATION								             %% 
%% --------------------------------------------------------------------------------------------------------------------- %%
% 4. Finally, compute the segregation
%	 This is the Chan formula for network seg: (Within - Between) / Within 
%    This function returns all 3 of these values: seg, within, & between + numNegs (i.e., num neg vals 
seg = (within - between)/within;

end

