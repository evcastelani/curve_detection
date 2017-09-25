using Images, Colors, FixedPointNumbers, ImageView

function gn(filename::String,draw::Bool,real::Bool,p::Int) #this is the main process
    #this solver was prepared to circle detection
    #get the problem
    dirtag="synthetic_examples"
    curr_dir=pwd()
    if real 
        dirtag="real_examples"
        cd(dirtag)
        A=readdlm("$filename.txt", Float64) 
    else
        cd(dirtag)
        A=readdlm("$filename.dat", Float64) 
    end
    cd(curr_dir)
    n=length(A[:,1])
    # initial grid
    ix=[minimum(A[:,1]):(maximum(A[:,1])-minimum(A[:,1]))/20.0:maximum(A[:,1]);]
    iy=[minimum(A[:,2]):(maximum(A[:,2])-minimum(A[:,2]))/20.0:maximum(A[:,2]);]
    nix=length(ix)
    mix=length(iy)
    cfx=zeros(nix,mix)
    cfy=zeros(nix,mix)
    rf=zeros(nix,mix)
    nval=zeros(nix,mix)
    itot=0
    itin=0
    @time   for i=1:nix
                for j=1:mix
            	    cfx[i,j],cfy[i,j],rf[i,j],nval[i,j],itin=gauss_newton(residuo,F,dF,[ix[i],iy[j],10.0],A,n,p)
                    itot=itot+itin
                end
            end
    i,j,val=findind(nval)
    cex=cfx[i,j]
    cey=cfy[i,j]
    re=rf[i,j]
    println("it tot = $itot")
    println(cex," ", cey," ",re," ",val)
    println(maximum(abs.([cex-101.0,cey-42.0,abs(re)-25.0])))
    #ploting results
    if draw 
        draw_solution(filename,A,cex,cey,re,real)
    end        
end

#basic functions
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

function gauss_newton(res,Fobli,Jacres,x0,M,dimM,p)
	ep=10.0^(-4)
    valres=zeros(p)
    s=zeros(length(x0))
	J=zeros(p,3)
	it=1
    valFobli,ord= Fobli(x0,M,dimM,p)
    valres= res(x0,ord,M,p)
	J=Jacres(x0,ord,M,p)
    b=J'*valres
	while (norm(b)>ep)&&(it<100)
		A=J'*J
        s=A\(-b)
        x0=x0+s
        valFobli,ord= Fobli(x0,M,dimM,p)
        valres= res(x0,ord,M,p)
		J=Jacres(x0,ord,M,p)
		b=J'*valres
		it=it+1
	end
    nval=norm(valFobli[1:p],1)
    nb=norm(b)
	return x0[1],x0[2],x0[3],nval,it
end


function findind(M)
    (m,n)=size(M)
    for i=1:m
        for j=1:n
            if abs(M[i,j]-minimum(M))<1.0e-10
                return i,j,minimum(M)
  			    break
            end
        end
    end
end

#draw the solution
function draw_solution(filename,A,cfx,cfy,rf,real)
    angulo=[0:((2*pi)/600):2*pi+1;]
    if real #draw an image
        curr_dir=pwd()
        cd("real_examples")
        img=load("$filename.jpg")
        for i=1:length(angulo)
            img[Int128(abs(round(abs(rf)*cos(angulo[i])+cfy))),Int128(abs(round(abs(rf)*sin(angulo[i])+cfx)))]=RGB{N0f8}(1,0,0)
            img[Int128(abs(round(abs(rf+1)*cos(angulo[i])+cfy))),Int128(abs(round(abs(rf+1)*sin(angulo[i])+cfx)))]=RGB{N0f8}(1,0,0)
        end
        imshow(img)
        cd(curr_dir)
    else #draw a data-set
        img=Gray.(ones(300,300))
        img=RGB{Float32}.(img)
        for i=1:length(A[:,1])
            img[Int(A[i,1]),Int(A[i,2])]=RGB{Float32}(0.0,0.0,1.0)
        end
        for i=1:length(angulo)
            img[Int(abs(round(abs(rf)*cos(angulo[i])+cfx))),Int(abs(round(abs(rf)*sin(angulo[i])+cfy)))]=RGB{Float32}(1.0,0.0,0.0)
            #img[Int128(abs(round(abs(rf+1)*cos(angulo[i])+cfx))),Int128(abs(round(abs(rf+1)*sin(angulo[i])+cfy)))]=RGB{Float32}(1.0,0.0,0.0)
        end
        imshow(img)
    end 
end
