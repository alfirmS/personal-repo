# How to Configuration Partner Mobile
--------------------------------------

1. Main.dart -> Location : ***config/.main-${environment}.dart***  
   - Main.Dart digunakan untuk keperluan perubahan environtment saja,
   perubahan ini dilakukan pada sekitar line 30-35. contoh :  
   ``` ConfigURL().setEnvironment(Environment.PROD) ```  
   Main.dart dapat berubah seiring development berjalan.  
   > Note : pastikan main.dart yang di location adalah main.dart terbaru yang  
   diambil dari /lib/main.dart
2. Config_Url.dart -> Location : ***config/Config_Url-${environment}.dart***  
   - Config_url digunakan untuk management path pada endpoint yang digunakan oleh aplikasi,
   config_url juga digunakan untuk manaruh beberapa variable yang akan digunakan nanti pada
   `url_${envi}`.  
   > Note : Config_url harus dipastikan terbaru mengambil dari lib/utils/config_url.dart
3. Url.dart -> Location : ***lib/utils/url/url_${envi}.dart***  
   - `url.dart` digunakan untuk memanagment configuration url serta secret untuk tyk dan keyclock,  
   url.dart dipisahkan sesuai dengan environment yang akan digunakan. Contoh :  
   > Url_Prod.dart -> Digunakan untuk environtment prod
4. Application Package Name  
   Penamaan package aplikasi harus disesuaikan dengan environment yang digunakan sehingga 
   tidak ada crash saat aplikasi telah berhasil di build. Penamaan package aplikasi terdapat
   di beberapa folder, yaitu :  
   - ` android/app/build.gradle`  
   - `謹 android/app/src/profile/AndroidManifest.xml`  
   - `謹 android/app/src/main/AndroidManifest.xml`  
   - `謹 android/app/src/debug/AndroidManifest.xml`  
   - ` android/app/src/main/kotlin/com/example/adira_one_partner/MainActivity.kt`
5. Jenkinsfile  
   Pastikan di dalam Jenkinsfile Config_Url-${envi}.dart dan main.dart telah di 
   move ke folder yang seharusnya, berikut scipt yang dibutuhkan di jenkinsfile  
   > `mv config/config_url-stg.dart lib/utils/config_url.dart`
   > `mv config/.main-stg.dart lib/main.dart`