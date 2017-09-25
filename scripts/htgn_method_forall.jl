using Images, Colors, FixedPointNumbers, ImageView
include("aux_file_ht_gn.jl")

function htgnmain(filename::String,check_sol::Bool,real::Bool,p::Int)
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
    #Parameters
    #size of acumulation array
    m= 1000
    n= 1000
    #initial radius
    r= 20.0
    #discretized angle
    ang=[0:2.0*pi/50:2.0*pi;]
    #run HTGN
    if check_sol==true 
        cfx,cfy,rf,levelht,it_gn = htgn(A,m,n,r,ang,p)
        return maximum(abs.([abs(cfx)-101.0,abs(cfy)-42.0,abs(rf)-25.0]))
    else
        return @elapsed cfx,cfy,rf,levelht,it_gn = htgn(A,m,n,r,ang,p)
    end
 
end

#function to find the most voted element
function findindMat(Mat::Array{Float64,2})
  (m,n)=size(Mat)
  vlmax=maximum(abs,Mat)
  for i=1:m
      for j=1:n
              if Mat[i,j]==vlmax
                  return i,j
              end
      end
  end
end

function findindTens(tensor::Array{Float64,3})
  (m,n,p)=size(tensor)
  vlmax=maximum(abs,tensor)
  for i=1:m
      for j=1:n
          for k=1:p
              if tensor[i,j,k]==vlmax
                  return i,j,k,vlmax
              end
          end
      end
  end
end

#HTGN
function htgn(FigCoord,m,n,r,ang,p)
  npun=length(FigCoord[:,1])
  ri=copy(r)
  #output variable
  cx2=0 #center
  cy2=0 #center
  rf2=0 #radius
  nr=100 #auxiliar for radius
  Mvot=zeros(m,n,nr)
  k=1 #level of HT
  itgn=0 #number of gn iterations
  val=1000.0 #value for starting the loop
  tol=15.0*p
  while val>tol && r<ri+nr
        for i=1:npun
                  for iang=1:length(ang)
                      cx=(FigCoord[i,1]) -r*cos(ang[iang])
                      cy=(FigCoord[i,2]) -r*sin(ang[iang])
                      Mvot[Int(abs(round(cx))+1),Int(abs(round(cy))+1),k]=Mvot[Int(abs(round(cx))+1),Int(abs(round(cy))+1),k]+1
                  end
        end
        (cx1,cy1)=findindMat(Mvot[:,:,k])
        (cx2,cy2,rf2,val,it)=gaussnewton_ht(residuo,F,dF,[cx1,cy1,r],FigCoord,npun,p)
        itgn=itgn+it
        r=r+2 #increase radius (can be changed)
        k=k+1
  end
  if r>=ri+nr #if this conditions holds means that acceleration fails
        (cx2,cy2,rf2)=findindTens(Mvot)#aproveitamos os dados para calcular STH
        rf2=ri+2*rf2
  end
  return cx2,cy2,rf2,k,itgn
end


