clear
clc

%% Draw the Map
Adj=ones(6)-diag([1 1 1 1 1 1]);
names={'A','B','C','D','E','F'};
nStops=length(names);

G=graph(Adj,names);

G.Edges.Weight=[13,4,4,21,2,...
                   9,5,9,10,...
                     1,21,12,...
                        7,3,...
                          10]';
                      
figure(1);
p=plot(G,'EdgeLabel',G.Edges.Weight,'NodeLabel',G.Nodes.Name);
highlight(p,1:nStops,'Marker','p','Markersize',12);
p.XData=[3,1,2,3,4,5];
p.YData=[4,1,1.5,3,1.5,1];
title('Figure for Q10.1');

%% Create Relaxed Problem (without subtour constraints)
tsp=optimproblem;

% decision variable
trips=optimvar('trips',size(G.Edges.Weight),'Type','integer',...
    'LowerBound',0,'UpperBound',1);

% objective function
tsp.Objective=G.Edges.Weight'*trips;

% constraints-travel cicy number constraints
constr1trips=sum(trips)==nStops;
tsp.Constraints.constr1trips=constr1trips;
% constraints-enter and leave each city eaxctly once
idxs=nchoosek(1:nStops,2);
constr2trips=optimconstr(nStops,1);
for stops=1:nStops
    whichIdxs=(idxs==stops);
    whichIdxs=any(whichIdxs,2);
    constr2trips(stops)=sum(trips(whichIdxs))==2;
end
tsp.Constraints.constr2trips=constr2trips;

%% Solve Relaxed Problem
opts=optimoptions('intlinprog','Display','off');
[sol,fval,exitflag,output]=solve(tsp,'Options',opts);

%% Subtour Detection and Elimination
tours = detectSubtours(sol.trips,idxs);
numtours = length(tours); % number of subtours
fprintf('# of subtours: %d\n',numtours);

% Index of added constraints for subtours
k = 1;
while numtours > 1 % repeat until there is just one subtour
    % Add the subtour constraints
    for ii = 1:numtours
        subTourIdx = tours{ii}; % Extract the current subtour
%         The next lines find all of the variables associated with the
%         particular subtour, then add an inequality constraint to prohibit
%         that subtour and all subtours that use those stops.
        variations = nchoosek(1:length(subTourIdx),2);
        a = false(length(idxs),1);
        for jj = 1:length(variations)
            whichVar = (sum(idxs==subTourIdx(variations(jj,1)),2)) & ...
                       (sum(idxs==subTourIdx(variations(jj,2)),2));
            a = a | whichVar;
        end
        tsp.Constraints.(sprintf('subtourconstr%i',k)) = sum(trips(a)) <= length(subTourIdx)-1;
        k = k + 1;
    end
    % Try to optimize again
    [sol,fval,exitflag,output] = solve(tsp,'options',opts);

    % How many subtours this time?
    tours = detectSubtours(sol.trips,idxs);
    numtours = length(tours); % number of subtours
    fprintf('# of subtours: %d\n',numtours);
end

%% Visualize the problem
hold on;
highlight(p,'Edges',find(sol.trips),'EdgeColor','r','LineWidth',1.5);
fprintf('minimum weight: %d\n', fval);

