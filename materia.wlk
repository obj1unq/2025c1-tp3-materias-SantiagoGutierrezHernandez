class RequisitoDeMateria {
    method cumpleRequisito(estudiante)
}

class RequisitoDeCreditos inherits RequisitoDeMateria {
    const property creditosMinimos

    override method cumpleRequisito(estudiante){
        return estudiante.creditos() >= creditosMinimos
    }
}

class RequisitoDeMateriasPrevias inherits RequisitoDeMateria {
    const property materiasPrevias

    override method cumpleRequisito(estudiante){
        return estudiante.materiasAprobadas().intersection(materiasPrevias) == materiasPrevias
    }
}

class ListaDeEspera {
    const estudiantes = []

    method primerEstudiante(){
        return estudiantes.first()
    }

    method quitarPrimerEstudiante(){
        estudiantes.remove(estudiantes.first())
    }

    method agregarEstudiante(estudiante){
        estudiantes.add(estudiante)
    }

    method contains(estudiante) = estudiantes.contains(estudiante)
    method isEmpty() = estudiantes.isEmpty()
    method remove(estudiante) = estudiantes.remove(estudiante)
    method size() = estudiantes.size()
}

class ListaElitista inherits ListaDeEspera {
    override method agregarEstudiante(estudiante){
        super(estudiante)
        estudiantes.sortBy({e1, e2 => e1.promedio() > e2.promedio()})
    }
}

class ListaAvance inherits ListaDeEspera {
    override method agregarEstudiante(estudiante){
        super(estudiante)
        estudiantes.sortBy({e1, e2 => e1.cantidadDeAprobadas() > e2.cantidadDeAprobadas()})
    }
}

class Materia {
    const property cupos
    const property creditos
    const property requisito = null
    const property listaDeEspera = new ListaDeEspera()
    const property estudiantesInscriptos = #{}
    
    method puedeSerCursada(estudiante){
        return (
            estudiante.carrerasInscriptas().any({c => c.materias().contains(self)})
            && (requisito == null || requisito.cumpleRequisito(estudiante))
        )
    }

    method validarInscripcion(estudiante){
        if(estudiantesInscriptos.contains(estudiante)){
            self.error("El estudiante ya está inscripto en la materia")
        }
        if(listaDeEspera.contains(estudiante)){
            self.error("El estudiante ya esta en la lista de espera de la materia")
        }
    }

    method enListaDeEspera(estudiante) = listaDeEspera.contains(estudiante)

    method hayCupos() = estudiantesInscriptos.size() < cupos

    method inscribirEstudiante(estudiante){
        if(self.hayCupos()) {
            estudiante.confirmarInscripcionMateria(self)
            estudiantesInscriptos.add(estudiante)
        }
        else{
            listaDeEspera.agregarEstudiante(estudiante)
        }
    }

    method validarBaja(estudiante){
        if(!estudiantesInscriptos.contains(estudiante) && !listaDeEspera.contains(estudiante)){
            self.error("El estudiante no esta en la lista de espera ni inscripto en la materia")
        }
    }

    method darDeBaja(estudiante){
        self.validarBaja(estudiante)
        if(estudiantesInscriptos.contains(estudiante)){
            estudiantesInscriptos.remove(estudiante)
            if(!listaDeEspera.isEmpty()){
                listaDeEspera.primerEstudiante().confirmarInscripcionMateria(self)
                estudiantesInscriptos.add(listaDeEspera.primerEstudiante())
                listaDeEspera.quitarPrimerEstudiante()
            }
        }
        listaDeEspera.remove(estudiante)
    }
}