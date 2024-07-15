```matlab
        function results = checkInputs(~, data, pos, varargin)
            isscalarnumber = @(x) (isnumeric(x) & isscalar(x));
            p = inputParser();
            p.addRequired('Data', @(x)isnumeric(vertcat(x{:})));
            p.addRequired('Pos', isscalarnumber);
            p.addParameter('Width', 0.3, isscalarnumber);
            p.addParameter('Bandwidth', [], isscalarnumber);
            iscolor = @(x) (isnumeric(x) & size(x,2) == 3);
            p.addParameter('ViolinColor', [], @(x)iscolor(vertcat(x{:})));
            p.addParameter('MarkerSize', 24, @isnumeric);
            p.addParameter('MedianMarkerSize', 36, @isnumeric);
            p.addParameter('LineWidth', 0.75, @isnumeric);
            p.addParameter('BoxColor', [0.5 0.5 0.5], iscolor);
            p.addParameter('BoxWidth', 0.01, isscalarnumber);
            p.addParameter('EdgeColor', [0.5 0.5 0.5], iscolor);
            p.addParameter('MedianColor', [1 1 1], iscolor);
            p.addParameter('ViolinAlpha', {0.3,0.15}, @(x)isnumeric(vertcat(x{:})));
            isscalarlogical = @(x) (islogical(x) & isscalar(x));
            p.addParameter('ShowData', true, isscalarlogical);
            p.addParameter('ShowNotches', false, isscalarlogical);
            p.addParameter('ShowMean', true, isscalarlogical);
            p.addParameter('ShowBox', true, isscalarlogical);
            p.addParameter('ShowMedian', true, isscalarlogical);
            p.addParameter('ShowWhiskers', true, isscalarlogical);
            validSides={'full', 'right', 'left'};
            checkSide = @(x) any(validatestring(x, validSides));
            p.addParameter('HalfViolin', 'full', checkSide);
            validQuartileStyles={'boxplot', 'shadow', 'none'};
            checkQuartile = @(x)any(validatestring(x, validQuartileStyles));
            p.addParameter('QuartileStyle', 'boxplot', checkQuartile);
            validDataStyles = {'scatter', 'histogram', 'none'};
            checkStyle = @(x)any(validatestring(x, validDataStyles));
            p.addParameter('DataStyle', 'none', checkStyle);
            
            p.parse(data, pos, varargin{:});
            results = p.Results;
        end
