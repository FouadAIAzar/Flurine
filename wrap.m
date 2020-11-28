function [eemdata, errormsg] = wrap(ex,em,fl,fl_id)

eemdata = [];
errormsg = '';
cancel = 0;

if nargin >= 3
    
    ex_size = size(ex);
    em_size = size(em);
    fl_size = size(fl);
    
    if min(ex_size) > 1 | min(em_size) > 1
        
        cancel = 1;
        errormsg = '''ex'' and ''em'' must be vectors';
        
    elseif prod(fl_size) ~= (prod(ex_size) .* prod(em_size))
        cancel = 1;
        errormsg = 'matrix dimensions do not match';
        
    else
        
        if length(find(isnan(ex))) > 0 | length(find(isnan(em))) > 0
            
            I_ex = find(~isnan(ex));
            ex = ex(I_ex);
            
            I_em = find(~isnan(em));
            em = em(I_em);
            
        end
        
        ex_inc = ex(2:length(ex))-ex(1:length(ex)-1);
        I_ex = find(ex_inc <= 0);
        
        em_inc = em(2:length(em))-em(1:length(em)-1);
        I_em = find(em_inc <= 0);
        
        if ~isempty(I_ex) | ~isempty(I_em)
            
            cancel = 1;
            errormsg = '''ex'' and ''em'' must be monotonically increasing vectors';
            
        else
            if ex_size(1) > ex_size(2)
                ex= ex';
            end
            
            if em_size(2) > em_size(1)
                em = em'
            end
            
        end
        
    end
    
    if cancel == 0
        
        if exist('fl_id') ~= 1
            fl_id = NaN;
        end
        
        eemdata = zeros(length(em)+1,length(ex)+1);
        
        eemdata(1,1) = fl_id;
        eemdata(1,2:size(eemdata,2)) = ex;
        eemdata(2:size(eemdata,1),1) = em;
        eemdata(2:size(eemdata,1),2:size(eemdata,2)) = fl;
        
    end
    
else
    
    cancel = 1;
    errormsg = 'Too few arguments for function';
end