clc
sayac = 0;
aranoron = 50;
dogru_say=0;
yanlis_say=0;
nu = 0.2; % Öðrenme Katsayýsý
alfa = 0.9; % Momentum Katsayýsý



% dizi=zeros(100,4);
% 
% say;
%   
% for aranoron=1:1:55
%     for nu=0.1:0.1:0.9
%         for alfa=0.1:0.1:0.9
%             say=say+1;

            x = Egitim; % Giriþler
            w = zeros(aranoron,9); % Ara Katman Aðýrlýklarý
            dw = zeros(aranoron,9); % Ara Katman Aðýrlýklarýndaki Deðiþim
            b = zeros(aranoron,1); % Ara Katman Biaslarý
            db = zeros(aranoron,1); % Ara Katman Aðýrlýklarýndaki Deðiþim
            o = zeros(aranoron,1); % Ara Katman Çýkýþlarý
            wp = zeros(1,aranoron); % Çýkýþ Katmanlarý Aðýrlýklarý
            dwp = zeros(1,aranoron); % Çýkýþ Katmanlarý Aðýrlýklðarýndaki Deðiþim
            bp = zeros(1,1); % Çýkýþ Katmaný Biaslarý
            dbp = zeros(1,1); % Çýkýþ Katmaný Biaslarýndaki Deðiþim
            rp = zeros(1,1); % Çýkýþ Katmaný Hata Faktörleri
            y = zeros(1,1); % Üretilen Çýkýþlar
            t = EgitimTarget; % Hedef Çýkýþlar
            
            %veriler üzerinde dolaþmak için for
            for k=1:length(Egitim)
                hata=1;
                while(hata>0.01)
                %ara katman çýkýþlarýnýn bulunmasý
                for i=1:aranoron
                    top=0;
                    for n=1:9
                        top=top+x(n,k)*w(i,n);
                    end
                    o(i)=f(top+b(i));
                end
                %çýkýþ katmaný çýkýþlarýnýn bulunmasý
                for n=1:1
                    top=0;
                    for i=1:aranoron
                        top=top+o(i)*wp(n,i);
                    end
                    y(n)=f(top+bp(n));
                end

                %%%%%%%%%%%%%%%%%%ÇIKIÞ KATMANI GÜNCELLEMELERÝ%%%%%%%%%%%%%%
                %çýkýþ hata faktörlerinin hesaplanmasý
                for i=1:1
                    rp(i)=(t(1,k)-y(i))*y(i)*(1-y(i));
                end
                %çýkýþ aðýrlýklarýnýn güncellemesi
                for j=1:aranoron
                    for i=1:1
                        dwp(i,j)=nu*rp(i)*o(j)+alfa*dwp(i,j);
                    end
                end

                %çýkýþ katmaný biaslarýnýn güncellenmesi
                for j=1:1
                    dbp(j)=nu*rp(j)+alfa*dbp(j);
                    bp(j)=bp(j)+dbp(j);
                end

                %%%%%%%%%%%%%% ARA KATMAN GÜNCELLEME %%%%%%%%%%%%%%%%%%
                %ara katman agýrlýklarý güncellemesi
                for i=1:aranoron
                    for j=1:9
                        dw(i,j)=nu*o(i)*(1-o(i))*wp(1,i)*rp(1)*x(j,k);           
                        w(i,j)=w(i,j)+dw(i,j);
                    end
                end


                %ara katman biaslarýnýn güncellenmesi
                for i=1:aranoron
                    db(i)=nu*o(i)*(1-o(i))*wp(1,i)*rp(1);
                    b(i)=b(i)+db(i);
                end
                wp=wp+dwp;
                sayac=sayac+1;
                hata=(1/2)*((t(1,k)-y(1))^2);
                end%while sonu    
            end
            sonuc = zeros(2,length(Test));
            %%%%%%%%%%%% Test Aþamasý %%%%%%%%%%%%
                dogru=0;
                for k=1:length(Test)
                %ara katman çýkýþlarýnýn bulunmasý
                for i=1:aranoron
                     top=0;
                     for n=1:9
                         top=top+Test(n,k)*w(i,n);
                     end
                      o(i)=f(top+b(i));
                end
                %çýkýþ katmaný çýkýþlarýnýn bulunmasý
                for n=1:1
                    top=0;
                    for i=1:aranoron
                        top=top+o(i)*wp(n,i);
                    end
                    y(n)=f(top+bp(n));
                end
                for i=1:1
                    if y(i)>0.5
                        y(i)=1;
                    else
                        y(i)=0;
                    end
                end

                sonuc(1,k) = y(i);
                sonuc(2,k) = TestTarget(1,k);
                if(TestTarget(1,k)==y(1))
                    dogru_say=dogru_say+1;
                    dogru=dogru+1; 
                else
                    yanlis_say=yanlis_say+1;
                end
                end%for sonu
                dogruluk = 100*dogru/length(Test); 

%                 dizi(say,1)=aranoron;
%                 dizi(say,2)=nu;
%                 dizi(say,3)=alfa;
%                 dizi(say,4)=(100*dogru/length(Test));

                fprintf('Kullanýlan Test Setine Göre Oluþturulan Aðýn Doðruluk Oraný : %f\n',dogruluk);
              
%         end
%     end
% end
