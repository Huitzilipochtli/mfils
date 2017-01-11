
NEE  = GPPadj - REadj;
NEEtime = datenum(num2str([Year mthID]),'yyyy    mm');
idx = find(isfinite(Year));
NEE = NEE(idx); NEEtime = NEEtime(idx);

CLeaftime = datenum(num2str([Year3 Month]),'yyyy    mm');
CLidx = find(isfinite(Year3));
CLeaf_avg = avggCm2(CLidx); CLeaf_std = sdgCm2(CLidx); 
CLeaftime = CLeaftime(CLidx);

figure(1);
b = bar(NEEtime,NEE);
set(b,'facecolor','green');
hold on; bar(CLeaftime,CLeaf_avg); 
errorbar(CLeaftime,CLeaf_avg,CLeaf_std);
ylim([0 180]);
xlim([NEEtime(1) NEEtime(end)]);
datetick('x','mmm yy','keeplimits'); 
legend('-NEE','C from litter');
ylabel('-NEE (g C m^{-2}month^{-1})','FontSize',16,'FontName','Arial');
set(gca,'LineWidth',2,'FontSize',16,'FontName','Arial');
