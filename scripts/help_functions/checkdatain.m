function data = checkdatain(data)
% sometimes data logging problems - remove these from the data
% using time stamp for check, if time is outside the hour for hour of the
% data, remove these instances from the all time series
        


[yy, mm, dd, hh, ~, ~] = datevec(double(data.time(1))/3600/24 + datenum([2001,1,1,0,0,0])); % assuming that first time is correct

ind = data.time < datetimeconv(yy, mm, dd, hh, 0, 0) | data.time > datetimeconv(yy, mm, dd, hh+1, 0, 0);

if sum(ind) == 0
    return
end

dim_t = length(data.time);

% loop for all variables
fields = fieldnames(data);

for ff = 1:length(fields)
    
    vardim = size(data.(fields{ff}));
    
    if ~any(vardim == dim_t)
        continue
    end
    
    
    if strcmp(fields{ff}, 'QualFlag')
        data.(fields{ff})(ind,:,:) = 0;
        
    elseif prod(vardim) == dim_t % 1 dim variables
        data.(fields{ff})(ind) = NaN;
        
    elseif length(vardim) == 2 % 2 dim variables
        data.(fields{ff})(ind,:) = NaN;
        
    elseif length(vardim) == 3 % 3 dim variables
        data.(fields{ff})(ind,:,:) = NaN;
        
    end
end

