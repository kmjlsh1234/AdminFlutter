# 최신 Flutter 이미지 사용
FROM ghcr.io/cirruslabs/flutter:stable AS build

# 작업 디렉토리 설정
WORKDIR /app

# 프로젝트 파일 복사
COPY . .

# Flutter 의존성 설치
RUN flutter pub get

# Flutter 웹 빌드
RUN flutter build web --no-tree-shake-icons --dart-define=BASE_URL=$BASE_URL --dart-define=FILE_SERVER_URL=$FILE_SERVER_URL --dart-define=ADMIN_FILE_SERVER_KEY=$ADMIN_FILE_SERVER_KEY

# nginx 스테이지
FROM nginx:alpine

# 빌드된 Flutter 웹 파일을 nginx 서버에 복사
COPY --from=build /app/build/web /usr/share/nginx/html

# 80 포트 노출
EXPOSE 80

# nginx 실행
CMD ["nginx", "-g", "daemon off;"]