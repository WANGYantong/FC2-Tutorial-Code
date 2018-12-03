%%
clear
clc
%% Q9.2 (i)
weight=[7,1,1,11];
value=[3,1,3,11];
item=['A','B','C','D'];
bagsize=12;

x=optimvar('x',1,length(item),'Type','integer',...
     'LowerBound',0,'UpperBound',1);
weight_constraint=sum(weight.*x)<=bagsize;

Knapsack1=optimproblem;
Knapsack1.Objective=-sum(value.*x);
Knapsack1.Constraints.weight_constraint=weight_constraint;
opts=optimoptions('intlinprog','Display','off');
[sol,fval,exitflag,output]=solve(Knapsack1, 'Options', opts);
fprintf("the total value is %f\nselect\n",-fval);
for ii=1:length(x)
    if round(sol.x(ii))==1
        fprintf('%c\t',item(ii));
    end
end
fprintf('\n/****************************/\n');

%% Q9.2 (ii)
weight=[2,3,5,1];
value=[17,4,20,11];
item=['A','B','C','D'];
bagsize=6;

x=optimvar('x',1,length(item),'Type','integer','LowerBound',0,'UpperBound',1);

weight_constraint=sum(weight.*x)<=bagsize;

Knapsack2=optimproblem;
Knapsack2.Objective=-sum(value.*x);
Knapsack2.Constraints.weight_constraint=weight_constraint;
opts=optimoptions('intlinprog','Display','off');
[sol,fval,exitflag,output]=solve(Knapsack2, 'Options', opts);
fprintf("the total value is %f\nselect\n",-fval);
for ii=1:length(x)
    if round(sol.x(ii))==1
        fprintf('%c\t',item(ii));
    end
end
fprintf('\n/****************************/\n');

%% Q9.2 (iii)
weight=[9,1,1,4,13];
value=[2,2,2,2,18];
item=['A','B','C','D','E'];
bagsize=14;

x=optimvar('x',1,length(item),'Type','integer','LowerBound',0,'UpperBound',1);

weight_constraint=sum(weight.*x)<=bagsize;

Knapsack3=optimproblem;
Knapsack3.Objective=-sum(value.*x);
Knapsack3.Constraints.weight_constraint=weight_constraint;
opts=optimoptions('intlinprog','Display','off');
[sol,fval,exitflag,output]=solve(Knapsack3, 'Options', opts);
fprintf("the total value is %f\nselect\n",-fval);
for ii=1:length(x)
    if round(sol.x(ii))==1
        fprintf('%c\t',item(ii));
    end
end


