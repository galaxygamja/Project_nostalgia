이 폴더는 실제 게임 데이터 전용이다.

현재 20개 JSON은 game_json_templates의 non-양식 JSON을 byte-identical로 복사한
runtime 입력이다. SHA-256은 RUNTIME_DATA_SHA256.txt에서 확인한다.
authoring 원본과 *_양식.json, 설명서는 이 폴더에 넣거나 수정하지 않는다.

현재 입력은 알려진 reference 오류 때문에 stop_on_validation_error=true에서
bootstrap 실패가 정상이다. 이 실패를 숨기거나 ID를 자동 생성하지 않는다.

필수 파일 목록은 scripts/data/data_bootstrap.gd의 REQUIRED_DATA_FILES를 참고한다.
