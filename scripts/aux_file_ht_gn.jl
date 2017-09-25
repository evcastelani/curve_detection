
function Fwo(x,A,n) #Fwo=F without order
    F=zeros(n)
    for i=1:n
    	F[i]=(((A[i,1]-x[1])^2 + (A[i,2]-x[2])^2)-x[3]^2)^2 #here is our curve
    end
    return F
end

function ordena(vet,n,p) #we just applied a partial select sort to vet
    vetaux=zeros(n)
    aux=0
    ind=[1:1:n;]
    for i=1:n
        vetaux[i]=vet[i]
    end
    for i=1:p
        for j=i+1:n
	        if (vetaux[i]>vetaux[j])
	        aux=ind[j]
	        ind[j]=ind[i]
	        ind[i]=aux
	        aux=vetaux[j]
	        vetaux[j]=vetaux[i]
	        vetaux[i]=aux
	        end
        end
    end
    return ind[1:1:p]
end

function F(x,A,n,p) #here is the function that defines the problem
    F=zeros(p)
    Fwo_val=zeros(n)
	ord=zeros(Int64,p)
    Fwo_val= Fwo(x,A,n)
    ord=ordena(Fwo_val,n,p)
    for i=1:p
	    F[i]=Fwo_val[ord[i]]
    end
    return F,ord
end

function residuo(x,ord,A,p)
    F=zeros(p)
    for i=1:p
      	F[i]=(((A[ord[i],1]-x[1])^2 + (A[ord[i],2]-x[2])^2)-x[3]^2) #here is our curve
    end
    return F
end

function dF(x,ord,A,p)
	dF=zeros(p,3)
	for i=1:p
		dF[i,1]=-2.0*(A[ord[i],1]-x[1])
		dF[i,2]=-2.0*(A[ord[i],2]-x[2])
		dF[i,3]=-2.0*(x[3])
	end
	return dF
end

function gaussnewton_ht(res,Fobli,Jacres,x0,M,dimM,p)
    ep=10.0^(-4)
    valres=zeros(p)
    s=zeros(length(x0))
    J=zeros(p,3)
    it=1
    valFobli,ord= Fobli(x0,M,dimM,p)
    valres= res(x0,ord,M,p)
  	J=Jacres(x0,ord,M,p)
    b=J'*valres
    I=eye(3)
	  while (norm(b)>ep)&&(it<50)
	    A=J'*J
        if abs(det(A))<1.0e-5
           A=A+1.0e-2*(I)
        end
        s=A\(-b)
        x0=x0+s
        valFobli,ord= Fobli(x0,M,dimM,p)
        valres= res(x0,ord,M,p)
	    J=Jacres(x0,ord,M,p)
	    b=J'*valres
	    it=it+1
	  end
      nval=norm(valFobli[1:p],2)
  #  nb=norm(b)
	  return x0[1],x0[2],x0[3],nval,it
end
