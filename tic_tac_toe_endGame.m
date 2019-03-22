clc
sayac = 0;
aranoron = 50;
dogru_say=0;
yanlis_say=0;
nu = 0.2; % ��renme Katsay�s�
alfa = 0.9; % Momentum Katsay�s�



% dizi=zeros(100,4);
% 
% say;
%   
% for aranoron=1:1:55
%     for nu=0.1:0.1:0.9
%         for alfa=0.1:0.1:0.9
%             say=say+1;

            x = Egitim; % Giri�ler
            w = zeros(aranoron,9); % Ara Katman A��rl�klar�
            dw = zeros(aranoron,9); % Ara Katman A��rl�klar�ndaki De�i�im
            b = zeros(aranoron,1); % Ara Katman Biaslar�
            db = zeros(aranoron,1); % Ara Katman A��rl�klar�ndaki De�i�im
            o = zeros(aranoron,1); % Ara Katman ��k��lar�
            wp = zeros(1,aranoron); % ��k�� Katmanlar� A��rl�klar�
            dwp = zeros(1,aranoron); % ��k�� Katmanlar� A��rl�kl�ar�ndaki De�i�im
            bp = zeros(1,1); % ��k�� Katman� Biaslar�
            dbp = zeros(1,1); % ��k�� Katman� Biaslar�ndaki De�i�im
            rp = zeros(1,1); % ��k�� Katman� Hata Fakt�rleri
            y = zeros(1,1); % �retilen ��k��lar
            t = EgitimTarget; % Hedef ��k��lar
            
            %veriler �zerinde dola�mak i�in for
            for k=1:length(Egitim)
                hata=1;
                while(hata>0.01)
                %ara katman ��k��lar�n�n bulunmas�
                for i=1:aranoron
                    top=0;
                    for n=1:9
                        top=top+x(n,k)*w(i,n);
                    end
                    o(i)=f(top+b(i));
                end
                %��k�� katman� ��k��lar�n�n bulunmas�
                for n=1:1
                    top=0;
                    for i=1:aranoron
                        top=top+o(i)*wp(n,i);
                    end
                    y(n)=f(top+bp(n));
                end

                %%%%%%%%%%%%%%%%%%�IKI� KATMANI G�NCELLEMELER�%%%%%%%%%%%%%%
                %��k�� hata fakt�rlerinin hesaplanmas�
                for i=1:1
                    rp(i)=(t(1,k)-y(i))*y(i)*(1-y(i));
                end
                %��k�� a��rl�klar�n�n g�ncellemesi
                for j=1:aranoron
                    for i=1:1
                        dwp(i,j)=nu*rp(i)*o(j)+alfa*dwp(i,j);
                    end
                end

                %��k�� katman� biaslar�n�n g�ncellenmesi
                for j=1:1
                    dbp(j)=nu*rp(j)+alfa*dbp(j);
                    bp(j)=bp(j)+dbp(j);
                end

                %%%%%%%%%%%%%% ARA KATMAN G�NCELLEME %%%%%%%%%%%%%%%%%%
                %ara katman ag�rl�klar� g�ncellemesi
                for i=1:aranoron
                    for j=1:9
                        dw(i,j)=nu*o(i)*(1-o(i))*wp(1,i)*rp(1)*x(j,k);           
                        w(i,j)=w(i,j)+dw(i,j);
                    end
                end


                %ara katman biaslar�n�n g�ncellenmesi
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
            %%%%%%%%%%%% Test A�amas� %%%%%%%%%%%%
                dogru=0;
                for k=1:length(Test)
                %ara katman ��k��lar�n�n bulunmas�
                for i=1:aranoron
                     top=0;
                     for n=1:9
                         top=top+Test(n,k)*w(i,n);
                     end
                      o(i)=f(top+b(i));
                end
                %��k�� katman� ��k��lar�n�n bulunmas�
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

                fprintf('Kullan�lan Test Setine G�re Olu�turulan A��n Do�ruluk Oran� : %f\n',dogruluk);
              
%         end
%     end
% end
