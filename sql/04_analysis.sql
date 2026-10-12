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


    First 8 row;
    ------------
    | ticker  |      datetime       |     close
    ---------+---------------------+----------------
    | BTC-USD | 2026-10-06 00:00:00 | 85778.09375000
    | BTC-USD | 2026-10-06 00:01:00 | 85792.67187500
    | BTC-USD | 2026-10-06 00:02:00 | 85824.89062500
    | BTC-USD | 2026-10-06 00:03:00 | 85832.75781250
    | BTC-USD | 2026-10-06 00:04:00 | 85792.02343750
    | BTC-USD | 2026-10-06 00:05:00 | 85787.28125000
    | BTC-USD | 2026-10-06 00:06:00 | 85784.20312500
    | BTC-USD | 2026-10-06 00:07:00 | 85801.02343750
    (8 rows)
*/

/* 5-Minute Moving Average */
SELECT ticker, datetime, close,
 -- Function(...) OVER ( PARTITION BY ...  ORDER BY ...  ROWS BETWEEN ... )
    AVG(close) OVER ( -- AVG(close) = average, OVER = window function*** (tr: bu ortallamayı pencerede hesapla)
        PARTITION BY ticker -- PARTITION -> (tr: ticker bazında bölme, aynı ticker için hesapla farklı tickerlar için ayrı hesapla)
        ORDER BY datetime
        ROWS BETWEEN 4 PRECEDING AND CURRENT ROW -- moving average: 4 rows berfore and current row = 5 rows
    ) AS ma_5 -- 5-minute moving average
FROM clean.prices
ORDER BY ticker, datetime
LIMIT 10;

/*
    After running the query, inside of the table;

    ticker  |      datetime       |     close      |        ma_5
    ---------+---------------------+----------------+--------------------
    BTC-USD | 2026-10-06 00:00:00 | 85778.09375000 | 85778.093750000000
    BTC-USD | 2026-10-06 00:01:00 | 85792.67187500 | 85785.382812500000
    BTC-USD | 2026-10-06 00:02:00 | 85824.89062500 | 85798.552083333333
    BTC-USD | 2026-10-06 00:03:00 | 85832.75781250 | 85807.103515625000
    BTC-USD | 2026-10-06 00:04:00 | 85792.02343750 | 85804.087500000000
    BTC-USD | 2026-10-06 00:05:00 | 85787.28125000 | 85805.925000000000
    BTC-USD | 2026-10-06 00:06:00 | 85784.20312500 | 85804.231250000000
    BTC-USD | 2026-10-06 00:07:00 | 85801.02343750 | 85799.457812500000
    BTC-USD | 2026-10-06 00:08:00 | 85810.60937500 | 85795.028125000000
    BTC-USD | 2026-10-06 00:09:00 | 85826.88281250 | 85802.000000000000
    (10 rows)

*/

/************************************************************************/

/*
    TR
    --
    RETURN
    ------
    fiyatın bi önceki ana göre yüzde kaç değiştiği(tr: getiri)
    çünkü Finans analizinde ham para yerine getiriye bakılır.

    getiri = [(şimdiki fiyat - önceki fiyat) / önceki fiyat] * 100

    örn:

    datetime	close	önceki(prev_close)	hesap	            ret_1m
    10:00	    100	    NULL	            önceki yok	        NULL
    10:01	    102	    100	                (102 - 100) / 100	0.02    (%2)
    10:02	    101     102	                (101 - 102) / 102	-0.0098 (%-0.98)
    10:03	    105	    101	                (105 - 101) / 101	0.0396  (%3.96)

    *** Artış pozitif, düşüş negatif. 0 ise değişim yok.


    LAG:
    ----
    pencere kaydırmadan, sıralı tabloda bir önceki satırın değerini bu satırın yanına getirir.(Window Function ailesinden)

    LAG(close) OVER (PARTITION BY ticker ORDER BY datetime)

    "ticker’a göre grupla, zamana göre sırala, her satır için bir önceki satırın close değerini getir.”
*/

SELECT ticker, datetime, close,
       LAG(close) OVER (PARTITION BY ticker ORDER BY datetime) AS prev_close, -- bir önceki satırın close değerini getir
       
       -- işlem -> ROUND(getiri = [(şimdiki fiyat - önceki fiyat) / önceki fiyat] * 100
       ROUND((close - LAG(close) OVER (PARTITION BY ticker ORDER BY datetime)) / LAG(close) OVER (PARTITION BY ticker ORDER BY datetime) * 100,4) AS ret_1m -- 1 dakikalık return
FROM clean.prices
ORDER BY ticker, datetime
LIMIT 10;

/*
    LAG(close) -> bi önceki satırın close değeri
    prev_close -> column kotrol için
    ret_1m -> 1 dakikalık return
    (close - LAG(close)) / LAG(close) -> return hesaplaması

    ticker  |      datetime       |     close      |   prev_close   | ret_1m
    ---------+---------------------+----------------+----------------+---------
    BTC-USD | 2026-10-06 00:00:00 | 85778.09375000 |                |
    BTC-USD | 2026-10-06 00:01:00 | 85792.67187500 | 85778.09375000 |  0.0170
    BTC-USD | 2026-10-06 00:02:00 | 85824.89062500 | 85792.67187500 |  0.0376
    BTC-USD | 2026-10-06 00:03:00 | 85832.75781250 | 85824.89062500 |  0.0092
    BTC-USD | 2026-10-06 00:04:00 | 85792.02343750 | 85832.75781250 | -0.0475
    BTC-USD | 2026-10-06 00:05:00 | 85787.28125000 | 85792.02343750 | -0.0055
    BTC-USD | 2026-10-06 00:06:00 | 85784.20312500 | 85787.28125000 | -0.0036
    BTC-USD | 2026-10-06 00:07:00 | 85801.02343750 | 85784.20312500 |  0.0196
    BTC-USD | 2026-10-06 00:08:00 | 85810.60937500 | 85801.02343750 |  0.0112
    BTC-USD | 2026-10-06 00:09:00 | 85826.88281250 | 85810.60937500 |  0.0190
    (10 rows)
*/