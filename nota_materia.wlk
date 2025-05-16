class NotaDeMateria {
    const property nota
    const property materia

    const notaMinimaAprobado = 7

    method aprobada(){
        return nota >= notaMinimaAprobado
    }
}