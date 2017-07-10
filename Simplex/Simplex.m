function Simplex(A,b,c)

% Bland = 1 ==> regla de Bland
% Bland = 0 ==> regla dels costos reduïts més negatius
Bland = 1;

[m,n] = size(A);
AI = [A, eye(m)];
iter = 0;

% Inicialització
disp ('Fase I');
N = 1:n;
base = n+1:m+n;
B = eye(m);
invB = B;
An = AI(1:m,1:n);
cn = zeros(1,n);
cb = ones(1,m);
caux = [cn, cb];
xb = b;
z = cb*xb';
iout = 0;

while iout <= 1
    % Identificació d'òptims i selecció de la VNB d'entrada q
    r = cn - cb*invB*An;
    if min(r) >= 0 
        iout = 2;
    else
        if Bland % Regla de Bland
            pos = 1;
            while r(pos) >= 0
                pos = pos + 1;
            end;
        else     % Regla dels costos reduïts més negatius
            pos = 0;
            valor = 0;
            for i=1:n
                if r(i) < valor
                pos = i;
                valor = r(i);
                end
            end
        end
        k = r(pos);
        q = N(pos);
        
        % Identificació de problemes il·limitats
        Aq = AI(1:m,q);
        d = -invB*Aq;
        if min(d) >= 0 
            iout = 3;
        else
            % Selecció de la VB de sortida p
            theta = Inf;
            p = 1;
            for j = 1:m 
                if  d(j) < 0 && theta > -xb(j)/d(j)
                    theta = -xb(j)/d(j);
                    p = j;
                end;
            end;
            if theta == 0
                iout = 1;
            else
                % Actualització
                xb = xb + theta*d';
                xb(p) =  theta;
                z = z +theta*k;
                % Càlcul de la inversa de B mitjançant la matriu E
                nu = zeros(m,1);
                for k=1:m
                    nu(k) = -d(k)/d(p);
                end
                nu(p)= -1/d(p);
                I = eye(m);
                E = [I(1:m,1:p-1) nu I(1:m,p+1:m)];
                invB = E*invB;
                N(pos) = base(p);
                base(p) = q;
                % B = AI(1:m,basis);
                cb(p) = caux(q);
                An = AI(1:m,N(1:n));
                cn = caux(N(1:n));
                iter = iter + 1;
                formatSpec = 'Iteracio %d : iout = %d, q = %d, B(p) = %d, theta* = %4.2f, z = %8.3f\n';
                fprintf(formatSpec,iter,iout,q,N(pos),theta,z);
            end;
        end;
    end;
end;

% Fase I no òptima (amb error)
if z > 1e-12
    disp('Problema Infactible');
else
    disp('SBF trobada');
    % Inicialització Fase II
    disp('Fase II');
    if (iout == 2)
        N = sort(N);
        N = N(1:n-m);
        cb = c(base(1:m));
        cn = c(N(1:n-m));
        B = A(1:m,base(1:m));
        An = A(1:m,N(1:n-m));
        invB = inv(B);
        xb = invB*b';
        z = xb'*cb';
        iout = 0;

        while iout == 0
            %Identificació de s.b.f òptima i selecció de la v.n.b d'entrada q
            r = cn - cb*invB*An;
            if min(r) >= 0 
                iout = 2;
            else
                i = 1;
                while r(i) > 0
                    i = i +1;
                end;
                k = r(i);
                q = N(i);

                % Identificació de problema il·limitat
                Aq = A(1:m,q);
                d = -invB*Aq;
                if min(d) >= 0 
                    iout = 3;
                else

                    % Selecció de la v.b de sortida
                    theta = Inf;
                    p = 1;
                    for j = 1:m 
                        if  d(j) < 0 && theta > (-xb(j)/d(j))
                            theta = -xb(j)/d(j);
                              p = j;
                        end;
                    end;
                    if (theta == 0)
                        iout = 1;
                    else
                        % Actualitzacions i canvi de base
                        xb = xb + theta*d;
                        xb(p) =  theta;
                        z = z +theta*k;
                        % Càlcul de la inversa de B mitjançant la matriu E
                        nu = zeros(m,1);
                        for k=1:m
                            nu(k) = -d(k)/d(p);
                        end
                        nu(p)= -1/d(p);
                        I = eye(m);
                        E = [I(1:m,1:p-1) nu I(1:m,p+1:m)];
                        invB = E*invB;
                        N(i) = base(p);
                        base(p) = q;
                        % B = A(1:m,basis(1:m));
                        cb(p) = c(q);
                        An = A(1:m,N(1:n-m));
                        cn = c(N(1:n-m));
                        iter = iter + 1;
                        formatSpec = 'Iteracio %d : iout = %d, q = %d, B(p) = %d, theta* = %4.2f, z = %8.3f\n';
                        fprintf(formatSpec,iter,iout,q,N(i),theta,z);
                    end;
                end;
            end;
        end;
    end;

    if iout == 1
        disp ('SBF degenerada');
    end;

    if iout == 2
        formatSpec = 'Solucio optima trobada, iteracio %d, z = %8.3f\n';
        fprintf(formatSpec,iter,z); 
    end;

    if iout == 3
        disp ('Problema il·limitat');
    end;

    disp ('Fi del simplex primal');
        if iout == 2
            disp ('Solucio optima:');
            format compact;
            display(base);
            xb=xb';
            display(xb);
            display(z);
            display(r);
        end
end

end
    
