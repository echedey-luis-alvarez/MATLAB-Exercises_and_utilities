function E = euler( f, a, b, y_a, M )
    h = (b - a) ./ M; disp(h);
    E = NaN( [M+1, 3] );
    E(1, :) = [0, a, y_a];
    for j=1:M
       % y(j+1)=y(j)+h*f(t(j),y(j));
       E(j+1, :) = [ j, a + j .* h, E(j, 3) + h * f( E(j, 2), E(j, 3) ) ];
    end % !for
end % !if
