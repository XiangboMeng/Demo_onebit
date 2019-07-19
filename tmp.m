%%
clearvars
close all
current_path = pwd;
addpath([current_path,'\MISO_data\']);
%addpath('C:\Users\nestes\Desktop\local_measurement\AWG_controls');

BF_dec = [0:15];
power_dBm_500MHz_record = BF_dec*0;
FFT_DC_record = BF_dec*0;
BF_code_test = de2bi(BF_dec,'left-msb');

fs = 20e9;
data_rate = 1000e6;
Scope.folderName = [current_path,'\MISO_data\'];
Scope.fileName = ['MISO_20190416_1GHz_clock_1GHz_IF_BF_code_'];
Scope.timeScale = 1e-9;
capture_symbol_num = 1000;
Scope.timeDesired = capture_symbol_num/data_rate;
Scope.vol_per_div = 0.01;


% num_measure = 25;
while(1)
    
    fig=figure(1);
    tmpx = [-2, -1];
    tmpy = [-100,-100];
    plot(tmpx,tmpy,'o');
    hold on
    axis([0 30 -100 -30]);
    set(gca,'XTick',0:1:30);
    set(gca,'YTick',-100:5:-30);
    grid on
    box on
    xlabel('Time')
    ylabel('Power to Scope at 500MHz (dBm)')
    title('Beamforming Performance')
    for loop = 1:length(BF_dec)

        
        
        BF_code = BF_code_test(loop,:);
        BF_binary_index = BF_dec(loop);
        BF_str = char(BF_code + '0');
        
        %         Scope.fileName = [Scope.fileName,BF_str];
        %
        %         BF_set(BF_binary_index);
        %
        %         pause(3)
        %         Oscope_read_func(Scope)
        
        fileName = ['MISO_20190423_1GHz_clock_1GHz_IF_BF_code_'];
        fileName = [fileName,BF_str,'_9'];
        str = [fileName,'.mat'];
        if(exist(str))
            load(fileName);
            voltage_out = -waveform.YData;              % why negative
            
            data_str = voltage_out;
            %         data_str = sin(2*pi*500e6*(1e-9/20:(1e-9/20):1e-6))';
            fft_x = fft(data_str);
            
            N_x = length(data_str);
            
            freq_domain = ((0:N_x-1)-N_x/2)/(N_x)*fs;
            DC_index = find(abs(freq_domain)<1e-6);
            fft_x_shift = fftshift(fft_x)/sqrt(N_x);
            fft_x_power = abs(fft_x_shift).^2/(50)/N_x;
            fft_x_real_power = [fft_x_power(DC_index);fft_x_power(DC_index+1:end)*2];
            
            freq_index = abs(freq_domain - 500e6)<1e-6;
            power_dBm_500MHz_record(BF_binary_index+1) = 10*log10(fft_x_power(freq_index)*2)+30;
            
            
        else
        end
        
        tmpx = [tmpx(2), BF_binary_index];
        tmpy = [tmpy(2), power_dBm_500MHz_record(BF_binary_index+1)];
        plot(tmpx,tmpy,'-o');
        
        pause(0.5)
    end
    


    % sexify(fig)
    % legend(['measure ',num2str(num_measure)])
    % str = 'BF_power_record';
    % if(num_measure)
    %    str = [str,'_',num2str(num_measure)];
    % end
    %savefig(fig,[str,'.fig']);
    
    
    % Set beamforming vector
    [M,idx] = max(power_dBm_500MHz_record);
    % BF_set(idx-1);
    
    for idx = 16:30
        tmpx = [tmpx(2), idx];
        tmpy = [tmpy(2), max(power_dBm_500MHz_record)];
        plot(tmpx,tmpy,'-');
        pause(0.5);
    end
    
    hold off
    
end



