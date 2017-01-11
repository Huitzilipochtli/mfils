function suptitlespe(str,fontsize)

if nargin==1, fontsize=12; end

suptitle(str,'Fontsize',fontsize,'Fontweight','demi','interpreter','latex')