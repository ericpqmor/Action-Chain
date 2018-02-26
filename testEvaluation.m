% Creates a Heatmap of the evaluate function used in the Action Evaluator

%Field constants
height = 600; 
width = 940;

z = zeros(height, width);
  
for r = 1:height
    for c = 1:width
      z(r,c) = evaluateFunction(c,r);
    end
end

fig = figure;

colormap('jet');
imagesc(z);
colorbar;