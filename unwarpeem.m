function [ex,em,fl,fl_id,errormsg] = unwarpeem(eemdata)

ex = [];
em = [];
fl = [];
fl_id = [];
errormsg = '';
cancel = 0;

if nargin > 0
    
    if size(eemdata,1) < 2 | size(eemdata,2) < 2
        
        cancel = 1;
        errormsg = 'Input matrix is invalid';
    else
        
        ex = eemdata(1,2:size(eemdata,2));
        em = eemdata(2:size(eemdata,1),1);
        fl = eemdata(2:size(eemdata,1),2:size(eemdata,2));
        fl_id = eemdata(1,1);
        
        ex_inc = ex(2:length(ex))-ex(1:length(ex)-1);
        I_ex = find(ex_inc <= 0);
        
        em_inc = em(2:length(em))-em(1:length(em)-1);
        I_em = find(em <= 0);
        
        if ~isempty(I_ex) | ~isempty(I_em)
            
            cancel = 1;
            
            errormsg = 'Input matrix is invalid';
            
            ex = [];
            em = [];
            fl = [];
            fl_id = [];
            
        end
        
    end
else
    
    cancel = 1;
    errormsg = 'Too few arguements for function';
end
