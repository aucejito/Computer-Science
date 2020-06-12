package operaciones.aritmeticas;

import org.opt4j.core.problem.ProblemModule;

public class CapasModule extends ProblemModule {

	@Override
	protected void config() {
		bindProblem(CapasCreator.class, CapasDecoder.class, CapasEvaluator.class);
	}

}
