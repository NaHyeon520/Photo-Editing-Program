function g = imPad4e(f,r,c,padtype,loc)

padVal = 0;

if nargin == 4
	loc='both';
end

[M,N]=size(f);

%Get the values of the rows to be used for padding
if isequal(padtype,'zeros')
	row_first = padVal*ones(1,N);
	row_last = padVal*ones(1,N);
elseif isequal(padtype,'replicate')
	row_first = f(1,:);
	row_last = f(M,:);
else
	error('Unknown padtype');
end	

%Pad rows first
switch loc
	case 'both'
		if r>0
			topPad = repmat(row_first,[r,1]);
			g1 = cat(1,topPad,f);
			bottomPad = repmat(row_last,[r,1]);
			g = cat(1,g1,bottomPad);
		end
	case 'post'
		if r>0
			bottomPad = repmat(row_last,[r,1]);
			g = cat(1,f,bottomPad);
		end
end

%Update M & N for column padding
[M,N]=size(g);

%Get the values fo the columns to be used for padding
if isequal(padtype,'zeros')
	col_first = padVal*ones(M,1);
	col_last = padVal*ones(M,1);
elseif isequal(padtype,'replicate')
	col_first = g(:,1);
	col_last = g(:,N);
else
	error('Unknown padtype');
end	

%Pad columns
switch loc
	case 'both'
		if c>0
			leftPad = repmat(col_first,[1,c]);
			g1 = cat(2,leftPad,g);
			rightPad = repmat(col_last,[1,c]);
			g = cat(2,g1,rightPad);
		end
	case 'post'
		if c>0
			rightPad = repmat(col_last,[1,c]);
			g = cat(2,g,rightPad);
		end
end

end