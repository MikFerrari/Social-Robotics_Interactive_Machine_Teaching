function plot_results(thresholds,true_threshold,tolerance)

    figure

    l1 = line([1 numel(thresholds)],[true_threshold true_threshold],'Color','red','Linewidth',2);
    l2 = line([1 numel(thresholds)],[true_threshold+tolerance true_threshold+tolerance],'Color','black','Linestyle','-.');
    line([1 numel(thresholds)],[true_threshold-tolerance true_threshold-tolerance],'Color','black','Linestyle','-.');
    hold on
    s = scatter(1:numel(thresholds),thresholds,'filled');
    
    curtick = get(gca, 'xTick');
    xticks(unique(round(curtick)));
    
    title('Convergence to the true threshold')
    xlabel('# iteration')
    ylabel('Threshold value')
    legend([l1,l2,s],'True','Tolerance Interval','Predicted','Location','southeast')

    grid on
end

