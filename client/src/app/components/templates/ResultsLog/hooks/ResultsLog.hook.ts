import { useCallback, useEffect, useState } from 'react';
import { useHistory } from 'react-router';
import { ROUTES } from '../../../../Routes';
import { ResultLog } from '../../../../shared/model/results.model';
import { getComparisonResults } from '../../../../shared/utils/api.utils';

const useResultsLog = () => {
  const [results, setResults] = useState<ResultLog[]>([]);
  const history = useHistory();
  const getResultsLog = useCallback(async () => {
    try {
      const resultsLog = await getComparisonResults();
      setResults(resultsLog);
    } catch (error) {
      console.log({ error });
      alert('Could not get Results of Previous Comparisons');
      history.replace(ROUTES.DASHBOARD);
    }
  }, [history]);

  useEffect(() => {
    getResultsLog();
  }, [getResultsLog]);

  return { results, history };
};

export default useResultsLog;
