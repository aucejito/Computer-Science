package operaciones.aritmeticas;

import org.opt4j.core.Objective.Sign;
import org.opt4j.core.Objectives;
import org.opt4j.core.problem.Evaluator;

// Evalúa la calidad del fenotipo

public class CapasEvaluator implements Evaluator<int[]> {

	@Override
	public Objectives evaluate(int[] phenotype) {
		int utilidad = 0;
		for (int i = 1; i < phenotype.length; i++) {
			//suma de las utilidades de la capa anterior con la actual
			utilidad += Data.tabla[phenotype[i-1]][phenotype[i]];
		}
		
		Objectives objectives = new Objectives();
		objectives.add("Incrementar aislamiento", Sign.MAX, utilidad);
		
		return objectives;
	}

}
