% Modeli egitmek icin kullanilan veriler
veri = [
    "Çok beğendim, teşekkür ediyorum.", "olumlu";
    "Fiyat performans ürünü, çok kaliteli çıktı.", "olumlu";
    "Mükemmel.", "olumlu";
    "Efsane.", "olumlu";
    "Gayet kaliteli, sorunsuz geldi.", "olumlu";
    "Güzel.", "olumlu";
    "Bayıldım.", "olumlu";
    "Alın, aldırın", "olumlu";
    "Gönül rahatlığıyla alabilirsiniz.", "olumlu";
    "Sağlam.", "olumlu";
    "Oldukça kullanışlı.", "olumlu";
    "Fotoğraftakinin aynısı geldi.", "olumlu";
    "Kargo hızlıydı.", "olumlu";
    "Paketleme çok hoştu. Tavsiye ederim.", "olumlu";
    "Memnunum, severek kullanıyorum.", "olumlu";
    "Fiyatına göre iyi", "olumlu";
    "Memnun kaldım.", "olumlu";
    "Satıcı ilgili.", "olumlu";
    "Sorunsuz ve hızlı teslim edildi. Teşekkürler.", "olumlu";
    "Hızlı teslimat ve güzel paketleme.", "olumlu";
    "Beğendim, kalitesi mükemmel.", "olumlu";
    "Uzun süredir kullanıyorum ve gayet memnunum.", "olumlu";
    "Beklediğimden daha kaliteli çıktı, kesinlikle almanızı öneririm.", "olumlu";
    "Şahane.", "olumlu";
    "Beklediğimden daha iyi", "olumlu;"
    "Fiyatına göre başarılı", "olumlu";
    "Kötü değil ama çok da birşey beklememek gerek.", "nötr";
    "Fena değil, idare eder.", "nötr";
    "Fiyatına göre normal.", "nötr";
    "Kötü değil ama çok iyi de değil.", "nötr";
    "Daha iyi olabilirdi.", "nötr";
    "İş görür.", "nötr";
    "İdare eder, iş görüyor, beklentiniz yüksek olmasın.", "nötr";
    "Ortalama, ekstra bir özelliği yok.", "nötr";
    "Fiyatına göre fena değil", "nötr";
    "Orta kalite.", "nötr";
    "Kalitesi sıfır, iade ettim.", "olumsuz";
    "Hayal kırıklığı.", "olumsuz";
    "Resimde göründüğü kadar güzel değil.", "olumsuz";
    "Kesinlikle almayın.", "olumsuz";
    "Gelen ürünün fotoğraftakiyle alakası yok.", "olumsuz";
    "Kusurlu geldi. Tavsiye etmiyorum.", "olumsuz";
    "Kötü, beğenmedim.", "olumsuz";
    "Kaliteli değil.", "olumsuz";
    "Kalitesiz.", "olumsuz";
    "Güzel değil.", "olumsuz";
    "Hiç iyi değil.", "olumsuz";
    "Beklediğim kadar iyi değil", "olumsuz";
    "Ürün bana ulaşmadı", "olumsuz";
    "Satıcı çok özensizdi.", "olumsuz";
    "Ürün hasarlı geldi. Tavsiye etmiyorum.", "olumsuz";
    "Bozuk geldi", "olumsuz";
    "Hemen yırtıldı", "olumsuz";
    "Yırtık geldi","olumsuz";
    "Hemen bozuldu.", "olumsuz";
    "Hiç dayanıklı değil.", "olumsuz";
    "Arızalı göndermişler", "olumsuz";
    "Kullanışsız, iade etmek zorunda kaldım.", "olumsuz";
    "Geç kargoya verildi ve kalitesiz.", "olumsuz";
    "Kargo yavaş, ürün rezalet.", "olumsuz";
];

canta = KelimeCantasi(veri(:, 1));
% egitim verisindeki yorumlari KelimeCantasi fonksiyonuna verdik

model = fitcnb(canta.Data, veri(:, 2), 'DistributionNames', 'mn');
% naive bayes siniflandiricisi olusturduk ve verileri parametre olarak
% gondererek egittik (model icin multinominal dagilim kullandik)

kullaniciYorum = input('kullanıcı yorumu: ', 's');   % kullanicidan yorum aldik
kullaniciYorum = string(kullaniciYorum);            % yorumu string formatina cevirdik

kullaniciCanta = KelimeCantasi({kullaniciYorum});
% kullanicidan alinan yorumu KelimeCantasi fonksiyonuna verdik

kullaniciVeri = zeros(1, length(canta.benzersizKelimeler)); % 1 satir n sutunlu her elemani 0 olan vektor(dizi)
for i = 1:length(kullaniciCanta.benzersizKelimeler)         
    % 1'den egitim verisindeki essiz kelimelerin sayisina kadar calisacak dongu
    idx = find(strcmp(canta.benzersizKelimeler, kullaniciCanta.benzersizKelimeler{i}));
    % kullanicinin girdigi yorumla egitim verisindeki kelimelerin indexi
    kullaniciVeri(idx) = kullaniciCanta.Data(1, i);
    % kullanicinin girdigi yorumdaki kelimenin sayisini, egitimdekine gore pozisyonlar 
end  % egitimdekiyle ayni formatta ozellik vektorleri olusturduk     

tahmin = predict(model, kullaniciVeri);
% tahmin = predict fonksiyonuyla modeli kullanarak elde edilen tahmin

tahmin = char(tahmin); % predict fonksiyonundan hucre degerini karaktere cevirir (olumlu, olumsuz, notr)
fprintf('tahmin edilen durum: %s\n', tahmin); % tahmin degeri ekrana yazdırılır

% text analytics toolbox'a sahip olmadigimiz icin alternatif bagOfWords
% fonksiyonu
function cantaModeli = KelimeCantasi(metin)
    % metin: Hücre dizisi olarak metinler
    tumKelimeler = [];
    for i = 1:length(metin)
        kelimeler = lower(metin{i});  % Küçük harfe çevir
        kelimeler = regexprep(kelimeler, '[^\w\s]', '');  % Noktalama işaretlerini kaldır
        kelimeler = strsplit(kelimeler);  % Kelimelere ayır
        tumKelimeler = [tumKelimeler, kelimeler];  % Bütün kelimeleri birleştir
    end
    
    % Tüm benzersiz kelimeleri al
    benzersizKelimeler = unique(tumKelimeler);
    
    % Her metindeki kelime sayısını tutacak bir matris oluştur
    kelimeSayisi = zeros(length(metin), length(benzersizKelimeler));
    
    % Her metin için kelime frekanslarını hesapla
    for i = 1:length(metin)
        kelimeler = lower(metin{i});  % Küçük harfe çevir
        kelimeler = regexprep(kelimeler, '[^\w\s]', '');  % Noktalama işaretlerini kaldır
        kelimeler = strsplit(kelimeler);  % Kelimelere ayır
        
        % Her benzersiz kelime için sayısını artır
        for j = 1:length(benzersizKelimeler)
            kelimeSayisi(i, j) = sum(strcmp(kelimeler, benzersizKelimeler{j}));
        end
    end
    
    % Sonuçları yapı içerisinde döndür
    cantaModeli = struct();
    cantaModeli.benzersizKelimeler = benzersizKelimeler;  % Benzersiz kelimeler
    cantaModeli.Data = kelimeSayisi;          % Her metnin vektörleştirilmiş hali
end





