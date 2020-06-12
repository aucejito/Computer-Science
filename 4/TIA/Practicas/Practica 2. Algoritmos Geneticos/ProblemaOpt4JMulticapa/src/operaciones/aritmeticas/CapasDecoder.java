package operaciones.aritmeticas;

import org.opt4j.core.genotype.IntegerGenotype;
import org.opt4j.core.genotype.PermutationGenotype;
import org.opt4j.core.problem.Decoder;

// Clase que dada un genotipo, lo convierte en su fenotipo

public class CapasDecoder implements Decoder<IntegerGenotype,int[]> {
	public int[] decode(IntegerGenotype genotype) {
		
		int[] phenotype = new int[genotype.size()]; 
		
		for (int i = 0; i < genotype.size(); i++) {
			phenotype[i] = genotype.get(i); 
		}
		
		return phenotype;
	}
}
