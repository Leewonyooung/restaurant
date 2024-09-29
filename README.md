# Must To Eat
<img width="328" alt="mustToEat" src="https://github.com/user-attachments/assets/266122a7-3152-4925-8bfa-1499e8f47808">


## ERR
<img width="489" alt="eer" src="https://github.com/user-attachments/assets/1fd2b18e-4c82-4a82-90ec-e221709eb267">

## ⚙ Organization

|    역할   |           Name           | 
|  :-----: | :----------------------: | 
|    팀장   | <center> **이원영** </center> |
|    팀원   | <center> 박상범  </center> | 
|    팀원   | <center> 한재영  </center> |


### Packages / 사용한 패키지

```
  geocoding: ^3.0.0
  geolocator: ^13.0.1
  flutter_map: ^7.0.2
  latlong2: ^0.9.1
  get: ^4.6.6
  image_picker: ^1.1.2
  sqflite: ^2.3.3+1
  path: ^1.9.0
  flutter_slidable: ^3.1.1
  dropdown_button2: ^2.3.9
  tab_indicator_styler: ^2.0.0
  pull_down_button: ^0.10.1
  http: ^1.2.2
  get_storage: ^2.1.1
```


### Must To Eat 코딩

```
Shared DB를 활용한 CRUD및 fastAPI를 사용한 API를 통해 json데이터를 통해
가져온 DB데이터로 ListView 만들기
gps기능을 통한 등록시 현재위치를 자동으로 가져오기
즐겨찾기 - 특히 즐겨 찾는 음식점을 즐겨찾기 탭으로 이동가능
검색 - 저장된 음식점 중 특히 맛있었던 집을 검색 가능.
```

### 데모 시연
<a href="http://www.youtube.com/watch?feature=player_embedded&v=qUU8KJCgIMM
" target="_blank"><img src="http://img.youtube.com/vi/qUU8KJCgIMM/0.jpg" 
alt="IMAGE ALT TEXT HERE" width="720" height="480" border="10" /></a>


## Progress

~ 9.24. 개인 프로젝트로 must_eat 앱 구현

9.25.
  FastAPI를 통한 BackEnd API구현 완료

9.26.
  API를 통해 받아온 JSON데이터를 사용하도록 Flutter 코드 수정

9.27.
  디버깅및 오류 확인, 수정, 데모 영상 촬영 및 프로젝트 문서화


## Contribution

  요약
  - Shared Database, FastAPI를 사용한 API 구현, 탭바를 활용한 앱의 전체적인 ui, 맛집 리스트 ListView, 맛집 리스트 CRUD, 즐겨찾기, 검색, 
 
  Python
  -  이원영 : Create, Read, Login
  -  박상범 : Update, Delete, router, image
  -  한재영 : image
  
  View
  -  이원영 : restaurant_list.dart, restaurant_location.dart, restaurant_tab.dart
  -  박상범 : add_restaurant.dart, favorite_restaurant.dart, search_restaurant.dart, update_restaurant.dart
  -  한재영 : update_restaurant.dart
  

  View Model
   - 이원영 : category_handler, user_handler, restaurant_handler
   - 박상범 : restaurant_handelr


  문서화 
  - 한재영
 
    
