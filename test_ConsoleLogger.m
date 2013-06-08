function test_ConsoleLogger()
%TEST_CONSOLELOGGER Test the functionality of the ConsoleLogger class
%   This test will print two stacked progressbars that should remain in the
%   same relative position on the screen.
%   Output should look like:
%
%   >> test_ConsoleLogger
%   Top   : ===============>      80% done
%   Bottom: ===================>  95% done
%
console = ConsoleLogger;

N = 20;
for n = 1:N
    console.print('Top   : %s>%s %.0f%% done\n',repmat('=',1,n),repmat(' ',1,N-n),n/N*100);
    inner_function(console.create_child);
end
fprintf('\n');
end

function inner_function(console)

N = 20;
for n = 1:N
    console.print('Bottom: %s>%s %.0f%% done\n',repmat('=',1,n),repmat(' ',1,N-n),n/N*100);
    pause(0.1);
end
end