function config2runtimemat();
% produces tremorruntime.mat
print_debug(sprintf('> %s', mfilename),5)
[paths,PARAMS]=pf2PARAMS;
infile = 'params/subnets.d';
fin = fopen(infile,'r');
c=0;
usethissubnet = 0;
while 1,
	tline = fgetl(fin);
	if ~ischar(tline),break,end

	if strfind(tline, 'SUBNET') 
		fields = regexp(tline, '\t', 'split') ;
		usethissubnet = str2num(fields{5});
		if (usethissubnet == 1)
			c = c + 1;
			cc = 0;
			subnets(c).name = fields{2};
        		subnets(c).source.latitude = str2num(fields{3});
        		subnets(c).source.longitude = str2num(fields{4});
			subnets(c).use = str2num(fields{5});
		end

	end
	if (usethissubnet==1)
	    if strfind(tline, 'scn')
		fields = regexp(tline, '\t', 'split'); 
		if str2num(fields{7})==1 % use==1
			cc = cc + 1;
			scn = fields{2};
			scnfields = regexp(scn, '\.', 'split');
	                subnets(c).stations(cc).name = scnfields{1};                   
	                subnets(c).stations(cc).channel = scnfields{2};
	                subnets(c).stations(cc).scnl = scnlobject(scnfields{1}, scnfields{2}, scnfields{3});
	                subnets(c).stations(cc).distance = deg2km(distance(str2num(fields{3}), str2num(fields{4}), subnets(c).source.latitude, subnets(c).source.longitude)); 
	                subnets(c).stations(cc).latitude = str2num(fields{3});
	                subnets(c).stations(cc).longitude = str2num(fields{4});
	                subnets(c).stations(cc).elev = str2num(fields{5});
	                subnets(c).stations(cc).response.calib = str2num(fields{6});
		end
	    end
	end
end
fclose(fin)


save pf/tremor_runtime.mat subnets PARAMS paths
print_debug(sprintf('< %s', mfilename),5)
