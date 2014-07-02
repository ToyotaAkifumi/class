clear all
close all

number = 100;   %number of all data
sample = 20;    %number of sample data from all data 
k = 5;          %k of k-NN method

subplot(1,3,1);
mu_r = [1 5];               %HEIKIN
SIGMA_r = [2 1.5; 1.5 3];   %KYO-BUNSAN
r = mvnrnd(mu_r,SIGMA_r,number); %random matrix
plot(r(:,1),r(:,2),'r+');
hold on

mu_b = [5 2];
SIGMA_b = [2 1.5; 1.5 2];
b = mvnrnd(mu_b,SIGMA_b,number);
plot(b(:,1),b(:,2),'b+');
xlabel('all data');
hold on


for a = 1:number

    ran(2*a - 1,1) = b(a,1);
    ran(2*a ,1) = r(a,1);
    ran(2*a - 1,2) = b(a,2);
    ran(2*a ,2) = r(a,2);
    
end


grid on
a_b = 1;
a_r = 1;
num_b = zeros(1,2*number);
num_r = zeros(1,2*number);

class_b(1,1) = 0;
class_b(1,2) = 0;
class_r(1,1) = 0;
class_r(1,2) = 0;


for a = 1:sample/2 %sample_data for studying 
        
        class_b(a_b,1) = ran(2*a - 1,1); %classify ran() to blue(class_b)
        class_b(a_b,2) = ran(2*a - 1,2);
        num_b(2*a - 1) = 1;
        a_b = a_b + 1;
    
        class_r(a_r,1) = ran(2*a,1);     %classify ran() to red(class_r)
        class_r(a_r,2) = ran(2*a,2);
        num_r(2*a) = 1;
        a_r = a_r + 1;
        

end

subplot(1,3,2);

plot(class_b(:,1),class_b(:,2),'bo');
hold on
plot(class_r(:,1),class_r(:,2),'ro');
xlabel('sampling data');

%plot(r(:,1),r(:,2),'b+');
%plot(b(:,1),b(:,2),'r+');
grid on

for c =  sample + 1 : 2*number % k-NN method c:present input

    count_r = 0; %k-NN class r
    count_b = 0; %k-NN class b

    for d = 1:c-1 % d:past input
        dist(d) = ((ran(c,1)-ran(d,1))^2 + (ran(c,2)-ran(d,2))^2)^(1/2); % distance from each data 
    end
    
    sort_d = sort(dist);    %sort distance data
    
    for e = 1:k
        ind(e) = find(dist == sort_d(e));   % count class of k-data which is nearest from ran()    
    
        if num_b(ind(e)) == 1            
            count_b = count_b +1;
        elseif num_r(ind(e)) == 1
            count_r = count_r +1;
        else
            disp('error1');
        end
    end
    
    if count_r < count_b    %choice ran() is class_b or class_r 
      
        class_b(a_b ,1) = ran(c,1);
        class_b(a_b ,2) = ran(c,2);
        num_b(c) = 1;
        a_b = a_b + 1; 
    elseif count_r > count_b
        class_r(a_r,1) = ran(c,1);
        class_r(a_r,2) = ran(c,2);
        num_r(c) = 1;
        a_r = a_r + 1;
    else
        disp('error2');
    end
    
    if count_r + count_b ~= k
        disp('error3');
    end
    
end


subplot(1,3,3);
plot(class_b(:,1),class_b(:,2),'bo');
hold on
plot(class_r(:,1),class_r(:,2),'ro');
plot(r(:,1),r(:,2),'r+');
plot(b(:,1),b(:,2),'b+');

xlabel('classified data');
grid on
