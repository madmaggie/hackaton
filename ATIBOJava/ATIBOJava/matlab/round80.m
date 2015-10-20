function n_int=round80(n)
if (n > floor(n) + 0.8)
	n_int = ceil(n);
else
	n_int = floor(n);
end