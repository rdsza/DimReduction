clear

addpath('toolbox_signal/');
addpath('toolbox_general/');
addpath('toolbox_graph/');

n = 1000;
x = randn(2,n);
v = 3*pi/2 * (.1 + 2*x(1,:));
X  = zeros(3,n);
X(2,:) = 20 * x(2,:);
X(1,:) = - cos( v ) .* v;
X(3,:) = sin( v ) .* v;
ms = 50;
lw = 1.5;
v1 = -15; v2 = 20;

figure;
scatter3(X(1,:),X(2,:),X(3,:),ms,v, 'filled');
colormap jet(256);
view(v1,v2); axis('equal'); axis('on');

D1 = repmat(sum(X.^2,1),n,1);
D1 = sqrt(D1 + D1' - 2*X'*X);

k = 10;

[DNN,NN] = sort(D1);
NN = NN(2:k+1,:);
DNN = DNN(2:k+1,:);

B = repmat(1:n, [k 1]);
A = sparse(B(:), NN(:), ones(k*n,1));
W = sparse(B(:), NN(:), DNN(:));

figure;
options.lw = lw;
options.ps = 0.01;
clf; hold on;
scatter3(X(1,:),X(2,:),X(3,:),ms,v, 'filled');
plot_graph(A, X, options);
colormap jet(256);
view(v1,v2); axis('equal'); axis('on');
zoom(.8);

D = full(W);
D = (D+D')/2;
D(D==0) = Inf;
D = D - diag(diag(D));

%% exercise 1
for i=1:n
    % progressbar(i,n);
    D = min(D,repmat(D(:,i),[1 n])+repmat(D(i,:),[n 1])); 
end
Iremove = find(D(:,1)==Inf);
D(D==Inf) = 0;

%% exercise 2
% centered kernel
J = eye(n) - ones(n)/n;
K = -1/2 * J*(D.^2)*J;
% diagonalization
opt.disp = 0; 
[Xstrain, val] = eigs(K, 2, 'LR', opt);
Xstrain = Xstrain .* repmat(sqrt(diag(val))', [n 1]);
Xstrain = Xstrain';
% plot graph
figure;
clf; hold on;
scatter(Xstrain(1,:),Xstrain(2,:),ms,v, 'filled'); 
plot_graph(A, Xstrain, options);
colormap jet(256);
axis('equal'); axis('off'); 

[U,L] = eig(Xstrain*Xstrain' / n);
Xstrain1 = U'*Xstrain;
Xstrain1(:,Iremove) = Inf;
figure;
clf; hold on;
scatter(Xstrain1(1,:),Xstrain1(2,:),ms,v, 'filled');
plot_graph(A, Xstrain1, options);
colormap jet(256);
axis('equal'); axis('off');

Y = cat(1, v, X(2,:));
Y(1,:) = rescale(Y(1,:), min(Xstrain(1,:)), max(Xstrain(1,:)));
Y(2,:) = rescale(Y(2,:), min(Xstrain(2,:)), max(Xstrain(2,:)));
figure;
clf; hold on;
scatter(Y(1,:),Y(2,:),ms,v, 'filled');
plot_graph(A,  Y, options);
colormap jet(256);
axis('equal'); axis('off');
camroll(90);