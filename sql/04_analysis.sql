/*
    TR
    --
    WINDOW FUNCTION - moving average
    --------------------------------
    bir satırın hesabını yaparken çevresindeki satırlara(pencereye) bakıyorum.
    satırlar silinmiyor, her satır kendi yerinde, yanına yeni bir sütun ekleniyor.

    Not: WINDOW FUNCTION vs GROUP BY:  
        - GROUP BY: gruplar oluşturuyor, satırlar siliniyor, her grup için tek bir satır kalıyor.

                datetime	close
                10:00	    100
                10:01	    102
                10:02	    101
                10:03	    105
                10:04	    107

                GROUP BY ile ortalama, tek satıra iniş,

                avg_close
                103

        - WINDOW FUNCTION: satırlar yerinde, yanına yeni bir sütun ekleniyor.

                datetime	close	ma_3 (3 satırlık ortalama)
                10:00	    100	    100
                10:01	    102	    101
                10:02	    101	    101
                10:03	    105	    102.7
                10:04	    107	    104.3

                örn -> 10:03 satırı için pencere = 10:01, 10:02, 10:03 → (102 + 101 + 105) / 3 ≈ 102.7.

    Gerçek Hayat Senaryoları:
    - "fiyat şu an ortalamanın üstünde mi altında mı?" sorusu çok sorulur.
        |_> Moving average fiyattaki gürültüyü yumuşatır, trendi gösterir.
    - önceki satırla kıyaslama
    - sıralama(ranking)
    - kümülatif toplam(cumulative sum)
    - tekrar eden kayıtları bulma

    3 PARÇADAN OLUŞUYOR:

    FONKSİYON(...) OVER ( PARTITION BY ...  ORDER BY ...  ROWS BETWEEN ... )
     ↑                      ↑                 ↑               ↑
    ne hesapla         kimlerle grupla   hangi sırayla    pencere ne kadar geniş

*/