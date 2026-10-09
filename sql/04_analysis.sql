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
ORDER BY ticker, datetime;

/*
    After running the query, inside of the table;
    ---------------------------------------------------------------------
    | ticker  |      datetime       |     close      |        ma_5
    ---------+---------------------+----------------+--------------------
    | BTC-USD | 2026-10-06 00:00:00 | 85778.09375000 | 85778.093750000000
    | BTC-USD | 2026-10-06 00:01:00 | 85792.67187500 | 85785.382812500000
    | BTC-USD | 2026-10-06 00:02:00 | 85824.89062500 | 85798.552083333333
    | BTC-USD | 2026-10-06 00:03:00 | 85832.75781250 | 85807.103515625000
    | BTC-USD | 2026-10-06 00:04:00 | 85792.02343750 | 85804.087500000000
    | BTC-USD | 2026-10-06 00:05:00 | 85787.28125000 | 85805.925000000000
    | BTC-USD | 2026-10-06 00:06:00 | 85784.20312500 | 85804.231250000000
    | BTC-USD | 2026-10-06 00:07:00 | 85801.02343750 | 85799.457812500000
    | BTC-USD | 2026-10-06 00:08:00 | 85810.60937500 | 85795.028125000000
    | BTC-USD | 2026-10-06 00:09:00 | 85826.88281250 | 85802.000000000000

*/