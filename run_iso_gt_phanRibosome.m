clear
inputFile= '/Users/rdsouza/Work/Syn_Ribo/energy2DLandscapePD_GreatCircle_180deg.mat';

inputstr1 = 'T_X';
inputstr3 = 'alp1';
inputstr4 = 'alp2';
load(inputFile,inputstr1,inputstr3,inputstr4);
command = ['ys = ',inputstr1,';'];
eval(command);

command = ['clear ',inputstr1,';'];
eval(command);
sig = 700;
y = ys(:,2001:10000);
%y1 = y+sig*2*randn(size(y));

% no noise case
%D = L2_distance(y1,y1,1);
% 
% %% pca
% [coeff,score,latent,tsquared,explained] = pca(y1);
% scatter3(score(:,1),score(:,2),score(:,3))
% axis equal
% xlabel('1st Principal Component')
% ylabel('2nd Principal Component')
% zlabel('3rd Principal Component')

%% isomap
%[Y, R, E]= isomap(D.^2,'k', size(y,2)/10);
%no_dims=2;
%k=200;
%X=y;
%[mappedX, mapping] = isomap3(X, no_dims, k)