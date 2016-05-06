sec2hms = function(time_sec)
    --require 'math'
    local timing_type, time_min, time_hrs, time_days, time_years
    local onedec, twodec, sgn, sign_str, str
    
    
    timing_type = 'seconds';
    if time_sec >= 0 then
        sgn = 1
    else
        sgn = -1;
    end
    
    
    time_sec = (time_sec)*sgn;
    if time_sec >= 60 then
        time_min = math.floor(time_sec/60); -- convert to minutes
        time_sec = math.fmod(time_sec, 60);
        timing_type = 'minutes';
        if time_min >= 60  then
            time_hrs = math.floor(time_min/60); -- convert to hours
            time_min = math.fmod( time_min, 60 );
            timing_type = 'hours';
            if time_hrs >= 24  then
                time_days = math.floor(time_hrs/24);
                time_hrs = math.fmod(time_hrs, 24); -- convert to days
                timing_type = 'days';
                if time_days >= 365  then
                    time_years = math.floor(time_days/365);
                    time_days = math.fmod(time_days, 365); -- convert to days
                    timing_type = 'years';
                end
            end
        end
    end
    --print(time_sec)
    twodec = '%02.f';
    onedec = '%1.f';
    --
    if sgn == -1 then
        sign_str = '-';
    else
        sign_str = '';
    end
    
    if timing_type == 'seconds' then
        str = string.format('%s%2.1fs', sign_str, time_sec);
    elseif timing_type == 'minutes' then
        str = string.format('%s' .. twodec .. 'm' .. twodec .. 's', sign_str, time_min, time_sec);
    elseif timing_type ==  'hours' then
        str = string.format('%s' .. onedec .. 'h' .. twodec .. 'm' .. twodec .. 's', sign_str, time_hrs, time_min, time_sec);
    elseif timing_type == 'days' then
        str = string.format('%s' .. onedec .. ' days; ' .. onedec .. 'h' .. twodec .. 'm' .. twodec .. 's', sign_str, time_days, time_hrs, time_min, time_sec);
    elseif timing_type == 'years' then
        str = string.format('%s' .. onedec .. ' years, ' .. onedec .. ' days; ' .. onedec .. 'h' .. twodec .. 'm' .. twodec .. 's', sign_str, time_years, time_days, time_hrs, time_min, time_sec);
    end
    return str
    
end
