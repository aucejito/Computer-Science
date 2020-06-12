package operaciones.aritmeticas;

import java.util.Arrays;
import java.util.Random;

import org.opt4j.core.genotype.IntegerGenotype;
import org.opt4j.core.genotype.PermutationGenotype;
import org.opt4j.core.problem.Creator;

// Crea el genotipo del individuo

public class CapasCreator implements Creator<IntegerGenotype> {
	
	@Override
	public IntegerGenotype create() {
		IntegerGenotype genotype = new IntegerGenotype(0, Data.capas.length-1);
		genotype.init(new Random(), Data.capas.length); //Instanciamos el genotipo con valores aleatorios y con la longitud del vector "capas"
		return genotype; //devolvemos el genotipo
	}
}
