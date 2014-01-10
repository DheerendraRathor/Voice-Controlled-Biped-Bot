% a next try to process live recording
myarduino=arduino('COM6');
myarduino.pinMode(11,'output');
myarduino.pinMode(10,'output');
myarduino.pinMode(19,'output');
myarduino.pinMode(3,'output');

sys_recorder=audiorecorder;
dat=[];
word_encountered=0;
end_pointer=1;
word_begin=0;word_end=0;
record(sys_recorder);
pause(0.5);
begin_pointer=1;
index=1;
new_word=1;
while 1
    new_word=0;
    pause(0.12);
    [end_pointer,~]=size(getaudiodata(sys_recorder));
    if end_pointer>begin_pointer+500
        for i=begin_pointer:500:(end_pointer-500)
            dat=getaudiodata(sys_recorder);
            temp_mean=mean(abs(dat(i:i+500)));
            if temp_mean > 0.02 
                if word_encountered==0
                    word_begin=i;
                    word_encountered=1;
                end
            else
                if word_encountered==1
                    word_encountered=0;
                    word_end=i+500;
                    dat=getaudiodata(sys_recorder);
                    dat=dat(word_begin:word_end);
                    stop(sys_recorder);
                    
                    if word_end-word_begin > 1500
                            wavplay(dat);
                            Observation=trial_feature_analysis(dat);
                            p=trial_viterbi(states,HMM{1,1},HMM{1,2},HMM{1,3},Observation);
                            w=1;
                            %disp(p);
                            for j=2:4
                                temp_p=trial_viterbi(states,HMM{j,1},HMM{j,2},HMM{j,3},Observation);
                                if temp_p>p
                                    p=temp_p;
                                    w=j;
                                end
                               % disp(temp_p);
                            end
                            disp(p);
                            if p < 1e-25
                                disp('No match found  ');
                            else
                            switch(w)
                                case 1 ,disp('forward'); move('forward',myarduino);
                                  
                                case 2 , disp('back');  move('back',myarduino);
                                  
                                case 3 , disp('left');  move('left',myarduino);
                                   
                                case 4 , disp('right');  move('right',myarduino);
                                    
                            end;
                            end;
                    end
                    
                    new_word=1;
                    break
                end
            end
        end
    end
    if new_word == 0
        begin_pointer=end_pointer;
    else
        record(sys_recorder);
        pause(0.2);
        begin_pointer=1;
    end
end