function par_line(file1)
  data = readfile(file1);

  n = 3; 

  f = 1.0;         %Temporary value

  m = size(data,1);
  if m<n; fprintf('M < 3 / error\n'); return; end
  
  a = zeros(m,n);
  a(:,1) = data(:,4) - data(:,2);
  a(:,2) = -(data(:,3) - data(:,1));
  a(:,3) = data(:,2) .* -a(:,2)  - data(:,1) .* a(:,1);

  [U,S,V] = svd(a);  % call matlab SVD routine
  v_min = V(:,n); % s and v are already sorted from largest to smallest
  if all(v_min < 0); v_min = -v_min; end % ?

  wvec = [v_min(1)/f v_min(2)/f v_min(3)];
  wvec = wvec / norm(wvec,2);
  fprintf('Least squares solution vector %d     : (%f %f %f)\n',i,wvec );




function data=readfile(file)
  f = fopen(file,'r');
  for i=1:4; fgets(f); end
  all = fscanf(f,'%f %f %f %f '); m = length(all)/4;
  data= reshape(all,4,m)';
  fclose(f);
