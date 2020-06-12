package operaciones.aritmeticas;

import java.util.Arrays;
import java.util.Random;

import org.opt4j.core.genotype.PermutationGenotype;
import org.opt4j.core.problem.Creator;

// Crea el genotipo del individuo

public class CapasCreator implements Creator<PermutationGenotype<Integer>> {
	
	@Override
	public PermutationGenotype<Integer> create() {
		PermutationGenotype<Integer> genotype = new PermutationGenotype<Integer>(Arrays.asList(Data.capas));
		genotype.init(new Random()); //Instanciamos el genotipo con valores aleatorios
		return genotype; //devolvemos el genotipo
	}
}
