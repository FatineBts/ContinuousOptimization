function subgradient_method(eps,tau, pi0, interlimit,DualNoChangTOL,f,theta,A,b,ub,lb)

%eps control parameter
%tau appartient � ]0, 2[ control parameter
%pi0 initial nonnegative vector (usually the nul vector)
%iterLimit number of maximum iterations
%DualNoChangTOL accepted number of iterations without change in the value of the dual function

%Ensure: A local optimum of theta and an approximate primal solution x
%Set k = 1 and t = 1
%Set betak = - inf and pik = pi0

k=1; 
t=1; 
beta=-1e-30; % infinie
pi=pi0; 
J = length(pi0);
x=zeros(J,1);
gamma=zeros(J,1);

% crit�res d'arr�ts

while ( abs( f(x) - theta(pi) )/theta(pi) > eps || k <= iterLimit )

    % Solve the Lagrangian relaxation: theta(pi) = min L(x,pi) avec x
    % appartient � F
    % set x <- argmin{L(x,pik):x appartient � F}
    
   [x, theta] = linprog(f, A, b, [], [], lb, ub); %donne le minimum de la fonction f
    
   %for all j appartient J do: gamma^{k}_{j} = g_{j}(x^{k}) end for 
   
   for j=1:J
       gamma(j)=g(x(j));%je sais pas ce que c'est que g ? les contraintes ? 
   end 
   
   % if theta(pi^k) > beta^k then set beta^k+1 = theta(pi^k)
   % else 
   
   if theta > beta
       beta=theta; 
   
   %else if t <= DualNoChangTOL then Set t = t + 1
   else
       if t <= DualNoChangTOL
           t=t+1; 
       else 
            tau=tau/2; 
            t=1; 
       end 
   end
   
   %if ?k =0 then Stop; The current solution is optimal
   
   if gamma==0
       k = interlimit+1; % on arr�te l'algorithme
   
   % else thetachapeau= applyMHeuristic (x^k,f,X?F)
   
   else 
      [x1, theta_c] = ga(f,n+3*m*n+m*n*n,A,b,[],[],lb,ub);
      
      %for all j appartient J do ... end for 
      
      for j=1:J
        pi(j) = max(0,pi(j)-(tau*(theta-theta_c)/norm(gamma))*gamma(j));  
      end 
      
      %Set k = k + 1
      
      k= k+1; 
      
      %end if 
   end 
     
end

end 

