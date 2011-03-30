function cat = box_behavAnalysis2( subject, session )
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

% print it all out
% fprintf( '\nDiff\tNobias\tLeft\tRight\n' );
% fprintf( 'Easy\t%i\t%i\t%i\n', count_easy_nobias, count_easy_left, count_easy_right );
% fprintf( 'Hard\t%i\t%i\t%i\n', count_hard_nobias, count_hard_left, count_hard_right );
% fprintf( 'Easy\tearly/late\t%i/%i\t%i/%i\t%i/%i\n', num_early_easy_nobias, num_late_easy_nobias, num_early_easy_left, num_late_easy_left, num_early_easy_right, num_late_easy_right );
% fprintf( 'Hard\tearly/late\t%i/%i\t%i/%i\t%i/%i\n\n', num_early_hard_nobias, num_late_hard_nobias, num_early_hard_left, num_late_hard_left, num_early_hard_right, num_late_hard_right );
% 
% fprintf( 'Diff\tMeasure\t\tavg (sd), x\t\tavg (sd), <|\t\tavg (sd), |>\t\n' );
% fprintf( 'Easy\tcorrect\t\t%01.4f (%01.4f)\t\t%01.4f (%01.4f)\t\t%01.4f (%01.4f)\n', mean(correct_easy_nobias), var(correct_easy_nobias), mean(correct_easy_left), var(correct_easy_left), mean(correct_easy_right), var(correct_easy_right) );
% fprintf( 'Hard\tcorrect\t\t%01.4f (%01.4f)\t\t%01.4f (%01.4f)\t\t%01.4f (%01.4f)\n', mean(correct_hard_nobias), var(correct_hard_nobias), mean(correct_hard_left), var(correct_hard_left), mean(correct_hard_right), var(correct_hard_right) );
% fprintf( 'Easy\tRT\t\t%01.4f (%01.4f)\t\t%01.4f (%01.4f)\t\t%01.4f (%01.4f)\n',      mean(rt_easy_nobias),    mean(rt_easy_nobias),   mean(rt_easy_left),    mean(rt_easy_left),   mean(rt_easy_right),    mean(rt_easy_right) );
% fprintf( 'Hard\tRT\t\t%01.4f (%01.4f)\t\t%01.4f (%01.4f)\t\t%01.4f (%01.4f)\n\n',    mean(rt_hard_nobias),    mean(rt_hard_nobias),   mean(rt_hard_left),    mean(rt_hard_left),   mean(rt_hard_right),    mean(rt_hard_right) );

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

q1 = find( raw > 0      & raw <= raw_q1 );
q2 = find( raw > raw_q1 & raw <= raw_q2 );
q3 = find( raw > raw_q2 & raw <= raw_q3 );
q4 = find( raw > raw_q3 & raw <= raw_q4 );
q5 = find( raw > raw_q4 );

% Now categorize the data as congruent (c), incongruent (i), and neutral (n)
% trials. Note that in trialdata.dir, 10 = right, -10 = left.
cat = struct;

temp_rt = trialdata.respTime(q1);
temp_co = trialdata.correct(q1);

cat.c.hard.rt.q1 = temp_rt( ( ( trialdata.dir(q1) == 10 & trialdata.leftreward(q1) == 2 ) | ( trialdata.dir(q1) == -10 & trialdata.leftreward(q1) == 4 ) ) & trialdata.offs(q1) == hard );
cat.c.easy.rt.q1 = temp_rt( ( ( trialdata.dir(q1) == 10 & trialdata.leftreward(q1) == 2 ) | ( trialdata.dir(q1) == -10 & trialdata.leftreward(q1) == 4 ) ) & trialdata.offs(q1) == easy );
cat.i.hard.rt.q1 = temp_rt( ( ( trialdata.dir(q1) == 10 & trialdata.leftreward(q1) == 4 ) | ( trialdata.dir(q1) == -10 & trialdata.leftreward(q1) == 2 ) ) & trialdata.offs(q1) == hard );
cat.i.easy.rt.q1 = temp_rt( ( ( trialdata.dir(q1) == 10 & trialdata.leftreward(q1) == 4 ) | ( trialdata.dir(q1) == -10 & trialdata.leftreward(q1) == 2 ) ) & trialdata.offs(q1) == easy );
cat.n.hard.rt.q1 = temp_rt( trialdata.leftreward(q1) == 3 & trialdata.offs(q1) == hard );
cat.n.easy.rt.q1 = temp_rt( trialdata.leftreward(q1) == 3 & trialdata.offs(q1) == easy );

cat.c.hard.co.q1 = temp_co( ( ( trialdata.dir(q1) == 10 & trialdata.leftreward(q1) == 2 ) | ( trialdata.dir(q1) == -10 & trialdata.leftreward(q1) == 4 ) ) & trialdata.offs(q1) == hard );
cat.c.easy.co.q1 = temp_co( ( ( trialdata.dir(q1) == 10 & trialdata.leftreward(q1) == 2 ) | ( trialdata.dir(q1) == -10 & trialdata.leftreward(q1) == 4 ) ) & trialdata.offs(q1) == easy );
cat.i.hard.co.q1 = temp_co( ( ( trialdata.dir(q1) == 10 & trialdata.leftreward(q1) == 4 ) | ( trialdata.dir(q1) == -10 & trialdata.leftreward(q1) == 2 ) ) & trialdata.offs(q1) == hard );
cat.i.easy.co.q1 = temp_co( ( ( trialdata.dir(q1) == 10 & trialdata.leftreward(q1) == 4 ) | ( trialdata.dir(q1) == -10 & trialdata.leftreward(q1) == 2 ) ) & trialdata.offs(q1) == easy );
cat.n.hard.co.q1 = temp_co( trialdata.leftreward(q1) == 3 & trialdata.offs(q1) == hard );
cat.n.easy.co.q1 = temp_co( trialdata.leftreward(q1) == 3 & trialdata.offs(q1) == easy );

temp_rt = trialdata.respTime(q2);
temp_co = trialdata.correct(q2);

cat.c.hard.rt.q2 = temp_rt( ( ( trialdata.dir(q2) == 10 & trialdata.leftreward(q2) == 2 ) | ( trialdata.dir(q2) == -10 & trialdata.leftreward(q2) == 4 ) ) & trialdata.offs(q2) == hard );
cat.c.easy.rt.q2 = temp_rt( ( ( trialdata.dir(q2) == 10 & trialdata.leftreward(q2) == 2 ) | ( trialdata.dir(q2) == -10 & trialdata.leftreward(q2) == 4 ) ) & trialdata.offs(q2) == easy );
cat.i.hard.rt.q2 = temp_rt( ( ( trialdata.dir(q2) == 10 & trialdata.leftreward(q2) == 4 ) | ( trialdata.dir(q2) == -10 & trialdata.leftreward(q2) == 2 ) ) & trialdata.offs(q2) == hard );
cat.i.easy.rt.q2 = temp_rt( ( ( trialdata.dir(q2) == 10 & trialdata.leftreward(q2) == 4 ) | ( trialdata.dir(q2) == -10 & trialdata.leftreward(q2) == 2 ) ) & trialdata.offs(q2) == easy );
cat.n.hard.rt.q2 = temp_rt( trialdata.leftreward(q2) == 3 & trialdata.offs(q2) == hard );
cat.n.easy.rt.q2 = temp_rt( trialdata.leftreward(q2) == 3 & trialdata.offs(q2) == easy );

cat.c.hard.co.q2 = temp_co( ( ( trialdata.dir(q2) == 10 & trialdata.leftreward(q2) == 2 ) | ( trialdata.dir(q2) == -10 & trialdata.leftreward(q2) == 4 ) ) & trialdata.offs(q2) == hard );
cat.c.easy.co.q2 = temp_co( ( ( trialdata.dir(q2) == 10 & trialdata.leftreward(q2) == 2 ) | ( trialdata.dir(q2) == -10 & trialdata.leftreward(q2) == 4 ) ) & trialdata.offs(q2) == easy );
cat.i.hard.co.q2 = temp_co( ( ( trialdata.dir(q2) == 10 & trialdata.leftreward(q2) == 4 ) | ( trialdata.dir(q2) == -10 & trialdata.leftreward(q2) == 2 ) ) & trialdata.offs(q2) == hard );
cat.i.easy.co.q2 = temp_co( ( ( trialdata.dir(q2) == 10 & trialdata.leftreward(q2) == 4 ) | ( trialdata.dir(q2) == -10 & trialdata.leftreward(q2) == 2 ) ) & trialdata.offs(q2) == easy );
cat.n.hard.co.q2 = temp_co( trialdata.leftreward(q2) == 3 & trialdata.offs(q2) == hard );
cat.n.easy.co.q2 = temp_co( trialdata.leftreward(q2) == 3 & trialdata.offs(q2) == easy );

temp_rt = trialdata.respTime(q3);
temp_co = trialdata.correct(q3);

cat.c.hard.rt.q3 = temp_rt( ( ( trialdata.dir(q3) == 10 & trialdata.leftreward(q3) == 2 ) | ( trialdata.dir(q3) == -10 & trialdata.leftreward(q3) == 4 ) ) & trialdata.offs(q3) == hard );
cat.c.easy.rt.q3 = temp_rt( ( ( trialdata.dir(q3) == 10 & trialdata.leftreward(q3) == 2 ) | ( trialdata.dir(q3) == -10 & trialdata.leftreward(q3) == 4 ) ) & trialdata.offs(q3) == easy );
cat.i.hard.rt.q3 = temp_rt( ( ( trialdata.dir(q3) == 10 & trialdata.leftreward(q3) == 4 ) | ( trialdata.dir(q3) == -10 & trialdata.leftreward(q3) == 2 ) ) & trialdata.offs(q3) == hard );
cat.i.easy.rt.q3 = temp_rt( ( ( trialdata.dir(q3) == 10 & trialdata.leftreward(q3) == 4 ) | ( trialdata.dir(q3) == -10 & trialdata.leftreward(q3) == 2 ) ) & trialdata.offs(q3) == easy );
cat.n.hard.rt.q3 = temp_rt( trialdata.leftreward(q3) == 3 & trialdata.offs(q3) == hard );
cat.n.easy.rt.q3 = temp_rt( trialdata.leftreward(q3) == 3 & trialdata.offs(q3) == easy );

cat.c.hard.co.q3 = temp_co( ( ( trialdata.dir(q3) == 10 & trialdata.leftreward(q3) == 2 ) | ( trialdata.dir(q3) == -10 & trialdata.leftreward(q3) == 4 ) ) & trialdata.offs(q3) == hard );
cat.c.easy.co.q3 = temp_co( ( ( trialdata.dir(q3) == 10 & trialdata.leftreward(q3) == 2 ) | ( trialdata.dir(q3) == -10 & trialdata.leftreward(q3) == 4 ) ) & trialdata.offs(q3) == easy );
cat.i.hard.co.q3 = temp_co( ( ( trialdata.dir(q3) == 10 & trialdata.leftreward(q3) == 4 ) | ( trialdata.dir(q3) == -10 & trialdata.leftreward(q3) == 2 ) ) & trialdata.offs(q3) == hard );
cat.i.easy.co.q3 = temp_co( ( ( trialdata.dir(q3) == 10 & trialdata.leftreward(q3) == 4 ) | ( trialdata.dir(q3) == -10 & trialdata.leftreward(q3) == 2 ) ) & trialdata.offs(q3) == easy );
cat.n.hard.co.q3 = temp_co( trialdata.leftreward(q3) == 3 & trialdata.offs(q3) == hard );
cat.n.easy.co.q3 = temp_co( trialdata.leftreward(q3) == 3 & trialdata.offs(q3) == easy );

temp_rt = trialdata.respTime(q4);
temp_co = trialdata.correct(q4);

cat.c.hard.rt.q4 = temp_rt( ( ( trialdata.dir(q4) == 10 & trialdata.leftreward(q4) == 2 ) | ( trialdata.dir(q4) == -10 & trialdata.leftreward(q4) == 4 ) ) & trialdata.offs(q4) == hard );
cat.c.easy.rt.q4 = temp_rt( ( ( trialdata.dir(q4) == 10 & trialdata.leftreward(q4) == 2 ) | ( trialdata.dir(q4) == -10 & trialdata.leftreward(q4) == 4 ) ) & trialdata.offs(q4) == easy );
cat.i.hard.rt.q4 = temp_rt( ( ( trialdata.dir(q4) == 10 & trialdata.leftreward(q4) == 4 ) | ( trialdata.dir(q4) == -10 & trialdata.leftreward(q4) == 2 ) ) & trialdata.offs(q4) == hard );
cat.i.easy.rt.q4 = temp_rt( ( ( trialdata.dir(q4) == 10 & trialdata.leftreward(q4) == 4 ) | ( trialdata.dir(q4) == -10 & trialdata.leftreward(q4) == 2 ) ) & trialdata.offs(q4) == easy );
cat.n.hard.rt.q4 = temp_rt( trialdata.leftreward(q4) == 3 & trialdata.offs(q4) == hard );
cat.n.easy.rt.q4 = temp_rt( trialdata.leftreward(q4) == 3 & trialdata.offs(q4) == easy );

cat.c.hard.co.q4 = temp_co( ( ( trialdata.dir(q4) == 10 & trialdata.leftreward(q4) == 2 ) | ( trialdata.dir(q4) == -10 & trialdata.leftreward(q4) == 4 ) ) & trialdata.offs(q4) == hard );
cat.c.easy.co.q4 = temp_co( ( ( trialdata.dir(q4) == 10 & trialdata.leftreward(q4) == 2 ) | ( trialdata.dir(q4) == -10 & trialdata.leftreward(q4) == 4 ) ) & trialdata.offs(q4) == easy );
cat.i.hard.co.q4 = temp_co( ( ( trialdata.dir(q4) == 10 & trialdata.leftreward(q4) == 4 ) | ( trialdata.dir(q4) == -10 & trialdata.leftreward(q4) == 2 ) ) & trialdata.offs(q4) == hard );
cat.i.easy.co.q4 = temp_co( ( ( trialdata.dir(q4) == 10 & trialdata.leftreward(q4) == 4 ) | ( trialdata.dir(q4) == -10 & trialdata.leftreward(q4) == 2 ) ) & trialdata.offs(q4) == easy );
cat.n.hard.co.q4 = temp_co( trialdata.leftreward(q4) == 3 & trialdata.offs(q4) == hard );
cat.n.easy.co.q4 = temp_co( trialdata.leftreward(q4) == 3 & trialdata.offs(q4) == easy );

temp_rt = trialdata.respTime(q5);
temp_co = trialdata.correct(q5);

cat.c.hard.rt.q5 = temp_rt( ( ( trialdata.dir(q5) == 10 & trialdata.leftreward(q5) == 2 ) | ( trialdata.dir(q5) == -10 & trialdata.leftreward(q5) == 4 ) ) & trialdata.offs(q5) == hard );
cat.c.easy.rt.q5 = temp_rt( ( ( trialdata.dir(q5) == 10 & trialdata.leftreward(q5) == 2 ) | ( trialdata.dir(q5) == -10 & trialdata.leftreward(q5) == 4 ) ) & trialdata.offs(q5) == easy );
cat.i.hard.rt.q5 = temp_rt( ( ( trialdata.dir(q5) == 10 & trialdata.leftreward(q5) == 4 ) | ( trialdata.dir(q5) == -10 & trialdata.leftreward(q5) == 2 ) ) & trialdata.offs(q5) == hard );
cat.i.easy.rt.q5 = temp_rt( ( ( trialdata.dir(q5) == 10 & trialdata.leftreward(q5) == 4 ) | ( trialdata.dir(q5) == -10 & trialdata.leftreward(q5) == 2 ) ) & trialdata.offs(q5) == easy );
cat.n.hard.rt.q5 = temp_rt( trialdata.leftreward(q5) == 3 & trialdata.offs(q5) == hard );
cat.n.easy.rt.q5 = temp_rt( trialdata.leftreward(q5) == 3 & trialdata.offs(q5) == easy );

cat.c.hard.co.q5 = temp_co( ( ( trialdata.dir(q5) == 10 & trialdata.leftreward(q5) == 2 ) | ( trialdata.dir(q5) == -10 & trialdata.leftreward(q5) == 4 ) ) & trialdata.offs(q5) == hard );
cat.c.easy.co.q5 = temp_co( ( ( trialdata.dir(q5) == 10 & trialdata.leftreward(q5) == 2 ) | ( trialdata.dir(q5) == -10 & trialdata.leftreward(q5) == 4 ) ) & trialdata.offs(q5) == easy );
cat.i.hard.co.q5 = temp_co( ( ( trialdata.dir(q5) == 10 & trialdata.leftreward(q5) == 4 ) | ( trialdata.dir(q5) == -10 & trialdata.leftreward(q5) == 2 ) ) & trialdata.offs(q5) == hard );
cat.i.easy.co.q5 = temp_co( ( ( trialdata.dir(q5) == 10 & trialdata.leftreward(q5) == 4 ) | ( trialdata.dir(q5) == -10 & trialdata.leftreward(q5) == 2 ) ) & trialdata.offs(q5) == easy );
cat.n.hard.co.q5 = temp_co( trialdata.leftreward(q5) == 3 & trialdata.offs(q5) == hard );
cat.n.easy.co.q5 = temp_co( trialdata.leftreward(q5) == 3 & trialdata.offs(q5) == easy );

% create plot data
cat.plot.c.hard.x.value = [ mean( cat.c.hard.rt.q1 ) ...
                          mean( cat.c.hard.rt.q2 ) ...
                          mean( cat.c.hard.rt.q3 ) ...
                          mean( cat.c.hard.rt.q4 ) ...
                          mean( cat.c.hard.rt.q5 ) ];
cat.plot.c.hard.y.value = [ mean( cat.c.hard.co.q1 ) ...
                          mean( cat.c.hard.co.q2 ) ...
                          mean( cat.c.hard.co.q3 ) ...
                          mean( cat.c.hard.co.q4 ) ...
                          mean( cat.c.hard.co.q5 ) ];
cat.plot.c.easy.x.value = [ mean( cat.c.easy.rt.q1 ) ...
                          mean( cat.c.easy.rt.q2 ) ...
                          mean( cat.c.easy.rt.q3 ) ...
                          mean( cat.c.easy.rt.q4 ) ...
                          mean( cat.c.easy.rt.q5 ) ];
cat.plot.c.easy.y.value = [ mean( cat.c.easy.co.q1 ) ...
                          mean( cat.c.easy.co.q2 ) ...
                          mean( cat.c.easy.co.q3 ) ...
                          mean( cat.c.easy.co.q4 ) ...
                          mean( cat.c.easy.co.q5 ) ];
cat.plot.i.hard.x.value = [ mean( cat.i.hard.rt.q1 ) ...
                          mean( cat.i.hard.rt.q2 ) ...
                          mean( cat.i.hard.rt.q3 ) ...
                          mean( cat.i.hard.rt.q4 ) ...
                          mean( cat.i.hard.rt.q5 ) ];
cat.plot.i.hard.y.value = [ 1-mean( cat.i.hard.co.q1 ) ...
                          1-mean( cat.i.hard.co.q2 ) ...
                          1-mean( cat.i.hard.co.q3 ) ...
                          1-mean( cat.i.hard.co.q4 ) ...
                          1-mean( cat.i.hard.co.q5 ) ];
cat.plot.i.easy.x.value = [ mean( cat.i.easy.rt.q1 ) ...
                          mean( cat.i.easy.rt.q2 ) ...
                          mean( cat.i.easy.rt.q3 ) ...
                          mean( cat.i.easy.rt.q4 ) ...
                          mean( cat.i.easy.rt.q5 ) ];
cat.plot.i.easy.y.value = [ 1-mean( cat.i.easy.co.q1 ) ...
                          1-mean( cat.i.easy.co.q2 ) ...
                          1-mean( cat.i.easy.co.q3 ) ...
                          1-mean( cat.i.easy.co.q4 ) ...
                          1-mean( cat.i.easy.co.q5 ) ];
cat.plot.n.hard.x.value = [ mean( cat.n.hard.rt.q1 ) ...
                          mean( cat.n.hard.rt.q2 ) ...
                          mean( cat.n.hard.rt.q3 ) ...
                          mean( cat.n.hard.rt.q4 ) ...
                          mean( cat.n.hard.rt.q5 ) ];
cat.plot.n.hard.y.value = [ mean( cat.n.hard.co.q1 ) ...
                          mean( cat.n.hard.co.q2 ) ...
                          mean( cat.n.hard.co.q3 ) ...
                          mean( cat.n.hard.co.q4 ) ...
                          mean( cat.n.hard.co.q5 ) ];
cat.plot.n.easy.x.value = [ mean( cat.n.easy.rt.q1 ) ...
                          mean( cat.n.easy.rt.q2 ) ...
                          mean( cat.n.easy.rt.q3 ) ...
                          mean( cat.n.easy.rt.q4 ) ...
                          mean( cat.n.easy.rt.q5 ) ];
cat.plot.n.easy.y.value = [ mean( cat.n.easy.co.q1 ) ...
                          mean( cat.n.easy.co.q2 ) ...
                          mean( cat.n.easy.co.q3 ) ...
                          mean( cat.n.easy.co.q4 ) ...
                          mean( cat.n.easy.co.q5 ) ];
% determine how many trials of each type, so as to vary dot size
cat.plot.c.hard.count = [ length( cat.c.hard.co.q1 ) ...
                          length( cat.c.hard.co.q2 ) ...
                          length( cat.c.hard.co.q3 ) ...
                          length( cat.c.hard.co.q4 ) ...
                          length( cat.c.hard.co.q5 ) ];
cat.plot.c.easy.count = [ length( cat.c.easy.co.q1 ) ...
                          length( cat.c.easy.co.q2 ) ...
                          length( cat.c.easy.co.q3 ) ...
                          length( cat.c.easy.co.q4 ) ...
                          length( cat.c.easy.co.q5 ) ];
cat.plot.i.hard.count = [ length( cat.i.hard.co.q1 ) ...
                          length( cat.i.hard.co.q2 ) ...
                          length( cat.i.hard.co.q3 ) ...
                          length( cat.i.hard.co.q4 ) ...
                          length( cat.i.hard.co.q5 ) ];
cat.plot.i.easy.count = [ length( cat.i.easy.co.q1 ) ...
                          length( cat.i.easy.co.q2 ) ...
                          length( cat.i.easy.co.q3 ) ...
                          length( cat.i.easy.co.q4 ) ...
                          length( cat.i.easy.co.q5 ) ];
cat.plot.n.hard.count = [ length( cat.n.hard.co.q1 ) ...
                          length( cat.n.hard.co.q2 ) ...
                          length( cat.n.hard.co.q3 ) ...
                          length( cat.n.hard.co.q4 ) ...
                          length( cat.n.hard.co.q5 ) ];
cat.plot.n.easy.count = [ length( cat.n.easy.co.q1 ) ...
                          length( cat.n.easy.co.q2 ) ...
                          length( cat.n.easy.co.q3 ) ...
                          length( cat.n.easy.co.q4 ) ...
                          length( cat.n.easy.co.q5 ) ];

                      
% plot the thing
f = figure('Position',[0 0 1000 600]);
hold on;
plot( cat.plot.c.hard.x.value, cat.plot.c.hard.y.value, '--b' );
plot( cat.plot.c.easy.x.value, cat.plot.c.easy.y.value, '-b' );
plot( cat.plot.i.hard.x.value, cat.plot.i.hard.y.value, '--r' );
plot( cat.plot.i.easy.x.value, cat.plot.i.easy.y.value, '-r' );
plot( cat.plot.n.hard.x.value, cat.plot.n.hard.y.value, '--g' );
plot( cat.plot.n.easy.x.value, cat.plot.n.easy.y.value, '-g' );

scatter( cat.plot.c.hard.x.value, cat.plot.c.hard.y.value, cat.plot.c.hard.count*2, 'ob', 'filled' );
scatter( cat.plot.c.easy.x.value, cat.plot.c.easy.y.value, cat.plot.c.easy.count*2, '^b', 'filled' );
scatter( cat.plot.i.hard.x.value, cat.plot.i.hard.y.value, cat.plot.i.hard.count*2, 'or', 'filled' );
scatter( cat.plot.i.easy.x.value, cat.plot.i.easy.y.value, cat.plot.i.easy.count*2, '^r', 'filled' );
scatter( cat.plot.n.hard.x.value, cat.plot.n.hard.y.value, cat.plot.n.hard.count*2, 'og', 'filled' );
scatter( cat.plot.n.easy.x.value, cat.plot.n.easy.y.value, cat.plot.n.easy.count*2, '^g', 'filled' );

% plot extra lines to show quantile demarcations
quant_marker(5) = trialdata.responseInterval;  % add marker for deadline
line( [trialdata.responseInterval trialdata.responseInterval], [0 1], 'LineWidth', 2, 'Color', [0 0 0] );
fig = gca;
set(fig, 'xtick', round(quant_marker*1000)/1000 );      % custom x labels
set(fig, 'ytick', 0:0.2:1);  % custom y labels
grid on;
axis([ 0.2 0.55 0 1 ]);

% legends and labels and stuff
title( sprintf( '%i-%i', subject, session) );
legend( sprintf('Con - %i', hard), sprintf('Con - %i', easy), sprintf('Incon - %i', hard), sprintf('Incon - %i', easy), sprintf('N - %i', hard), sprintf('N - %i', easy) );
ylabel('Prob. of response towards larger reward');

% save image
print( f, '-dpng', ['~/Documents/MATLAB/BoxLength/data/' num2str(subject) '/' num2str(subject) '-' num2str(session) '.png'] );

end