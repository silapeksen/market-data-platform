/*
    TR
    --
    Hedef: BTC'nin TL fiyatı

        BTC-USD x USDTRY = X

    Çarpabilmek için aynı dakikanın iki fiyatını aynı satıra getirmem lazım

    örn:
    clean.prices tablosu:

    ticker      datetime	close
    BTC-USD	    10:00	    85000 \__ aynı dakika
    BTC-USD	    10:01	    85010 /
    USDTRY=X	10:00	    49.0  \__ aynı dakika
    USDTRY=X	10:01	    49.1  /

    
*/