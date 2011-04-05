function [trialdata, savefile] = BoxLength(subjid, numblocks, responseInterval, basePay)

% Code for the go-cued version was originally written by Rebecca Tortell
% Modified in 2009 by Sharareh Noorbaloochi to the deadlined task
% Modified in 2010 by Eliezer Kanal to work with MEG

% Set filename
fprintf( '\n The following information relating to subject %d currently exists: \n\n', subjid );

d = dir('C:\Documents and Settings\eliezerk\Desktop\My Dropbox\MATLAB\BoxLength\data\');
%d = dir( sprintf( '~/Documents/MATLAB/BoxLength/data/%d/', subjid ) );
sessions = [];
for n=1:length(d)
    if ~isempty(regexp(d(n).name,sprintf('%d\\-\\d{1,2}.mat',subjid),'match'))
        num = regexp(d(n).name,sprintf('%d\\-(\\d{1,2}).mat',subjid),'tokens');
        sessions = [sessions str2double(cell2mat(num{1}))];
    end
end
sessions = sort(sessions);

if isempty( sessions )
    fprintf( 1, 'New subject: no files related to subject %d in the directory. \n\n', subjid );
else
    fprintf('Found sessions: ');
    disp(sessions);
end

continue_response = input( sprintf( 'Continue with session %d? Type ''y'' if yes, ''n'' if no.\n', max(sessions)+1 ), 's' );
if strcmp( continue_response, 'y' ) ~= 1
    return
end

% increment the filename number based on previous file names
sessionno = 0;
while sessionno < 1 || exist(strcat(filename, '.mat'),'file') || exist(strcat(filename, '_1.mat'),'file')
    sessionno = sessionno + 1;
    filename = sprintf ('%d_d', subjid, sessionno);
end

% variable declarations;
numtrials  = 160;
goodnoise  = wavread('ding.wav');
badnoise   = wavread('Beep.WAV') * 5;
earlynoise = wavread('time.wav');
latenoise  = wavread('buzzer.wav');

% stimulus difficulty levels
offsetpixels = [2 5];

% Trial structure:
%   - fixation 1  (850 ms)
%   - reward cue  (500 ms)
%   - fixation 2  (1000 ms)
%   - stim        (responseInterval+200 ms max)
%   - feedback    (700 ms)
%   - fixation 3  (jitter, mean 450 ms)
% = ~4050 msec total

fixInterval    = 0.850;
rewardInterval = 0.500;
readyInterval  = 1.000;
totalResponseInterval = responseInterval + 0.200; % SN 11/3/09
feedbacktime   = 0.700;
% itidelay is determined by the gamrnd function at runtime

savefile = SaveFileSetup;

keys  = [ KbName('Z'), KbName('M'), KbName('space') ];
lkey  = keys(1);
rkey  = keys(2);
spkey = keys(3);

[fixOnly, fixLeft, fixRight,fixNeutral, scoreBar, stim, centre, window] = ScreenSetup;

% EEG output setup
FIX_TRIG  = 001;
FIX2_TRIG = 002;

LEFTRWD_TRIG  = 003;
RIGHTRWD_TRIG = 004;
NEUTRAL_TRIG  = 005;

RIGHTSTIM_TRIG_2 = 006;
RIGHTSTIM_TRIG_5 = 007;
LEFTSTIM_TRIG_2  = 008;
LEFTSTIM_TRIG_5  = 009;

LATEFB_TRIG  = 010;
GOODFB_TRIG  = 011;
BADFB_TRIG   = 012;
EARLYFB_TRIG = 013;

% Initialize the USB device:
devices = daqhwinfo('mcc');
if strfind(cell2mat(devices.ObjectConstructorName(3)), 'digitalio')
    daq = digitalio('mcc');
    TriggerFlag = 1;
    
    hwlines = addline(daq, 0:7, 0, 'out');
    hwlines = addline(daq, 0:4, 1, 'in');
    putvalue(daq.Line(1:8), 0);
else
    TriggerFlag = 0;
    daq = -1;
end

% Save subject trial data
trialdata.sessionno = sessionno;
trialdata.subjid    = subjid;

trials = TrialSetup(offsetpixels, sessionno);

for q = 1:numblocks
    
    trialdata.responseInterval(q,1) = responseInterval;
    
    % set up order of trials for this block
    real = [];
    for v = 1:ceil(numtrials/(big-1))  % 'big' is 1+number of items in 'trials' array (see TrialSetup)
        real = [real shuffle(1:big-1)];
    end
    thisblock = shuffle(real);

    % Text at first block
    if q == 1
        st = {};
        st{1} = 'Please indicate whether the rectangle';
        st{2} = 'is longer on the right or left side.';
        st{3} = 'Remember: ';
        st{4} = '    (1) Respond as fast as you can.';
        st{5} = '    (2) Prepare the higher reward side.';
        st{6} = '    (3) Guessing is better than not responding at all.';
        st{7} = '';
        st{8} = 'Press the right key to continue.';

        DisplayText( st, rkey );
        
    % Pause between blocks
    else
        % Display inter-block text
        st = {};
        st{1} = 'Break. Stretch out your wrists now.';
        st{2} = 'Remember: ';
        st{3} = '    (1) Respond as fast as you can.';
        st{4} = '    (2) Prepare the higher reward side.';
        st{5} = '    (3) Guessing is better than not responding at all.';
        st{6} = ['block score: ' num2str(sum(trialdata.points(q-1,:)),'%10.1f'), ', Total score: ' num2str(sum(sum(trialdata.points)), '%10.1f') ', completed blocks: ' num2str(q-1) '.'];
        st{7} = '';
        st{8} = 'Press the right key to continue.';

        DisplayText( st, rkey );
        
        WaitSecs(1);
    end
    
    numLeft = 0; numRight=0; numBlank = 0;  % num of left, right and blank responses per block
    
    %
    % Display the stimulus
    %
    for i = 1: numtrials
        trialstart = GetSecs;
        this       = thisblock(i);
        early(q,i) = 0;
        
        % determine which direction the bias is this round
        centrerect = [rect(:,3)-150, rect(:,4)-50, rect(:,3)+150, rect(:,4)+50];
        if trials(this).dirs < 0
            if trials(this).offs == 2
                STIM_TRIG = LEFTSTIM_TRIG_2;
            elseif trials(this).offs == 5
                STIM_TRIG = LEFTSTIM_TRIG_5;
            end
            centrerect(1) = centrerect(1) - trials(this).offs;
            centrerect(3) = centrerect(3) - trials(this).offs;
        else
            if trials(this).offs == 2
                STIM_TRIG = RIGHTSTIM_TRIG_2;
            elseif trials(this).offs == 5
                STIM_TRIG = RIGHTSTIM_TRIG_5;
            end
            
            centrerect(1) = centrerect(1) + trials(this).offs;
            centrerect(3) = centrerect(3) + trials(this).offs;
        end
        
        Screen(stim, 'FillRect', 127);
        Screen(stim, 'FrameRect', 200, centrerect);
        Screen(stim, 'FillRect', 200, [centre(:,1)-1, centre(:,2)-5, centre(:,1)+1, centre(:,2)+5]);
        Screen(stim, 'FillRect', 200, [centre(:,1)-5, centre(:,2)+1, centre(:,1)+5, centre(:,2)-1]);
        
        trialdata.dir(q,i)  = trials(this).dirs;
        trialdata.offs(q,i) = trials(this).offs;
        % trialdata.ispractice(q,i)=ispractice;
        % trialdata.cuetime(q,i)=trials(this).cues;

        % determine reward
        a = num2str(trials(this).rwds);
        leftrwd  = str2double(a(1));
        rightrwd = str2double(a(2));
        trialdata.leftreward(q,i)  = leftrwd;
        trialdata.rightreward(q,i) = rightrwd;
        
        if leftrwd > rightrwd
            fixScreen = fixLeft;
            REWARDCUE_TRIG = LEFTRWD_TRIG;
        elseif rightrwd > leftrwd
            fixScreen = fixRight;
            REWARDCUE_TRIG = RIGHTRWD_TRIG;
        else
            fixScreen = fixNeutral;
            REWARDCUE_TRIG = NEUTRAL_TRIG;
        end
        
        %
        % FIRST FIXATION
        %
        fix = GetSecs;
        Screen('CopyWindow', fixOnly, window);

        if isstruct(daq)
            putvalue(daq.Line(1:8), FIX_TRIG);
            putvalue(daq.Line(1:8), 0);
        end
        
        % ### may want to add early response detection; just use while loop
        % and BREAK out of trial if necessary
        while GetSecs-fix < fixInterval
            WaitSecs(0.0001);
        end
        
        %
        % REWARD CUE
        %
        rwdstamp = GetSecs - fix;
        
        % Draw arrow indicating trial direction, and get response.
        Screen('CopyWindow', fixScreen, window);
        if TriggerFlag
            putvalue(daq.Line(1:8), REWARDCUE_TRIG);
            putvalue(daq.Line(1:8), 0);
        end
        
        % ### may want to add early response detection; just use while loop
        % and BREAK out of trial if necessary
        WaitSecs(rewardInterval);
        
        % make sure we aren't falling behind...
        while GetSecs-(rwdstamp+fix)<rewardInterval
            WaitSecs(0.0001);
        end
        
        %
        % SECOND FIXATION
        %
        fixstamp = GetSecs - fix;
        
        % Return fixation point for readyInterval msecs.
        Screen('CopyWindow', fixOnly, window);
        if TriggerFlag
            putvalue(daq.Line(1:8), FIX2_TRIG);
            putvalue(daq.Line(1:8), 0);
        end
        
        [ resp, respTime ] = WaitForResponse( daq, readyInterval );
        
        % Early responses before stimulus presentation
        if any( resp )
            if TriggerFlag
                putvalue(daq.Line(1:8), EARLYFB_TRIG);
                putvalue(daq.Line(1:8), 0);
            end
            trialdata.response(q,i) = resp;
            trialdata.rt(q,i)       = respTime;
            trialdata.early(q,i)    = 1;

            stimstamp = nan;
            
            Screen('CopyWindow', scoreBar, window);
            wavplay(earlynoise, 96200);
            
            feedbackdone = GetSecs;
        else
            %
            % STIMULUS
            %
            
            % Copy stimulus and listen for early response
            stimstamp = GetSecs - fix;
            Screen('CopyWindow', stim, window);

            if TriggerFlag
                putvalue(daq.Line(1:8),STIM_TRIG);
                putvalue(daq.Line(1:8),0);
            end
            
            start = GetSecs;
            
            [ resp, respTime ] = WaitForResponse( daq, totalResponseInterval );
  
            % Wait until delivering feedback.
            while GetSecs-start < totalResponseInterval
                WaitSecs(0.0001);
            end
            
            [correct, late, points] = ...
            EvaluateResponse( trials(this).dirs, ...
                resp, ...
                respTime, ...
                leftrwd, ...
                rightrwd);
            
            fbstamp = GetSecs - fix;

            Feedback( ...
                correct, ...
                late, ...
                points, ...
                feedbacktime);

            feedbackdone = GetSecs;

            % EK - my stored vars
            trialdata.resp(q,i)     = resp;
            trialdata.respTime(q,i) = respTime;
            trialdata.correct(q,i)  = correct;
            trialdata.late(q,i)     = late;
            trialdata.points(q,i)   = points;

            trialdata.istrial(q,i)  = 1; 
            trialdata.pointTaken(q,i) = (trialdata.correct(q,i)& ~trialdata.late(q,i)).*trialdata.points(q,i); %sharareh 9/2/2008
        end
        
        %
        % Last Fixation
        %
        itistamp = GetSecs - fix;
        Screen('CopyWindow', fixOnly, window);
        
        itiDelay = gamrnd(5,1)/10;  % Gamma distrib with median of 0.450 - adds jitter

        while GetSecs - feedbackdone < itiDelay
            WaitSecs(0.0001)
        end
        trialend = GetSecs;
        trialduration                = trialend - trialstart;
        
        trialdata.rwdstamp(q,i)      = rwdstamp;
        trialdata.fixstamp(q,i)      = fixstamp;
        trialdata.stimstamp(q,i)     = stimstamp;
        trialdata.fbstamp(q,i)       = fbstamp;
        trialdata.itistamp(q,i)      = itistamp;
        trialdata.trialduration(q,i) = trialduration;

        save(savefile, 'trialdata');
    end
end

score = sum(sum(trialdata.points));

trialdata.responseInterval  = responseInterval;
trialdata.basePay           = basePay;
trialdata.paymentForSession = basePay + score/100;
save(savefile, 'trialdata');

donestring{1} = 'You have reached the end of the session.';
donestring{2} = ['Your score for this session: ' num2str(score) ' points.'];
donestring{3} = ['Total Earning for this session: $' num2str(basePay+score/100, '%10.2f')];

DisplayText( donestring, rkey );

Screen('CloseAll');

    function [savefile] = SaveFileSetup()
        if exist(['C:\Documents and Settings\eliezerk\Desktop\My Dropbox\MATLAB\BoxLength\data\' num2str(subjid) '\'],'dir')==0
            mkdir(['C:\Documents and Settings\eliezerk\Desktop\My Dropbox\MATLAB\BoxLength\data\' num2str(subjid) '\']);
        end;
        savefile = ['C:\Documents and Settings\eliezerk\Desktop\My Dropbox\MATLAB\BoxLength\data\' num2str(subjid) '\' num2str(subjid) '-' num2str(sessionno) '.mat'];
    end


    function [fixOnly, fixLeft, fixRight, fixNeutral, scoreBar, stim, centre, window] = ScreenSetup()
        window     = Screen(0, 'OpenWindow', 127);
        WaitSecs(2);  % program seems to miss the first display, lets see if this helps
        HideCursor;
        fixOnly    = Screen(window, 'OpenOffScreenWindow', 127);
        fixLeft    = Screen(window, 'OpenOffScreenWindow', 127);
        fixRight   = Screen(window, 'OpenOffScreenWindow', 127);
        fixNeutral = Screen(window, 'OpenOffScreenWindow', 127);
        scoreBar   = Screen(window, 'OpenOffScreenWindow', 127);
        stim       = Screen(window, 'OpenOffScreenWindow', 127);
        
        rect   = (Screen(0, 'Rect'))/2;
        centre = [rect(:,3) rect(:,4)];
        Screen(fixOnly, 'FillRect', 127);
        Screen(fixOnly, 'FillRect', 200, [centre(:,1)-1, centre(:,2)-5, centre(:,1)+1, centre(:,2)+5]);
        Screen(fixOnly, 'FillRect', 200, [centre(:,1)-5, centre(:,2)+1, centre(:,1)+5, centre(:,2)-1]);
        
        
        sbarwidth  = 10;
        centrerect =[rect(:,3)-sbarwidth rect(:,4)-51 rect(:,3)+sbarwidth rect(:,4)+51];
        Screen(scoreBar,'FrameRect', 200, centrerect);
        
        Screen(scoreBar,'DrawLine',200,rect(:,3)-sbarwidth-4, rect(:,4)-25, rect(:,3)+sbarwidth+4, rect(:,4)-25);
        Screen(scoreBar, 'DrawLine',200,rect(:,3)-sbarwidth-4, rect(:,4)+25, rect(:,3)+sbarwidth+4, rect(:,4)+25);
        Screen(scoreBar, 'DrawLine',200,rect(:,3)-sbarwidth-4, rect(:,4), rect(:,3)+sbarwidth+4, rect(:,4));
        
        % circ = 10;
        fin  = 8;% each side of the square will be fin*2 pixels long
        % diamond = floor(sqrt((2*fin)^2+(2*fin)^2)/2)-1;
        % pp   = 2;
        koo  = ceil(cos(pi/4)*fin);
        
        fin = 5;
        Screen(fixLeft, 'FillRect', 127);
        Screen(fixLeft, 'FillPoly', [255 255 0], [centre(:,1)-fin centre(:,2); centre(:,1)-fin centre(:,2)-1; centre(:,1)+fin centre(:,2)-fin-1; centre(:,1)+fin centre(:,2)+fin]);
        
        Screen(fixRight, 'FillRect', 127);
        Screen(fixRight, 'FillPoly', [255 255 0], [centre(:,1)+fin centre(:,2); centre(:,1)+fin centre(:,2)-1; centre(:,1)-fin centre(:,2)-fin-1; centre(:,1)-fin centre(:,2)+fin]);
        
        Screen(fixNeutral, 'FillRect', 127); %neutral
        Screen(fixNeutral, 'DrawLine',[255 255 0], rect(:,3)-koo, rect(:,4)-koo, rect(:,3), rect(:,4),2);
        Screen(fixNeutral, 'DrawLine',[255 255 0], rect(:,3), rect(:,4), rect(:,3)+koo, rect(:,4)+koo,2);
        Screen(fixNeutral, 'DrawLine',[255 255 0], rect(:,3)-koo, rect(:,4)+koo, rect(:,3), rect(:,4),2);
        Screen(fixNeutral, 'DrawLine',[255 255 0], rect(:,3), rect(:,4), rect(:,3)+koo, rect(:,4)-koo,2);
    end


    % Present feedback bar display, play feedback sounds, send triggers,
    % calculate score
    function Feedback(correctside, toolate, rwd, feedbacktotaltime)
        d = GetSecs; %SN 11/3/09
        Screen('CopyWindow', fixOnly, window);
        
        Screen('CopyWindow', scoreBar, window);
        
        % if late...
        if toolate
            if TriggerFlag
                putvalue(daq.Line(1:8),LATEFB_TRIG);
                putvalue(daq.Line(1:8),0);
            end
            wavplay(latenoise,11025);
        
        % if wrong...
        elseif ~correctside
            if TriggerFlag
                putvalue(daq.Line(1:8), BADFB_TRIG);
                putvalue(daq.Line(1:8), 0);
            end
            wavplay(badnoise,22050);
        
        % if correct...
        else
            if TriggerFlag
                putvalue(daq.Line(1:8),GOODFB_TRIG);
                putvalue(daq.Line(1:8),0);
            end
            Screen('CopyWindow', scoreBar, window);
            numPoint = rwd;
            if numPoint > 0
                y1 = (numPoint/4 )*100-50;
                sbarwidth = 10;
                varRect = [rect(:,3)-(sbarwidth-1) rect(:,4)-y1 rect(:,3)+(sbarwidth-1) rect(:,4)+50];
            end

            Screen(window,'FillRect', [2 0 254], varRect);
            wavplay(goodnoise,22050);    
        end
        
        while GetSecs-d<feedbacktotaltime
            WaitSecs(0.0001);
        end
    end

    % Determine whether subject responded correctly, whether they responded
    % within the timeframe, and what the reward amount for a given trial
    function [correctside, toolate, rwd] = EvaluateResponse( trialdir, response, rt, leftrwd, rightrwd )
        % if actual is left...
        if trialdir < 0
            rwd = leftrwd;
            % if responded right...
            if response == rkey
               if rt > responseInterval
                    toolate = 1;
                else
                    toolate = 0;
                end
                numRight    = numRight + 1;
                correctside = 0;
            % if didn't respond...
            elseif ~response
                numBlank    = numBlank + 1;
                correctside = 0;
                toolate     = 1;
            % if responded left...
            else
                numLeft     = numLeft + 1;
                correctside = 1;
                if rt > responseInterval
                    toolate = 1;
                else
                    toolate = 0;
                end
            end
        
        % if actual is right...
        else
            rwd = rightrwd;
            % if responded left...
            if response == lkey
                if rt > responseInterval
                    toolate = 1;
                else
                    toolate = 0;
                end
                correctside = 0;
                numLeft     = numLeft +1;
            % if didn't respond...
            elseif ~response
                numBlank    = numBlank +1;
                correctside = 0;
                toolate     = 1;
            % if responded right...
            else
                numRight = numRight +1;
                correctside = 1;
                if rt > responseInterval
                    toolate = 1;
                else
                    toolate = 0;
                end
            end
        end
    end


    function [trials] = TrialSetup (offset, sessionno)
        if sessionno > 1
            rewardScheme = [24 42 33]; % SN 1/11/10
        else
            rewardScheme = [33 33 33]; % EK - show all same reward on first
                                       % (practice) session. Still need 
                                       % three to ensure that trials is the
                                       % right size.
        end
        
        direction    = [-10 +10];
        big = 1;
        
        for z = 1:size(rewardScheme, 2)
            for l = 1:size(direction, 2)
                for k = 1:size(offset, 2)
                    trials(big).dirs = direction(l);
                    trials(big).offs = offset(k);
                    trials(big).rwds = rewardScheme(z);
                    big = big+1;
                end
            end
        end
    end

    % Detect responses for both keyboard and Daq
    function [secs, keyCode] = DetectResponse( daq )
        secs    = -1;
        keyCode = double( zeros(1,256) );
        
        if isa( daq, 'digitalio' )
            resp = binvec2dec( getvalue( daq ) );

            if resp ~= 0  %    0 = nothing pressed
                          % 2048 = left
                          % 4096 = right
                          % 6144 = both

                secs = GetSecs;

                if resp == 2048
                    keyCode( lkey ) = 1;
                elseif resp == 4096
                    keyCode( rkey ) = 1;
                elseif resp == 6144
                    keyCode( spkey ) = 1;  % space key
                end
            end
        else
            [keyIsDown, secs, keyCode] = KbCheck;
        end
    end

    % Wait for response for a given amount of time
    function [resp, respTime] = WaitForResponse( daq, secs, allowedKeys )

        if ~exist( 'allowedKeys', 'var' )
            allowedKeys = keys;
        end
        
        % allow infinite waiting
        if secs <= 0
            secs = 9999;
        end
        
        begTime = GetSecs;
        resp = 0;
        
        while (GetSecs - begTime) < secs
            [respTime, keyCode] = DetectResponse( daq );
            respTime = respTime - begTime;
            if any( keyCode )
                keyPressed = find(keyCode);
                if isempty(keyPressed)
                    % dummy value, since keyPressed needs a value for the
                    % == comparison to work
                    keyPressed = 99999;
                end
                
                % if pressed more than one key at a time, break
                if length( keyPressed ) > 1
                    keyPressed = 99999;
                end
                
                % only return a response if the button being pressed is
                % defined in the 'keys' allowed responses array. If
                % allowedKeys is defined, use that instead.
                if ~isempty( keys( keyPressed == keys ) )
                    resp = find( keyCode );

                    if isempty( allowedKeys )
                        break
                    else
                        if ~isempty( allowedKeys( resp == allowedKeys ) )
                            break
                        end
                    end
                end
            end
        end
    end


    % Display text on the screen, 
    function DisplayText( text, continueKey )
        
        % if continueKey is not in the keys array, throw an error
        if ~isempty( continueKey ) && isempty( keys( continueKey == keys ) )
            error('Continue key is not one of the allowed keys!');
        end
        
       % display the message
        font = 'Garamond';
        fontsize = 26;
        lineheight = 50;
        Screen(window, 'TextFont', font);
        Screen(window, 'TextSize', fontsize);
        Screen(window, 'FillRect', 127);

        xx = 500*ones( size( text, 2 ), 1 );
        yy = 0:lineheight:( length( text ) * lineheight);
        yy = yy - max(yy)/2;
        for jj = 1:size( text, 2 )
            Screen(window,'DrawText', text{jj}, centre(:,1)-xx(jj), centre(:,2)+yy(jj), 200);
        end
        
        % If daq...
        if isa( daq, 'digitalio' )
            WaitForResponse( daq, GetSecs, continueKey );
            
        % If keyboard...
        else
           while 1
                [keypressed, seconds, keyCode ] = KbCheck;
                if keypressed
                    if ~isempty( continueKey )
                        if find( keyCode ) == continueKey;
                            break
                        end
                    else
                        break;
                    end
                end
                WaitSecs(0.1);
           end
        end
        Screen( window, 'FillRect',127);
    end
end