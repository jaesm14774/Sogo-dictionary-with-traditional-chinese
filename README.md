# Sogo-dictionary-with-traditional-chinese

[搜狗詞庫](https://pinyin.sogou.com/dict/)是大陸網站，收集各式各樣類型的辭典，分類極為詳細，雖然更新頻率未確定，但是一個好用的網站。

而對繁體使用者來說，使用上的困難點其一為簡體中文，其二為較麻煩的scel檔格式，而非常用txt或csv檔。

因此作者花了些時間，爬了詞庫所有字典，轉成txt檔和繁體中文格式，供使用者使用(只分成搜狗原始12大類)。

如果檔案名為數字，可參閱檔案夾下的title檔，對應的標號，可找到對應的標題。(代表有檔案涵蓋著非常用的繁體中文(或假繁體)，用R無法正確表示，
會變成unicode<U+..>格式

如果檔案為scel檔，代表用decode_scel無法正確轉換，暫無解決方法。

## 程式碼

sogo 為爬取全部詞庫

decode_scel 為解析scel檔案，並轉成txt檔存取，過程刪除錯誤轉換，以及轉成繁體中文。

rename 是將所有資料變成所代表名稱，因為下載時，直接用名稱存取的話，會出現各種問題(中文博大精深阿，汗@@)，
因此先採用數字編號，而中文存成一個title檔，最後再做轉換
