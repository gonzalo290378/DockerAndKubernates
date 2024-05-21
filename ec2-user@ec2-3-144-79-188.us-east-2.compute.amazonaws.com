#ESPECIFICACION O VERSION DE DOCKER-COMPOSE
version: "3.9"
#LOS SERVICES SON LOS CONTENEDORES
services:
  mysql-usuarios:
    container_name: mysql-usuarios
    image: mysql:8
    ports:
      - "3304:3306"
    environment:
      MYSQL_ROOT_PASSWORD: granada290378
      MYSQL_DATABASE: msvc_usuarios
    volumes:
      - data-mysql-usuarios:/var/lib/mysql
    restart: always
    networks:
      - spring

  mysql-cursos:
    container_name: mysql-cursos
    image: mysql:8
    ports:
      - "3305:3306"
    environment:
      MYSQL_ROOT_PASSWORD: granada290378
      MYSQL_DATABASE: msvc_cursos
    volumes:
      - data-mysql-cursos:/var/lib/mysql
    restart: always
    networks:
      - spring

  msvc-usuarios:
    container_name: msvc-usuarios
    #Construccion de la imagen
    #    build:
    #      context: ./
    #      dockerfile: ./msvc-usuarios/Dockerfile
    image: gonzalo290378/usuarios
    ports:
      - "8001:8001"
    #    ENVIRONMENT LOCAL
    #    env_file: ./msvc-usuarios/.env
    environment:
      PORT: 8001
      DB_HOST: mysql-usuarios:3306
      DB_DATABASE: msvc_usuarios
      DB_USERNAME: root
      DB_PASSWORD: granada290378
      CURSOS_URL: msvc-cursos:8002
    networks:
      - spring
    depends_on:
      - mysql-usuarios
    restart: always

  msvc-cursos:
    container_name: msvc-cursos
    #Construccion de la imagen
    #    build:
    #      context: ./
    #      dockerfile: ./msvc-cursos/Dockerfile
    image: gonzalo290378/cursos
    ports:
      - "8002:8002"
    #    ENVIRONMENT LOCAL
    #    env_file: ./msvc-usuarios/.env
    environment:
      PORT: 8002
      DB_HOST: mysql-cursos:3306
      DB_DATABASE: msvc_cursos
      DB_USERNAME: root
      DB_PASSWORD: granada290378
      USUARIOS_URL: msvc-usuarios:8001
    networks:
      - spring
    depends_on:
      - mysql-cursos
      - msvc-usuarios
    restart: always

#CONFIGURACION DE LOS VOLUMES PARA CADA BASE CON EL FIN DE SER SER UTILIZADA EN SERVICES
volumes:
  data-mysql-cursos:
    name: data-mysql-cursos
  data-mysql-usuarios:
    name: data-mysql-usuarios

#CONFIGURACION DE LA NETWORD SPRING CON EL FIN SER UTILIZADA EN SERVICES
networks:
  spring:
    name: spring