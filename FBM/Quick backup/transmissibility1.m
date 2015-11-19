function A_T = transmissibility1(cind1,nind1,myImageVector,a,b,c,nodeN)
    
    upperTriangLinks = [cind1,nind1];
    lowerTriangLinks = [nind1,cind1];
    linkWeight = zeros(length(upperTriangLinks),1);
    for i = 1:length(upperTriangLinks)
        weight = (myImageVector(upperTriangLinks(i,1))*myImageVector(upperTriangLinks(i,2)))/(myImageVector(upperTriangLinks(i,1))+ myImageVector(upperTriangLinks(i,2)));
        linkWeight(i) = 2*b*c*weight/a;
    end
    linkWeight = [linkWeight;linkWeight];
    A_T = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);

end