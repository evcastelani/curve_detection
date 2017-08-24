using Images, Colors, FixedPointNumbers, ImageView

function htmain(filename::String,draw::Bool,real::Bool)
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
    #discretized radius
    r= [20.0:1.0:120.0;]
    #discretized angle
    ang=[0:2.0*pi/100:2.0*pi;]
    #run the ht function
    @time cfx,cfy,rf = ht(A,m,n,r,ang)
    if draw 
        draw_solution(filename,A,cfx,cfy,rf,real)
    end
end

#function to find the most voted element
function findind(tensor::Array{Float64,3})
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

#hough transform
function ht(FigCoord,m,n,r,ang)
    npun=length(FigCoord[:,1])
    #initialized accumulation array
    Mvot=zeros(m,n,length(r))
    #definning a precision
    ep=1.0
        for i=1:npun
            for ir=1:length(r)
                for iang=1:length(ang)
                      cx=(FigCoord[i,1]) -r[ir]*cos(ang[iang])
                      cy=(FigCoord[i,2]) -r[ir]*sin(ang[iang])
                      Mvot[Int(abs(round(cx))+1),Int(abs(round(cy))+1),ir]=Mvot[Int(abs(round(cx))+1),Int(abs(round(cy))+1),ir]+1
                end

            end

        end
    (cx,cy,ir,vm)=findind(Mvot)
    rf=r[ir]
    print_with_color(:blue,"radius = $rf, center = ($cx , $cy ), number of votes = $vm \n")
    return cx,cy,rf
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

