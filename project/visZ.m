function  visZ( A )

load('bunny.mat');
surface.TRIV = trigs;
figure;


subplot(1,2,1);
h = trisurf(surface.TRIV,A(:,1),A(:,2),A(:,3));
        axis image, shading interp, view([0 90]), axis off,
        lighting phong, camlight headlight
        set(h,'SpecularColorReflectance',0.1,'SpecularExponent',100);
end

