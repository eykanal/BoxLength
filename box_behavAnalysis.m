function cat = box_behavAnalysis( subject, session )
%
% Usage: [out] = behavAnalysis2( data )
% 
%  data = saved .mat file from behavioral run
%
% Provide a graphical view of subject performance. Summarizes:
% - trial counts by type
% - percent correct
% - response time
% - number of early & late responses
% Only correct responses are analyzed.

dbstop if error

data = ['~/Documents/MATLAB/BoxLength/data/' num2str(subject) '/' num2str(subject) '-' num2str(session)];
load( data, 'trialdata' );

easy = max(max( trialdata.offs ));
hard = min(min( trialdata.offs ));

%
% Behavioral data printout
%

% counts
count_easy_nobias = sum( trialdata.istrial( trialdata.offs == easy & trialdata.leftreward == 3 ) );
count_hard_nobias = sum( trialdata.istrial( trialdata.offs == hard & trialdata.leftreward == 3 ) );
count_easy_left   = sum( trialdata.istrial( trialdata.offs == easy & trialdata.leftreward == 4 ) );
count_hard_left   = sum( trialdata.istrial( trialdata.offs == hard & trialdata.leftreward == 4 ) );
count_easy_right  = sum( trialdata.istrial( trialdata.offs == easy & trialdata.leftreward == 2 ) );
count_hard_right  = sum( trialdata.istrial( trialdata.offs == hard & trialdata.leftreward == 2 ) );

% percent correct
correct_easy_nobias = trialdata.correct( trialdata.offs == easy & trialdata.leftreward == 3 );
correct_hard_nobias = trialdata.correct( trialdata.offs == hard & trialdata.leftreward == 3 );
correct_easy_left   = trialdata.correct( trialdata.offs == easy & trialdata.leftreward == 4 );
correct_hard_left   = trialdata.correct( trialdata.offs == hard & trialdata.leftreward == 4 );
correct_easy_right  = trialdata.correct( trialdata.offs == easy & trialdata.leftreward == 2 );
correct_hard_right  = trialdata.correct( trialdata.offs == hard & trialdata.leftreward == 2 );

% reaction times
rt_easy_nobias = trialdata.respTime( trialdata.offs == easy & trialdata.leftreward == 3 );
rt_hard_nobias = trialdata.respTime( trialdata.offs == hard & trialdata.leftreward == 3 );
rt_easy_left   = trialdata.respTime( trialdata.offs == easy & trialdata.leftreward == 4 );
rt_hard_left   = trialdata.respTime( trialdata.offs == hard & trialdata.leftreward == 4 );
rt_easy_right  = trialdata.respTime( trialdata.offs == easy & trialdata.leftreward == 2 );
rt_hard_right  = trialdata.respTime( trialdata.offs == hard & trialdata.leftreward == 2 );

% missed/early responses
num_early_easy_nobias = sum( trialdata.respTime( trialdata.offs == easy & trialdata.leftreward == 3 ) == 0 );
num_early_easy_left   = sum( trialdata.respTime( trialdata.offs == easy & trialdata.leftreward == 4 ) == 0 );
num_early_easy_right  = sum( trialdata.respTime( trialdata.offs == easy & trialdata.leftreward == 2 ) == 0 );
num_early_hard_nobias = sum( trialdata.respTime( trialdata.offs == hard & trialdata.leftreward == 3 ) == 0 );
num_early_hard_left   = sum( trialdata.respTime( trialdata.offs == hard & trialdata.leftreward == 4 ) == 0 );
num_early_hard_right  = sum( trialdata.respTime( trialdata.offs == hard & trialdata.leftreward == 2 ) == 0 );
num_late_easy_nobias  = sum( trialdata.late( trialdata.offs == easy & trialdata.leftreward == 3 ) );
num_late_easy_left    = sum( trialdata.late( trialdata.offs == easy & trialdata.leftreward == 4 ) );
num_late_easy_right   = sum( trialdata.late( trialdata.offs == easy & trialdata.leftreward == 2 ) );
num_late_hard_nobias  = sum( trialdata.late( trialdata.offs == hard & trialdata.leftreward == 3 ) );
num_late_hard_left    = sum( trialdata.late( trialdata.offs == hard & trialdata.leftreward == 4 ) );
num_late_hard_right   = sum( trialdata.late( trialdata.offs == hard & trialdata.leftreward == 2 ) );

output1 = {'Diff', 'No Bias', 'Left', 'Right';
            'Easy', count_easy_nobias, count_easy_left, count_easy_right;
            'Hard', count_hard_nobias, count_hard_left, count_hard_right; };

output2 = {'timing', 'early x', 'late x', 'early <', 'late <', 'early >', 'late >';
            'easy', num_early_easy_nobias, num_late_easy_nobias, num_early_easy_left, num_late_easy_left, num_early_easy_right, num_late_easy_right;
            'hard', num_early_hard_nobias, num_late_hard_nobias, num_early_hard_left, num_late_hard_left, num_early_hard_right, num_late_hard_right; };
        
output3 = {'Diff', 'Measure', 'avg x', 'var x', 'avg <', 'var <', 'avg >', 'var >';
            'Easy', 'Correct', mean(correct_easy_nobias), var(correct_easy_nobias), mean(correct_easy_left), var(correct_easy_left), mean(correct_easy_right), var(correct_easy_right);
            'Hard', 'Correct', mean(correct_hard_nobias), var(correct_hard_nobias), mean(correct_hard_left), var(correct_hard_left), mean(correct_hard_right), var(correct_hard_right);
            'Easy', 'RT', mean(rt_easy_nobias),    mean(rt_easy_nobias),   mean(rt_easy_left),    mean(rt_easy_left),   mean(rt_easy_right),    mean(rt_easy_right);
            'Hard', 'RT', mean(rt_hard_nobias),    mean(rt_hard_nobias),   mean(rt_hard_left),    mean(rt_hard_left),   mean(rt_hard_right),    mean(rt_hard_right) };

disp(output1);
disp(output2);
disp(output3);
        
%
% Sharareh plots
%

% First need to find quantiles based on reaction time.
raw = trialdata.respTime;

raw_size   = numel( raw );
raw_sorted = sort( reshape( raw, 1, raw_size ) );
raw_q1 = raw_sorted( 1*floor( raw_size / 5 ) );
raw_q2 = raw_sorted( 2*floor( raw_size / 5 ) );
raw_q3 = raw_sorted( 3*floor( raw_size / 5 ) );
raw_q4 = raw_sorted( 4*floor( raw_size / 5 ) );
quant_marker = [raw_q1 raw_q2 raw_q3 raw_q4];

q1 = find( raw > 0      & raw <= raw_q1 );  %#ok
q2 = find( raw > raw_q1 & raw <= raw_q2 );  %#ok
q3 = find( raw > raw_q2 & raw <= raw_q3 );  %#ok
q4 = find( raw > raw_q3 & raw <= raw_q4 );  %#ok
q5 = find( raw > raw_q4 );                  %#ok

% Now categorize the data as congruent (c), incongruent (i), and neutral (n)
% trials. Note that in trialdata.dir, 10 = right, -10 = left.
cat = struct;

for n = 1:5;
    q = eval(['q' num2str(n)]);
    
    temp_rt = trialdata.respTime(q);
    temp_co = trialdata.correct(q);

    cat.c.hard.rt.(['q' num2str(n)]) = temp_rt( ( ( trialdata.dir(q) == 10 & trialdata.leftreward(q) == 2 ) | ( trialdata.dir(q) == -10 & trialdata.leftreward(q) == 4 ) ) & trialdata.offs(q) == hard );
    cat.c.easy.rt.(['q' num2str(n)]) = temp_rt( ( ( trialdata.dir(q) == 10 & trialdata.leftreward(q) == 2 ) | ( trialdata.dir(q) == -10 & trialdata.leftreward(q) == 4 ) ) & trialdata.offs(q) == easy );
    cat.i.hard.rt.(['q' num2str(n)]) = temp_rt( ( ( trialdata.dir(q) == 10 & trialdata.leftreward(q) == 4 ) | ( trialdata.dir(q) == -10 & trialdata.leftreward(q) == 2 ) ) & trialdata.offs(q) == hard );
    cat.i.easy.rt.(['q' num2str(n)]) = temp_rt( ( ( trialdata.dir(q) == 10 & trialdata.leftreward(q) == 4 ) | ( trialdata.dir(q) == -10 & trialdata.leftreward(q) == 2 ) ) & trialdata.offs(q) == easy );
    cat.n.hard.rt.(['q' num2str(n)]) = temp_rt( trialdata.leftreward(q) == 3 & trialdata.offs(q) == hard );
    cat.n.easy.rt.(['q' num2str(n)]) = temp_rt( trialdata.leftreward(q) == 3 & trialdata.offs(q) == easy );

    cat.c.hard.co.(['q' num2str(n)]) = temp_co( ( ( trialdata.dir(q) == 10 & trialdata.leftreward(q) == 2 ) | ( trialdata.dir(q) == -10 & trialdata.leftreward(q) == 4 ) ) & trialdata.offs(q) == hard );
    cat.c.easy.co.(['q' num2str(n)]) = temp_co( ( ( trialdata.dir(q) == 10 & trialdata.leftreward(q) == 2 ) | ( trialdata.dir(q) == -10 & trialdata.leftreward(q) == 4 ) ) & trialdata.offs(q) == easy );
    cat.i.hard.co.(['q' num2str(n)]) = temp_co( ( ( trialdata.dir(q) == 10 & trialdata.leftreward(q) == 4 ) | ( trialdata.dir(q) == -10 & trialdata.leftreward(q) == 2 ) ) & trialdata.offs(q) == hard );
    cat.i.easy.co.(['q' num2str(n)]) = temp_co( ( ( trialdata.dir(q) == 10 & trialdata.leftreward(q) == 4 ) | ( trialdata.dir(q) == -10 & trialdata.leftreward(q) == 2 ) ) & trialdata.offs(q) == easy );
    cat.n.hard.co.(['q' num2str(n)]) = temp_co( trialdata.leftreward(q) == 3 & trialdata.offs(q) == hard );
    cat.n.easy.co.(['q' num2str(n)]) = temp_co( trialdata.leftreward(q) == 3 & trialdata.offs(q) == easy );
end

% create plot data
cond = {'c','i','n'};
diff = {'easy','hard'};
vars = {'rt','co','count'};
meas = {'mean','std'};

cat.plot = [];

% make the plot data
for i=1:length(cond)
    s_cond = cell2mat(cond(i));
    cat.plot.(s_cond) = [];
    for j=1:length(diff)
        s_diff = cell2mat(diff(j));
        cat.plot.(s_cond).(s_diff) = [];
        for k=1:length(vars)
            s_vars = cell2mat(vars(k));
            cat.plot.(s_cond).(s_diff).(s_vars) = [];
            
            % only make mean & var for rt & co
            if ~strcmp(s_vars, 'count')
                for l=1:length(meas)
                    s_meas = meas{l};
                    func = str2func(meas{l});
                    
                    cat.plot.(s_cond).(s_diff).(s_vars).(s_meas) = ...
                        [ feval(func, cat.(s_cond).(s_diff).(s_vars).q1 ) ...
                          feval(func, cat.(s_cond).(s_diff).(s_vars).q2 ) ...
                          feval(func, cat.(s_cond).(s_diff).(s_vars).q3 ) ...
                          feval(func, cat.(s_cond).(s_diff).(s_vars).q4 ) ...
                          feval(func, cat.(s_cond).(s_diff).(s_vars).q5 ) ];

                      % invert if necessary
                      if strcmp(s_cond,'i') && strcmp(s_vars, 'co') && strcmp(s_meas, 'mean')
                          cat.plot.(s_cond).(s_diff).(s_vars).(s_meas) = ...
                              1 - cat.plot.(s_cond).(s_diff).(s_vars).(s_meas);
                      end
                end
                
            % if count, add that structure
            else
                cat.plot.(s_cond).(s_diff).count = ...
                    [ length( cat.(s_cond).(s_diff).co.q1 ) ...
                      length( cat.(s_cond).(s_diff).co.q2 ) ...
                      length( cat.(s_cond).(s_diff).co.q3 ) ...
                      length( cat.(s_cond).(s_diff).co.q4 ) ...
                      length( cat.(s_cond).(s_diff).co.q5 ) ];
            end
        end
    end
end
            
% plot the thing
f = figure('Position',[0 0 1000 600]);
hold on;
% plot( cat.plot.c.hard.x.value, cat.plot.c.hard.y.value, '--b' );
% plot( cat.plot.c.easy.x.value, cat.plot.c.easy.y.value, '-b' );
% plot( cat.plot.i.hard.x.value, cat.plot.i.hard.y.value, '--r' );
% plot( cat.plot.i.easy.x.value, cat.plot.i.easy.y.value, '-r' );
% plot( cat.plot.n.hard.x.value, cat.plot.n.hard.y.value, '--g' );
% plot( cat.plot.n.easy.x.value, cat.plot.n.easy.y.value, '-g' );
errorbar( cat.plot.c.hard.rt.mean, cat.plot.c.hard.co.mean, cat.plot.c.hard.rt.std, '--b' );
errorbar( cat.plot.c.easy.rt.mean, cat.plot.c.easy.co.mean, cat.plot.c.easy.rt.std, '-b' );
errorbar( cat.plot.i.hard.rt.mean, cat.plot.i.hard.co.mean, cat.plot.i.hard.rt.std, '--r' );
errorbar( cat.plot.i.easy.rt.mean, cat.plot.i.easy.co.mean, cat.plot.i.easy.rt.std, '-r' );
errorbar( cat.plot.n.hard.rt.mean, cat.plot.n.hard.co.mean, cat.plot.n.hard.rt.std, '--g' );
errorbar( cat.plot.n.easy.rt.mean, cat.plot.n.easy.co.mean, cat.plot.n.easy.rt.std, '-g' );

scatter( cat.plot.c.hard.rt.mean, cat.plot.c.hard.co.mean, cat.plot.c.hard.count*4, 'ob', 'filled' );
scatter( cat.plot.c.easy.rt.mean, cat.plot.c.easy.co.mean, cat.plot.c.easy.count*4, '^b', 'filled' );
scatter( cat.plot.i.hard.rt.mean, cat.plot.i.hard.co.mean, cat.plot.i.hard.count*4, 'or', 'filled' );
scatter( cat.plot.i.easy.rt.mean, cat.plot.i.easy.co.mean, cat.plot.i.easy.count*4, '^r', 'filled' );
scatter( cat.plot.n.hard.rt.mean, cat.plot.n.hard.co.mean, cat.plot.n.hard.count*4, 'og', 'filled' );
scatter( cat.plot.n.easy.rt.mean, cat.plot.n.easy.co.mean, cat.plot.n.easy.count*4, '^g', 'filled' );

% plot extra lines to show quantile demarcations
quant_marker(5) = trialdata.responseInterval;  % add marker for deadline
line( [trialdata.responseInterval trialdata.responseInterval], [0 1], 'LineWidth', 2, 'Color', [0 0 0] );
fig = gca;
set(fig, 'xtick', round(quant_marker*1000)/1000 );      % custom x labels
set(fig, 'ytick', 0:0.2:1);  % custom y labels
grid on;
axis([ 0.15 trialdata.responseInterval+0.05 0 1 ]);

% legends and labels and stuff
title( sprintf( '%i-%i', subject, session) );
legend( sprintf('Con - %i', hard), sprintf('Con - %i', easy), sprintf('Incon - %i', hard), sprintf('Incon - %i', easy), sprintf('N - %i', hard), sprintf('N - %i', easy) );
ylabel('Prob. of response towards larger reward');

% save image
print( f, '-dpng', ['~/Documents/MATLAB/BoxLength/data/' num2str(subject) '/' num2str(subject) '-' num2str(session) '.png'] );

end