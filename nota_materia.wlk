class NotaDeMateria {
    const property nota
    const property materia

    const notaMinimaAprobado = 4

    method aprobada(){
        return nota >= notaMinimaAprobado
    }
}