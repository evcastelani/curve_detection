function convert_float_to_bin(A)
(m,n)=size(A)
B=Array{Int8,2}(m,n)
for i=1:m
    for j=1:n
    	if A[i,j]>0.0
        	B[i,j]=1
        else
        	B[i,j]=0
    	end
    end
end
return B
end
