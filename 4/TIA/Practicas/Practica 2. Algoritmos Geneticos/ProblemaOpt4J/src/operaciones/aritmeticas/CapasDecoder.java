package operaciones.aritmeticas;

import org.opt4j.core.genotype.PermutationGenotype;
import org.opt4j.core.problem.Decoder;

// Clase que dada un genotipo, lo convierte en su fenotipo

public class CapasDecoder implements Decoder<PermutationGenotype<Integer>,int[]> {
	public int[] decode(PermutationGenotype<Integer> genotype) {
		
		int[] phenotype = new int[genotype.size()]; 
		
		for (int i = 0; i < genotype.size(); i++) {
			phenotype[i] = genotype.get(i); 
		}
		
		return phenotype;
	}
}
