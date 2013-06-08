classdef ConsoleLogger < handle
    %CONSOLELOGGER Manage writing to console without newlines
    %
    % Copyright (c) <2013> <Nathan Donnellan>
    % 
    % Permission is hereby granted, free of charge, to any person obtaining
    % a copy of this software and associated documentation files (the
    % "Software"), to deal in the Software without restriction, including
    % without limitation the rights to use, copy, modify, merge, publish,
    % distribute, sublicense, and/or sell copies of the Software, and to
    % permit persons to whom the Software is furnished to do so, subject to
    % the following conditions:
    % 
    % The above copyright notice and this permission notice shall be
    % included in all copies or substantial portions of the Software.
    % 
    % THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    % EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    % MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    % NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
    % BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
    % ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    % CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    % SOFTWARE.
    properties
        last_args = {''};
        child = ConsoleLogger.empty
    end
    methods
        function print(this, varargin)
            % Print to console, resetting to beginning of line based on
            % whatever was printed last.
            
            % If this logger has a child, check to see if it printed
            % something last and clean it if it did. It's important that
            % "clean_last" also resets the last_args property or else the
            % child would try to clear an already cleared console!
            if ~isempty(this.child) && ~isempty(this.child.last_args)
                this.child.clean_last();
            end
            
            % Clear any last prints for this logger
            if ~isempty(this.last_args)
                this.clean_last();
            end

            % Print to console
            fprintf(varargin{:});
            % Save what was printed
            this.last_args = varargin;
        end
        
        function child = create_child(this)
            % Create a child logger and return it (useful for nesting)
            this.child = ConsoleLogger;
            child = this.child;
        end
        
        function clean_last(this)
            % Clear the last elements written to console
            ConsoleLogger.clean(this.last_args{:});
            this.last_args = {''};
        end
    end
    
    methods (Static)
        function clean(varargin)
            % Write the backspace character to console basd on the
            % formatted size of the arguments
            fprintf(repmat('\b',1,length(sprintf(varargin{:}))));
        end
    end
end