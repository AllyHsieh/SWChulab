**Violin plot**
  
Analyzing outliers provides valuable insights into data deviations from the norm, offering clues to underlying issues. Visualization tools like Box plots and Violin plots are commonly used for outlier analysis, revealing data distribution, and identifying extreme values. Box plots display quartiles, median, and potential outliers, while Violin plots, an advanced visualization tool, present multiple datasets simultaneously. The Violin plot's central white dot indicates the **median** and narrow black lines convey the **95% confidence interval**, excelling in portraying data distribution vividly. Its adaptability to extensive datasets and nuanced representation of category variations through color gradients make it powerful. Customization options like sorting and splitting enhance flexibility, and integration with Seaborn's catplot facilitates grouping within additional variables. The Violin plot proves versatile and insightful, providing a detailed representation of data distributions for enhanced analytical understanding. In summary, Violin plots are crucial for comprehensive data visualization, surpassing limitations of traditional methods in exploring complex datasets.
```
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
            p.addParameter('ShowMean', false, isscalarlogical);
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
            p.addParameter('DataStyle', 'scatter', checkStyle);
            
            p.parse(data, pos, varargin{:});
            results = p.Results;
        end
