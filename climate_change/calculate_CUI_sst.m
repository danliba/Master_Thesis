function calculate_CUI_sst(in_path)

    %% CUI SST offshore - inshore.
    [mask,LON,LAT,~,~]=lets_get_started_CC;
    cd(in_path);

    SSTi = struct2array(load(fullfile(in_path,'SST_SSH.mat'), 'SST'));
    %% Lets get the inshore at 150km
    arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/BUI/BK150km.kml';
    %arch_kml_zona1='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST/BK111km.kml';
    R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

    ind1=double(inpolygon(LON,LAT,lonb1,latb1));
    ind1(ind1==0)=NaN;

    SST_inshore = SSTi.*ind1.*mask;

    %% Let's get the offshore at 500– 600 km 
    %600km
    arch_kml_zona3='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST/BK600km.kml';
    R3=kml2struct(arch_kml_zona3); lonb3=R3.Lon; latb3=R3.Lat;

    %500km
    arch_kml_zona2='/Volumes/BM_2022_x/Hindcast_1990_2010/Indices/SST/BK500km.kml';
    R2=kml2struct(arch_kml_zona2); lonb2=R2.Lon; latb2=R2.Lat;

    ind3=double(inpolygon(LON,LAT,lonb3,latb3));
    ind3(ind3==0)=NaN;

    ind2=double(inpolygon(LON,LAT,lonb2,latb2));
    ind2(ind2==1)=NaN;

    offshore_mask = ind3.*ind2.*mask; offshore_mask(offshore_mask==0)=1;

    SST_offshore_600km = SSTi.*offshore_mask;

    %% Now the LTM
    LTM_SST_offshore = mean(SST_offshore_600km,3,'omitnan');
    LTM_SST_inshore = mean(SST_inshore,3,'omitnan');
    Humboldt_ports;
    %% 
    [~,ylab] = generateYLabels(20,5,5);
    [~,xlab] = generateXLabels(90,70,5);

    figure 
    P=get(gcf,'position');
    P(3)=P(3)*1;
    P(4)=P(4)*1.2;
    set(gcf,'position',P);
    set(gcf,'PaperPositionMode','auto');

    [c,h]=contourf(LON,LAT,LTM_SST_offshore,[10:0.1:30]); shading flat;
    axis([-90 -70 -20 -5]);set(h,'LineColor','none');
    hold on
    pcolor(LON,LAT,LTM_SST_inshore.*mask); shading flat;
    hold on
    hold on
    for i = 1:length(Puertos)
        key = Puertos{i,1}; % Get port name
        x = Puertos{i,2}(2); % Get longitude
        y = Puertos{i,2}(1); % Get latitude
        plot(x,y,'ko--','markerfacecolor','m');
        text(x+0.2, y, key, 'FontSize', 20); % Plot text
    end

    ax = gca;
    ax.FontSize = 20;
    ylabel('Latitude'); xlabel('Longitude');
    colorbar; cmocean('thermal',11);
    caxis([16 26])
    title('LTM Offshore and Inshore SST');
    ticks = 16:2:26;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$^\circ C$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
    set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
    set(gca,'xtick',[-90:5:-70],'xticklabel',xlab,'xlim',[-90 -70]);
    savefig('LTM_CUI'); close;
    %% compute CUI
    indxlat = find(LAT(1,:)<=-5 & LAT(1,:)>=-20)';
    lati=LAT(1,indxlat)';

    SST_offshore_lat=permute(mean(SST_offshore_600km(:,indxlat,:),1,'omitnan'),[2 3 1]);
    SST_inshore_lat = permute(mean(SST_inshore(:,indxlat,:),1,'omitnan'),[2 3 1]);

    CUI_SSTi =  abs(SST_inshore_lat -SST_offshore_lat) ;
    %% 
    time=[1:12]';

    %% monthly
    ylab={'20S','15S','10S','5S'};
% 
%     figure
%     P=get(gcf,'position');
%     P(3)=P(3)*2;
%     P(4)=P(4)*1;
%     set(gcf,'position',P);
%     set(gcf,'PaperPositionMode','auto');
% 
%     [c,h]=contourf(time,lati,CUI_SSTi,[-70:0.1:70]);colorbar; 
%     cmocean('balance',21); set(h,'LineColor','none'); clabel(c,h);
%     title('Monthly CUI','fontsize',22); 
%     ax = gca;
%     ax.FontSize = 24;
%     ylabel('Latitude'); xlabel('Time');
%     ax = gca;
%     ax.FontSize = 24; 
%     caxis([-10 10]);
%     ticks = -10:2:10;
%     c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
%     c.Label.String = '$^\circ C$';
%     c.Label.Interpreter = 'latex';
%     c.Label.FontSize = 24;
%     set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
    

    %% climatology

    timeclim=1:12;
    ylab={'20S','15S','10S','5S'};
    xlab={'J','F','M','A','M','J','J','A','S','O','N','D'};


    grey = [0.5 0.5 0.5];

    figure
    P=get(gcf,'position');
    P(3)=P(3)*2;
    P(4)=P(4)*1;
    set(gcf,'position',P);
    set(gcf,'PaperPositionMode','auto');

    subplot(1,2,1)
    [c,h]=contourf(timeclim,lati,SST_offshore_lat,[-100:0.1:100]);shading flat; colorbar; 
    cmocean('thermal',11); clabel(c,h);set(h,'LineColor','none'); 
    hold on
    % [c,h]=contour(timeclim,latCUTI,climBEUTI,[-100:20:100],'Color',grey);
    % clabel(c,h);
    title('SST$_{\mathrm{(Offshore)}}$ Climatology', 'FontSize', 20);
    ax = gca;
    ax.FontSize = 20;
    ylabel('Latitude'); xlabel('Months');
    caxis([16 26])
    ticks = 16:2:26;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$^\circ C$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
    set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
    set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);

    subplot(1,2,2)
    [c,h]=contourf(timeclim,lati,SST_inshore_lat,[-100:0.1:100]);shading flat; colorbar; 
    cmocean('thermal',11); clabel(c,h);set(h,'LineColor','none'); 
    hold on
    % [c,h]=contour(timeclim,latCUTI,climBEUTI,[-100:20:100],'Color',grey);
    % clabel(c,h);
    title('SST$_{\mathrm{(Inshore)}}$ Climatology', 'FontSize', 20);
    ax = gca;
    ax.FontSize = 20;
    ylabel('Latitude'); xlabel('Months');
    caxis([16 26])
    ticks = 16:2:26;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$^\circ C$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
    set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
    set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
    savefig('LTM_INSHORE_OFFSHORE'); close;
    %% Climatology CUI 

    figure
    %set(groot, 'defaultTextInterpreter', 'latex');
  
    [c,h]=contourf(timeclim,lati,CUI_SSTi,[-15:0.1:15]);shading flat; colorbar; 
    cmocean('balance',21); clabel(c,h);set(h,'LineColor','none'); 
    hold on
    % [c,h]=contour(timeclim,latCUTI,climBEUTI,[-100:20:100],'Color',grey);
    % clabel(c,h);
    title('CUI$_{\mathrm{(SST)}}$ Climatology', 'FontSize', 20);
    ax = gca;
    ax.FontSize = 20;
    ylabel('Latitude'); xlabel('Months');
    caxis([-10 10]);
    ticks = -10:2:10;
    c=colorbar('YTick', ticks, 'YTickLabel', arrayfun(@num2str, ticks, 'UniformOutput', false));
    c.Label.String = '$^\circ C$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 20;
    set(gca,'ytick',[-20:5:-5],'yticklabel',ylab,'ylim',[-20 -5]);
    set(gca,'xtick',[1:1:12],'xticklabel',xlab,'xlim',[1 12]);
    savefig('CUI_climatology'); close;

    %% 
    Mean_CUI = mean(CUI_SSTi,1,'omitnan');
    CUI_lat = mean(CUI_SSTi,2,'omitnan');
    %plot(time,Mean_CUI'); datetick('x');
    save('CUI_SST_index.mat','time','lati','CUI_SSTi','SST_inshore_lat','SST_offshore_lat','Mean_CUI','CUI_lat');

end