function nextstr = status_line(newstr, laststr)
% status_line - maintain a status_line to show calculation progress
%  
% Description: Prints a string to stdout, first printing backspaces and
%              spaces to move back to the beginning of the line.
%
%              Called with no arguments, just prints a new line \n.
%           
%              Called with empty string and a length, only backs up the
%              beginning of the line.
%
% Syntax:  laststr = status_line('1/5', 0); % outputs 1/5
%          laststr = status_line('2/5', laststr) % line now reads 2/5
%
% Inputs:
%    newstr   - new string to print
%    laststr  - length of last string passed to status_line
%
% Outputs:
%    nextstr  - length of newstr, to be passed on the next call as laststr
%
% Other m-files required: none
%
% Subfunctions: none
%
% MAT-files required: none
%
% See also: n/a
%
% Author: Jared R. Males
% email: jaredmales@gmail.com
% 
% History:
%  - written by JRM on 2015.07.21
%

%------------- BEGIN CODE --------------

if(nargin < 1) 
    fprintf(1, '\n')
    return
end

nextstr = length(newstr);

if(nargin < 2)
    laststr = 0;
end

%Back to beginning of line
if( laststr > 0)
    for i=1:laststr
        fprintf(1, '\b');
    end
end

%Only print if not an empty string
if(nextstr > 0)
    fprintf(1,newstr);
end

end

