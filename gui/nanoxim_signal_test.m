function nanoxim_signal_test()

img = 10+rand(512, 512);


for n=0:10
rat_img = nanoxim_CalculateRatiomImage(ones(512,512,3), ...
    cat(3,n*10+6*ones(512,512), ones(512,512),6*ones(512,512)),[2 2 2]);
fprintf('Blue: %d, Red: %d, Ratio[B/R]: %f\n',6-1,n*10+6-1,mean(mean(rat_img)))

end

end