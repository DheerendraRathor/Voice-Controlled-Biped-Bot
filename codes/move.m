%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%      %%%%%%   %
%%  %  5 %      %  %   %
%%  %  %%%%%    %  %%%%% %
%%  %    %      %    %   %
%%  %    %      %    %   %
%%  %  %%%%%    %  %%%%% %
%%  %  9 %      % 11 %   %
%%  %%%%%%      %%%%%%   %
%%%%%%%%%%%%%%%%%%%%%%%%%%
% MOVE is used to move your robot using arduino
% MOVE(command,arduino_name) is syntax
% command can be 'forward' or 'back' or 'left' or 'right'
% arduino_1 is name of arduino object you are using for controlling.
% for initializing arduino use arduino_name = arduino(PORT);

% connect 5 - >  blue of forward/back
% connect 9 - >  black of forward/back
% connect 10 - >  blue of left/right
% connect 11 - >  red of left/right

function move(a,ard)
ard.pinMode(9,'OUTPUT');
ard.pinMode(10,'OUTPUT');
ard.pinMode(11,'OUTPUT');
ard.pinMode(5,'OUTPUT');
if strcmp(a,'forward')==1
   ard.digitalWrite(9,1); %FORWARD
  ard.digitalWrite(11,1);
  ard.digitalWrite(5,0);
  ard.digitalWrite(10,0);
  pause(1);
   ard.digitalWrite(9,1); 
  ard.digitalWrite(11,1);
  ard.digitalWrite(5,1);
  ard.digitalWrite(10,1);
else if strcmp(a,'back')==1
          ard.digitalWrite(5,1); % BACK
          ard.digitalWrite(10,1);
          ard.digitalWrite(9,0);
          ard.digitalWrite(11,0);  
          pause(1);
           ard.digitalWrite(9,1);  
          ard.digitalWrite(11,1);
          ard.digitalWrite(5,1);
          ard.digitalWrite(10,1);
    else if strcmp(a,'left')==1
          ard.digitalWrite(9,1); % LEFT
          ard.digitalWrite(10,1);
          ard.digitalWrite(5,0);
          ard.digitalWrite(11,0);
          pause(0.5);
          ard.digitalWrite(9,1);
          ard.digitalWrite(11,1);
          ard.digitalWrite(5,1);
          ard.digitalWrite(10,1);
        else if strcmp(a,'right')==1
                 ard.digitalWrite(5,1); % RIGHT
                  ard.digitalWrite(11,1);
                  ard.digitalWrite(9,0);
                  ard.digitalWrite(10,0);
                  pause(0.6);
                   ard.digitalWrite(9,1);
                  ard.digitalWrite(11,1);
                  ard.digitalWrite(5,1);
                  ard.digitalWrite(10,1);
            end
        end
    end
end
end

