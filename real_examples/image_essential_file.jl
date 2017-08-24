############################pacotes basicos#####################################

using Gadfly

using Images, Colors, FixedPointNumbers, ImageView

################################################################################

include("auxiliar.jl")

################################################################################

function image_essential(n_img_without_ext::String,val::Float64)

n_img=string(n_img_without_ext,".jpg")

img=load(n_img)
#view(img)

img_gray=convert(Image{Gray},img)
#view(img_gray)

img_gauss=imfilter(img_gray,Kernel.gaussian(1))

img_bin=img_gauss .<= val
#imshow(img_bin)

img_edge=imedge(img_bin,"sobel")
#view(img_edge[1])
imshow(img_edge[1])

img_pol=convert_float_to_bin(img_edge[1])
#display(findnz(img_pol))

(vet2,vet1)=findnz(img_pol)
#my_plot=plot(x=vet1,y=vet2,Geom.point,Theme(default_point_size=0.8pt,
#default_color=colorant"black"))
#draw(PDF("myplot.pdf", 12cm, 12cm), my_plot)

writedlm("$n_img_without_ext.txt",[vet1 vet2])

end

###########################running##############################################
#here you must modify (change moedas and 0.75)

image_essential("vinil2",0.2)

################################################################################
