function walk(a,ard)
tf1=0;
tf2=0;
ard.servoAttach(9);
ard.servoAttach(10);
ard.servoAttach(11);
if strcmp(a,'forward')==1
    for i=1:6,
        pos = 105;
        while pos>=75;
            
            ard.servoWrite(10,pos+5);
            ard.servoWrite(11,pos+25);
            ard.servoWrite(9,65-5);
            pause(0.01*tf1);
            pos=pos-2;
        end;
        pos=65;
        while pos<=115
            
            ard.servoWrite(9,pos-5);
            pause(0.01*tf2);
            pos=pos+1;
        end;
        pos = 75;
        while pos < 105;
            
            ard.servoWrite(10,pos+5);
            ard.servoWrite(11,pos+25);
            ard.servoWrite(9,110);
            pause(0.01*tf1);
            pos=pos+2;
        end;
        pos=115;
        while pos>=65;
            ard.servoWrite(9,pos-5);
            pause(0.01*tf2);
            pos=pos-1;
        end;
    end;
elseif strcmp(a,'back')==1
     for i=1:6,
        pos = 105;
        while pos>=75;
            
            ard.servoWrite(10,180-pos+5);
            ard.servoWrite(11,180-pos+25);
            ard.servoWrite(9,65-5);
            pause(0.01*tf1);
            pos=pos-2;
        end;
        pos=65;
        while pos<=115
            
            ard.servoWrite(9,pos-5);
            pause(0.01*tf2);
            pos=pos+1;
        end;
        pos = 75;
        while pos < 105;
            
            ard.servoWrite(10,180-pos+5);
            ard.servoWrite(11,180-pos+25);
            ard.servoWrite(9,110);
            pause(0.01*tf1);
            pos=pos+2;
        end;
        pos=115;
        while pos>=65;
            ard.servoWrite(9,pos-5);
            pause(0.01*tf2);
            pos=pos-1;
        end;
     end;
elseif strcmp(a,'left')==1
    for i=1:7,
        pos = 105;
        while pos>=75;
            
            ard.servoWrite(10,180-pos+5);
            ard.servoWrite(11,pos+25);
            ard.servoWrite(9,65-5);
            pause(0.01*tf1);
            pos=pos-2;
        end;
        pos=65;
        while pos<=115
            
            ard.servoWrite(9,pos-5);
            pause(0.01*tf2);
            pos=pos+1;
        end;
        pos = 75;
        while pos < 105;
            
            ard.servoWrite(10,180-pos+5);
            ard.servoWrite(11,pos+25);
            ard.servoWrite(9,110);
            pause(0.01*tf1);
            pos=pos+2;
        end;
        pos=115;
        while pos>=65;
            ard.servoWrite(9,pos-5);
            pause(0.01*tf2);
            pos=pos-1;
        end;
    end;
elseif strcmp(a,'right')==1
    for i=1:7,
        pos = 105;
        while pos>=75;
            
            ard.servoWrite(10,pos+5);
            ard.servoWrite(11,180-pos+25);
            ard.servoWrite(9,65-5);
            pause(0.01*tf1);
            pos=pos-2;
        end;
        pos=65;
        while pos<=115
            
            ard.servoWrite(9,pos-5);
            pause(0.01*tf2);
            pos=pos+1;
        end;
        pos = 75;
        while pos < 105;
            
            ard.servoWrite(10,pos+5);
            ard.servoWrite(11,180-pos+25);
            ard.servoWrite(9,110);
            pause(0.01*tf1);
            pos=pos+2;
        end;
        pos=115;
        while pos>=65;
            ard.servoWrite(9,pos-5);
            pause(0.01*tf2);
            pos=pos-1;
        end;
    end;
end
ard.servoWrite(9,85)
ard.servoWrite(11,115)
ard.servoWrite(10,95)