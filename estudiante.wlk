import materia.*
import nota_materia.*

class Estudiante {
    const property nombre
    const property materiasInscriptas = #{}
    const property carrerasInscriptas = #{}
    const notasObtenidas = []

    method validarNota(nota) {
        if(!carrerasInscriptas.any({c => c.materias().contains(nota.materia())})){
            self.error("El estudiante no esta cursando ninguna carrera con dicha materia")
        }
        if(!materiasInscriptas.contains(nota.materia())){
            self.error("El estudiante no puede obtener una nota en una materia que no cursa")
        }
        if(notasObtenidas.any({n => n.materia() == nota.materia() && n.aprobada()})){
            self.error("El estudiante ya aprobo esta materia")
        }
    }

    method validarInscripcion(materia){
        if(!materia.puedeSerCursada(self)){
            self.error("El estudiante no cumple los requisitos para inscribirse a la materia")
        }
        if(materiasInscriptas.contains(materia)){
            self.error("El estudiante ya esta inscripto en la materia")
        }
        if(self.materiasAprobadas().contains(materia)){
            self.error("El estudiante ya aprobo la materia")
        }
    }

    method confirmarInscripcionMateria(materia){
        self.validarInscripcion(materia)
        materiasInscriptas.add(materia)
    }

    method inscribirCarrera(carrera){
        carrerasInscriptas.add(carrera)   
    }

    method bajaDeMateria(materia){
        materiasInscriptas.remove(materia)
        materia.darDeBaja(self)
    }

    method registrarNota(materia, calificacion) {
        const nota = new NotaDeMateria(materia=materia, nota=calificacion)
        self.validarNota(nota)
        notasObtenidas.add(nota)
        if(nota.aprobada()){
            self.bajaDeMateria(nota.materia())
        }
    }

    method materiasAprobadas() {
        return notasObtenidas.filter({n => n.aprobada()}).map({n => n.materia()}).asSet()
    }

    method cantidadDeAprobadas() = self.materiasAprobadas().size()

    method estaAprobada(materia) {
        return !notasObtenidas.filter({n => n.materia() == materia && n.aprobada()}).isEmpty()
    }

    method promedio() {
        return notasObtenidas.sum({n => n.nota()}) / notasObtenidas.size()
    }
}