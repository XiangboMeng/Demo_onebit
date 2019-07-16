%% Choose Beamforming vector and read OScope

function BF_set(BF_dec)
    
    BF_code = de2bi(BF_dec,'left-msb');
    
    % Set AWGs 
    addpath('C:\Users\nestes\Desktop\local_measurement\AWG_controls');
    if(BF_code(1)==1)
        M8190A_output_on(1);
    else
        M8190A_output_off(1);
    end

    if(BF_code(2)==1)
        M8190A_output_on(2);
    else
        M8190A_output_off(2);
    end

    if(BF_code(3)==1)
        AWG710_output_on(1);
    else
        AWG710_output_off(1);
    end

    if(BF_code(4)==1)
        AWG710_output_on(2);
    else
        AWG710_output_off(2);
    end


end