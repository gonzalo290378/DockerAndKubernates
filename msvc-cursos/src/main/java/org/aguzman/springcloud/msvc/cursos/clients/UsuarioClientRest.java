package org.aguzman.springcloud.msvc.cursos.clients;

import org.aguzman.springcloud.msvc.cursos.models.Usuario;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.util.List;

//COMUNICACION CON ENTRE MSVC-CURSOS (POD) -> MSVC-USUARIOS (LOCAL) HACIENDO USO DE @FeignClient(name="msvc-usuarios", url = "host.docker.internal:8001")
//COMUNICACION CON ENTRE MSVC-CURSOS (POD) -> MSVC-USUARIOS (POD) HACIENDO USO DE @FeignClient(name="msvc-usuarios", url = "msvc-usuarios:8001")
@FeignClient(name="msvc-usuarios", url = "${msvc.usuarios.url}") //COMUNICACION MEDIANTE VARIABLES DE AMBIENTE
public interface UsuarioClientRest {

    @GetMapping("/{id}")
    Usuario detalle(@PathVariable Long id);

    @PostMapping("/")
    Usuario crear(@RequestBody Usuario usuario);

    @GetMapping("/usuarios-por-curso")
    List<Usuario> obtenerAlumnosPorCurso(@RequestParam Iterable<Long> ids);
}
